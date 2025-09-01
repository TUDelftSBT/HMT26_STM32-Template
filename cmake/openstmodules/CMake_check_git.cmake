set(CURRENT_LIST_DIR ${CMAKE_SOURCE_DIR})
if (NOT DEFINED pre_configure_dir)
    set(pre_configure_dir ${CMAKE_SOURCE_DIR})
endif ()

if (NOT DEFINED post_configure_dir)
    set(post_configure_dir ${CMAKE_CURRENT_BINARY_DIR}/generated)
endif ()

set(pre_configure_file ${pre_configure_dir}/Core/Src/version.c.in)
set(post_configure_file ${post_configure_dir}/git/version.c)

function(CheckGitWrite git_hash)
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/git-state.txt ${git_hash})
endfunction()

function(CheckGitRead git_hash)
    if (EXISTS ${CMAKE_CURRENT_BINARY_DIR}/git-state.txt)
        file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/git-state.txt CONTENT)
        LIST(GET CONTENT 0 var)

        set(${git_hash} ${var} PARENT_SCOPE)
    endif ()
endfunction()

function(check_git_version)
    # Get the latest abbreviated commit hash of the working branch
    execute_process(
            COMMAND git rev-parse --short=6 HEAD
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            RESULT_VARIABLE GIT_RESULT
    )

    CheckGitRead(GIT_HASH_CACHE)

    if (NOT EXISTS ${post_configure_dir})
        file(MAKE_DIRECTORY ${post_configure_dir})
    endif ()

    if (NOT EXISTS ${post_configure_dir}/git/version.h)
        file(COPY ${pre_configure_dir}/Core/Inc/version.h DESTINATION ${post_configure_dir}/git)
    endif()

    if (NOT DEFINED GIT_HASH_CACHE)
        set(GIT_HASH_CACHE "INVALID")
    endif ()

    # Only update the git_version.cpp if the hash has changed. This will
    # prevent us from rebuilding the project more than we need to.
    if (GIT_RESULT EQUAL 0 AND (NOT ${GIT_HASH} STREQUAL ${GIT_HASH_CACHE} OR NOT EXISTS ${post_configure_file}))
        # Set the GIT_HASH_CACHE variable so the next build won't have
        # to regenerate the source file.
        CheckGitWrite(${GIT_HASH})

        configure_file(${pre_configure_file} ${post_configure_file} @ONLY)
    endif ()
endfunction()

function(check_git_setup)

    add_custom_target(AlwaysCheckGit COMMAND ${CMAKE_COMMAND}
            -DRUN_CHECK_GIT_VERSION=1
            -Dpre_configure_dir=${pre_configure_dir}
            -Dpost_configure_file=${post_configure_dir}
            -DGIT_HASH_CACHE=${GIT_HASH_CACHE}
            -P ${CURRENT_LIST_DIR}/cmake/openstmodules/CMake_check_git.cmake
            BYPRODUCTS ${post_configure_file}
    )

    add_library(git_version ${CMAKE_CURRENT_BINARY_DIR}/generated/git/version.c )
    target_include_directories(git_version PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/generated/git)
    add_dependencies(git_version AlwaysCheckGit)

    check_git_version()
endfunction()

# This is used to run this function from an external cmake process.
if (RUN_CHECK_GIT_VERSION)
    check_git_version()
endif ()
