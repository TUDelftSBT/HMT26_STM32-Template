#include <gtest/gtest.h>

#include "can.h"

TEST(IncludeSTM32, CanIncludeFile)
{
    EXPECT_TRUE(true);
}

// TODO: Add FFF (https://github.com/meekrosoft/fff)
// Then make this test pass
TEST(IncludeSTM32, CanCallFakeFunction)
{
    // MX_CAN2_Init();
    // EXPECT_TRUE(true);
}