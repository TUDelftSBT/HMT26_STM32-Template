# The reason to create a seperate library for the project code, is that you want to _ONLY_ compile the project code
# with all these flags. Since we compile in pedantic, all warnings will turn into errors. When using third party libs,
# This can get very annoying and even unmanageable. Hence we only apply these flags to our own code by creating a library.
# You also do not want to use these options for the automatically generated code from STMCube.

set(HMT_PROJECT_LIB_DIR ${CMAKE_CURRENT_LIST_DIR})

# Create project code library
file(GLOB_RECURSE PROJECT_SOURCES "${HMT_PROJECT_LIB_DIR}/**.c" "${HMT_PROJECT_LIB_DIR}/**.cpp")
add_library(HMT_PROJECT_LIB STATIC
        ${PROJECT_SOURCES}
)

target_include_directories(HMT_PROJECT_LIB PUBLIC
        "${HMT_PROJECT_LIB_DIR}/Inc/"
)

# Add project symbols (macros)
target_compile_definitions(HMT_PROJECT_LIB PRIVATE
    # Add user defined symbols
    DEBUG=$<BOOL:$<CONFIG:Debug>>
)


# https://www.reddit.com/r/embedded/comments/1exl3r8/what_compiler_flags_do_you_guys_use_for_day_to/
target_compile_options(HMT_PROJECT_LIB PRIVATE
    -Wall
    -Wextra
    -Werror
    -pedantic
    -Wduplicated-cond
    -Wduplicated-branches
    -Wlogical-op
    -Wnull-dereference
    -Wshadow
    -Wpointer-arith
    -Wdangling-else
    -Wrestrict
    -Wdouble-promotion
    -Wvla
    -Wswitch-enum
    -Wswitch-default
    -Winvalid-pch
    -Wodr
)