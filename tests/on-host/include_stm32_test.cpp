#include <gtest/gtest.h>

#include "fff.h"
DEFINE_FFF_GLOBALS;

TEST(IncludeSTM32, CanIncludeFile)
{
    EXPECT_TRUE(true);
}


FAKE_VOID_FUNC(MX_CAN2_Init);
TEST(IncludeSTM32, FakeFunction)
{
    MX_CAN2_Init();
    EXPECT_EQ(MX_CAN2_Init_fake.call_count, 1);
}
