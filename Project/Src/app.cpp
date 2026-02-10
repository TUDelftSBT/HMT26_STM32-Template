//
// Created by Teund on 02/02/2026.
//

#include "app.h"

#include "trice.h"

void app_init(void) {
    // Initialization of the application
    TriceInit();
    trice("hello");
}

void app_loop(void) {
    __asm__("nop"); // nop does nothing

    // but cool code can go here
}
