function(download_git_repo repo_url repo_tag dest_dir)
    if(NOT EXISTS ${dest_dir}/.git)
        message(STATUS "Cloning ${repo_url} into ${dest_dir}")
        execute_process(
                COMMAND git clone --branch ${repo_tag} --depth 1 ${repo_url} ${dest_dir}
                RESULT_VARIABLE res
        )
        if(NOT res EQUAL 0)
            message(FATAL_ERROR "Failed to clone ${repo_url}")
        endif()
    else()
        message(STATUS "Updating ${dest_dir}")
        execute_process(
                COMMAND git -C ${dest_dir} fetch origin
        )
        execute_process(
                COMMAND git -C ${dest_dir} reset --hard origin/${repo_tag}
        )
    endif()
endfunction()

set(PROCESSED_MODULES "")

function(process_modules_from_file file_path parent)
    if(NOT EXISTS "${file_path}")
        message(WARNING "Repo list not found: ${file_path}")
        return()
    endif()

    file(READ "${file_path}" repo_list)
    string(REPLACE "\n" ";" repo_list "${repo_list}")

    foreach(line ${repo_list})
        string(STRIP "${line}" line)
        if(NOT line STREQUAL "")
            string(REGEX MATCHALL "[^ \t]+" tokens "${line}")
            list(LENGTH tokens len)
            if(len LESS 3)
                message(WARNING "Invalid repo line: ${line}")
                continue()
            endif()

            list(GET tokens 0 dir)
            list(GET tokens 1 url)
            list(GET tokens 2 tag)

            list(FIND PROCESSED_MODULES "${dir}" already)
            if(NOT already EQUAL -1)
                message(STATUS "Skipping ${dir} download, since it is already processed. Still linking...")
                if(TARGET ${parent} AND TARGET ${dir})
                    target_link_libraries(${parent} PUBLIC ${dir})
                    message(STATUS "Added module as library: ${dir} to ${parent}")
                    list(APPEND MODULE_LIBS ${dir})
                endif()
                continue()
            endif()

            message(STATUS "Processing ${url} → ${CMAKE_SOURCE_DIR}/Modules/${dir}")
            download_git_repo("${url}" "${tag}" "${CMAKE_SOURCE_DIR}/Modules/${dir}")

            # Add the cloned repo to the build
            if(EXISTS "${CMAKE_SOURCE_DIR}/Modules/${dir}/CMakeLists.txt")
                add_subdirectory("${CMAKE_SOURCE_DIR}/Modules/${dir}")
            endif()

            # Automatically add each module as its own static library
            set(MOD_SRC_DIR ${CMAKE_SOURCE_DIR}/Modules/${dir}/Src)
            set(MOD_INC_DIR ${CMAKE_SOURCE_DIR}/Modules/${dir}/Inc)

            if (IS_DIRECTORY ${MOD_SRC_DIR} AND IS_DIRECTORY ${MOD_INC_DIR})
                file(GLOB_RECURSE MOD_SOURCES ${MOD_SRC_DIR}/*.c ${MOD_SRC_DIR}/*.cpp)

                if (MOD_SOURCES)
                    if(NOT TARGET ${target_name})
                        add_library(${dir} STATIC ${MOD_SOURCES})
                        target_include_directories(${dir} PUBLIC ${MOD_INC_DIR})
                    endif()

                    # Recursively check for modules.txt inside the downloaded repo
                    set(submodules_file "${CMAKE_SOURCE_DIR}/Modules/${dir}/modules.txt")
                    if(EXISTS "${submodules_file}")
                        message(STATUS "Found nested modules.txt in ${dir}, processing...")
                        process_modules_from_file("${submodules_file}" ${dir})
                    endif()

                    if(TARGET ${parent} AND TARGET ${dir})
                        target_link_libraries(${parent} PUBLIC ${dir})
                        message(STATUS "Added module as library: ${dir} to ${parent}")
                        list(APPEND MODULE_LIBS ${dir})
                    endif()
                else()
                    message(STATUS "Skipped module '${dir}': No source files found")
                endif()
            else()
                message(STATUS "Skipped module '${dir}': Missing Src/ or Inc/")
            endif()

            list(APPEND PROCESSED_MODULES "${dir}")
            set(PROCESSED_MODULES "${PROCESSED_MODULES}" PARENT_SCOPE)
        endif()
    endforeach()
endfunction()