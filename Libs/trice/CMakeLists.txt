set(LIB_NAME trice)
set(HMT_PROJECT_LIB_DIR ${CMAKE_CURRENT_LIST_DIR})
set(PROJECT_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../../)

# Create project code library
file(GLOB_RECURSE PROJECT_SOURCES 
        "${CMAKE_CURRENT_LIST_DIR}/trice-config/Src/*.c" 
        "${CMAKE_CURRENT_LIST_DIR}/trice-config/Src/*.cpp"
        "${CMAKE_CURRENT_LIST_DIR}/trice/*.c"
        "${CMAKE_CURRENT_LIST_DIR}/trice/*.cpp"
)

add_library(${LIB_NAME} STATIC
        ${PROJECT_SOURCES}
)

file(GLOB INC_DIRS LIST_DIRECTORIES true CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/Modules/*)

# Filter only directories that end with "/Inc"
set(MODULE_INC_DIRS "")
foreach(dir ${INC_DIRS})
    if (IS_DIRECTORY ${dir} AND dir MATCHES ".*/Inc$")
        list(APPEND MODULE_INC_DIRS ${dir})
    endif()
endforeach()

target_include_directories(${LIB_NAME} PUBLIC
        ${MODULE_INC_DIRS}
        "${CMAKE_CURRENT_LIST_DIR}/trice-config/Inc" 
        "${CMAKE_CURRENT_LIST_DIR}/trice/"
)

# Add the STM32 headers to the project library.
# That way the compiler can know where to find the header files.
# These are then later linked in.
# Still it ignores the warnings on the include dirs by using SYSTEM INTERFACE
include("${PROJECT_ROOT_DIR}/cmake/stm32-core.cmake")

target_link_libraries(${LIB_NAME}
    STM32_HEADERS
)

add_library(triceInterface ALIAS ${LIB_NAME})