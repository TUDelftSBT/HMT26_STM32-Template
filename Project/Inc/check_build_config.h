#pragma once

bool isBuiltInDebugMode() {
    #ifdef DEBUG
        return true;
    #else
        return false;
    #endif
}
