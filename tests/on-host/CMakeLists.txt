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

include(${PROJECT_ROOT_DIR}/Project/hmt-compile-project-lib.cmake)

file(GLOB_RECURSE MODULE_SOURCES CONFIGURE_DEPENDS
        "${PROJECT_ROOT_DIR}/Modules/**.c"
        "${PROJECT_ROOT_DIR}/Modules/**.cpp"
)

# TODO: Fix this for when modules are installed
if(MODULE_SOURCES)
    add_library(HMT_MODULES_LIB STATIC
            ${MODULE_SOURCES}
    )
    target_link_libraries(HMT_PROJECT_LIB HMT_MODULES_LIB)
endif()


target_include_directories(HMT_PROJECT_LIB PUBLIC
        "${PROJECT_ROOT_DIR}/Project/Inc"
        "${PROJECT_ROOT_DIR}/Modules/"
)

target_compile_definitions(HMT_PROJECT_LIB PUBLIC UNIT_TEST)

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_LIST_DIR}/**.cpp"
        "${CMAKE_CURRENT_LIST_DIR}/**.c"
)

add_executable(unit_tests
        ${TEST_SOURCES}
)

target_include_directories(unit_tests PRIVATE
        "${CMAKE_CURRENT_LIST_DIR}"
        "${CMAKE_CURRENT_LIST_DIR}/fakes"
        "${CMAKE_CURRENT_LIST_DIR}/header-overrides"
)

target_link_libraries(unit_tests PRIVATE
        HMT_PROJECT_LIB
        GTest::gtest_main
)

# Used for STATIC keyword
target_compile_definitions(unit_tests PUBLIC
        TESTING
)

include(GoogleTest)
gtest_discover_tests(unit_tests)
