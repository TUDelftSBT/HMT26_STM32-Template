add_library(HMT_project_compile_flags INTERFACE)

# https://www.reddit.com/r/embedded/comments/1exl3r8/what_compiler_flags_do_you_guys_use_for_day_to/
target_compile_options(HMT_project_compile_flags INTERFACE
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