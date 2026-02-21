#include "check_build_config.h"

// Must be in its own cpp file, 
// Because only then the preprocessor value is used 
// form the time of library compilation.
// otherwise it takes the preprocessor value of the 
// code using the library.

// We want to know what type the library is compiled in. Since that 
// is needed in order to prevent the code from hanging while sailing.

bool isBuiltInDebugMode() {
    #if not DEBUG
        return false;
    #else
        return true;
    #endif
}