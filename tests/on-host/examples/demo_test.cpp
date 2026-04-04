#include <gtest/gtest.h>
#include "check_build_config.h"

#include "testing.hpp"
#include "database.h"

#include "fff.h"
DEFINE_FFF_GLOBALS;

TEST(Sanity, FrameworkRuns)
{
    EXPECT_EQ(2 + 2, 4);
}

TEST(Sanity, BuiltInDebugMode)
{
    // Enough of a check, since the DEBUG compile definition is only set when in Debug mode.
    // Otherwise it is not set.
    EXPECT_TRUE(isBuiltInDebugMode());
}

TEST(Sanity, TriceWorking)
{
    Trice("Hello Testing world!\n");
    // When making this test fail, it prints to the screen.
    EXPECT_TRUE(true);
}

TEST(Sanity, ModulesWorking)
{
    database_bc_sysd_vcu_state_t just_here_to_show_that_dbc_works;
    (void) just_here_to_show_that_dbc_works;

    EXPECT_TRUE(true);
}

FAKE_VOID_FUNC(MX_CAN2_Init);
TEST(Sanity, FakeFunctionWorking)
{
    MX_CAN2_Init();
    EXPECT_EQ(MX_CAN2_Init_fake.call_count, 1);
}

