# This CMakeLists contains three libraries.
# The Trice Config, the Trice Lib and the Trice Config Lib.

# Trice Config:
#     - contains the trice configuration files

# Trice Lib:
#     - Contains Trice source code

# Trice Config Lib:
#     - Contains the uart configuration.
#     - Is required because it is dependent on the Trice Lib, the Trice Config and the HAL.

set(PROJECT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(PROJECT_ROOT_DIR ${PROJECT_DIR}/../../)
set(TRICE_CONFIG_DIR ${PROJECT_DIR}/trice-config/)
set(TRICE_SOURCE_DIR ${PROJECT_DIR}/trice/)

# Trice config
add_library(TRICE_CONFIG INTERFACE)

target_include_directories(TRICE_CONFIG
    SYSTEM INTERFACE ${TRICE_CONFIG_DIR}/Inc
)

# Trice Lib
file(GLOB_RECURSE PROJECT_SOURCES
     CONFIGURE_DEPENDS
     ${TRICE_SOURCE_DIR}/*.c
     ${TRICE_SOURCE_DIR}/*.cpp
)

add_library(TRICE_LIB STATIC
        ${PROJECT_SOURCES}
)

target_include_directories(TRICE_LIB 
        SYSTEM PUBLIC ${TRICE_SOURCE_DIR}
)

target_link_libraries(TRICE_LIB PUBLIC TRICE_CONFIG)


# Trice Config Lib
file(GLOB_RECURSE PROJECT_SOURCES
     CONFIGURE_DEPENDS
     ${TRICE_CONFIG_DIR}/*.c
     ${TRICE_CONFIG_DIR}/*.cpp
)

add_library(TRICE_CONFIG_LIB STATIC
    ${PROJECT_SOURCES}
)

target_include_directories(TRICE_CONFIG_LIB PUBLIC
    ${TRICE_CONFIG_DIR}/Inc
)

include("${PROJECT_ROOT_DIR}/cmake/stm32-core.cmake")
target_link_libraries(TRICE_CONFIG_LIB PUBLIC TRICE_LIB TRICE_CONFIG STM32_HEADERS)
