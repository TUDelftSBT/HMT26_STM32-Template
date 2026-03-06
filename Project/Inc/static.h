// File synced from HMT26_Template
// Do not change

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Use the STATIC keyword for static variables
// That way they are still visible when testing

// https://github.com/ThrowTheSwitch/CMock/issues/288
#ifdef TESTING
    #define STATIC static
#else
    #define STATIC
#endif

#ifdef __cplusplus
}
#endif
