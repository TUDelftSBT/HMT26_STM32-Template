string(REPLACE " " ";" MODULE_LIST_PARSED "${MODULE_LIST}")

message(STATUS "Calculating size of modules: ${MODULE_LIST_PARSED} in ${SIZE_OUTPUT}.")

file(WRITE ${SIZE_OUTPUT} "=== Object Size Report ===\n")
foreach(module ${MODULE_LIST_PARSED})
    set(OBJ_DIR "${CMAKE_BINARY_DIR}/CMakeFiles/${module}.dir")
    message(STATUS "Looking in dir: ${OBJ_DIR}")
    file(GLOB_RECURSE OBJS "${OBJ_DIR}/*.obj")
    message(STATUS "Found objects: ${OBJS}")

    if(OBJS)
        file(APPEND ${SIZE_OUTPUT} "\nModule: ${module}\n")
        file(APPEND ${SIZE_OUTPUT} "-------------------------\n")

        foreach(obj ${OBJS})
            execute_process(
                    COMMAND arm-none-eabi-size "${obj}"
                    OUTPUT_VARIABLE SIZE_OUT
                    OUTPUT_STRIP_TRAILING_WHITESPACE
            )
            file(APPEND ${SIZE_OUTPUT} "${SIZE_OUT}\n")
        endforeach()
    endif()
endforeach()
