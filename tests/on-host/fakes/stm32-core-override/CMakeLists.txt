set(PROJECT_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../../../../)

set(LIB_NAME STM32_HEADERS_MOCK)
add_library(${LIB_NAME} INTERFACE)

# These are the include dirs of the variable: MX_Include_Dirs
# from the STM32Cube generated cmake file.
target_include_directories(${LIB_NAME} SYSTEM INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}
    ${PROJECT_ROOT_DIR}/Core/Inc
)

# Also copied from the STM32Cube cmake file.
target_compile_definitions(${LIB_NAME} INTERFACE
	USE_HAL_DRIVER 
	STM32F446xx
)

add_library(STM32_HEADERS_INTERFACE ALIAS ${LIB_NAME})