//
// Created by Teund on 03/02/2026.
//

#include <gtest/gtest.h>
#include "check_build_config.h"

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