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

function(process_modules_from_file file_path)
    if(NOT EXISTS "${file_path}")
        message(WARNING "Repo list not found: ${file_path}")
        return()
    endif()

    get_filename_component(abs_file_path "${file_path}" ABSOLUTE)
    list(FIND PROCESSED_MODULES "${abs_file_path}" already)
    if(NOT already EQUAL -1)
        return()
    endif()
    list(APPEND PROCESSED_MODULES "${abs_file_path}")
    set(PROCESSED_MODULES "${PROCESSED_MODULES}" PARENT_SCOPE)

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

            message(STATUS "Processing ${url} → ${CMAKE_SOURCE_DIR}/Modules/${dir}")
            download_git_repo("${url}" "${tag}" "${CMAKE_SOURCE_DIR}/Modules/${dir}")

            # Add the cloned repo to the build
            if(EXISTS "${CMAKE_SOURCE_DIR}/Modules/${dir}/CMakeLists.txt")
                add_subdirectory("${CMAKE_SOURCE_DIR}/Modules/${dir}")
            endif()

            # Recursively check for modules.txt inside the downloaded repo
            set(submodules_file "${CMAKE_SOURCE_DIR}/Modules/${dir}/modules.txt")
            if(EXISTS "${submodules_file}")
                message(STATUS "Found nested modules.txt in ${dir}, processing...")
                process_repos_from_file("${submodules_file}")
            endif()
        endif()
    endforeach()
endfunction()