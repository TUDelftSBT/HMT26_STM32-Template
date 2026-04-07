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

file(GLOB TEST_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/**/**.cpp"
)

add_executable(unit_tests
        ${TEST_SOURCES}
)

file(GLOB_RECURSE INC_DIRS LIST_DIRECTORIES true CONFIGURE_DEPENDS ${PROJECT_ROOT_DIR}/Modules/*)

# Filter only directories that end with "/Inc"
set(MODULE_INC_DIRS "")
foreach(dir ${INC_DIRS})
    if (IS_DIRECTORY ${dir} AND dir MATCHES ".*/Inc$")
        list(APPEND MODULE_INC_DIRS ${dir})
    endif()
endforeach()

target_include_directories(unit_tests PUBLIC
    "${CMAKE_CURRENT_LIST_DIR}"
    "${CMAKE_CURRENT_LIST_DIR}/fakes"
    ${MODULE_INC_DIRS}
)

add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/fakes/stm32-core-override")
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/fakes/trice")

get_filename_component(ABS_PATH_TO_EXCLUDE
                       "${PROJECT_ROOT_DIR}/Project/Src/app.cpp"
                       ABSOLUTE)
set(EXCLUDED_SOURCES ${ABS_PATH_TO_EXCLUDE})

add_subdirectory(
    "${PROJECT_ROOT_DIR}/Project"
    "${CMAKE_BINARY_DIR}/Project"
)

target_link_libraries(unit_tests PUBLIC
    STM32_HEADERS_INTERFACE
    triceInterface
    HMT_PROJECT_LIB
    GTest::gtest_main
)

# Used for STATIC keyword
target_compile_definitions(unit_tests PUBLIC
    TESTING
)

# Precompile the library headers
# as they are very big and are not changed anyway
target_precompile_headers(unit_tests PUBLIC
    <gtest/gtest.h>
    "fakes/fff.h"
)

include(GoogleTest)
gtest_discover_tests(unit_tests)
