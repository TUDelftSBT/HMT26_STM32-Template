set(LIB_NAME triceMock)
set(HMT_PROJECT_LIB_DIR ${CMAKE_CURRENT_LIST_DIR})
set(PROJECT_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../../)

add_library(${LIB_NAME} STATIC
    triceMock.c
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
        "${CMAKE_CURRENT_LIST_DIR}"
)

add_library(triceInterface ALIAS ${LIB_NAME})