cmake_minimum_required(VERSION 3.20)
project(HMT26_HostTests LANGUAGES C CXX)

set(PROJECT_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

include(FetchContent)

FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

enable_testing()

file(GLOB_RECURSE MODULE_SOURCES CONFIGURE_DEPENDS
        "${PROJECT_ROOT_DIR}/Modules/**.c"
        "${PROJECT_ROOT_DIR}/Modules/**.cpp"
)

# The project files are from the project lib
add_library(hmt_code_under_test STATIC
        ${MODULE_SOURCES}
)

include(${PROJECT_ROOT_DIR}/cmake/hmt-compile-project-lib.cmake)
target_link_libraries(hmt_code_under_test HMT_PROJECT_LIB)

target_include_directories(hmt_code_under_test PUBLIC
        "${CMAKE_CURRENT_LIST_DIR}/Project/Inc"
        # "${CMAKE_CURRENT_LIST_DIR}/../Modules/SomeModule/Inc"
)

target_compile_definitions(hmt_code_under_test PUBLIC UNIT_TEST)

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_LIST_DIR}/**.cpp"
        "${CMAKE_CURRENT_LIST_DIR}/**.c"
)

add_executable(unit_tests
        ${TEST_SOURCES}
)

target_link_libraries(unit_tests PRIVATE
        hmt_code_under_test
        GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(unit_tests)
