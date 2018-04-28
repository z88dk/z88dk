#include <stdint.h>

static uint8_t  version;
static uint32_t mem_size;

void test(uint32_t ptr)
{
    if ((version < 4) && (mem_size == 0x10000))
    {
        ptr = ptr & 0xFFFF;
    }
}


void test_or(uint32_t ptr)
{
    if ((version < 4) || (mem_size == 0x10000))
    {
        ptr = ptr & 0xFFFF;
    }
}

void test_value(uint32_t ptr)
{
    if ((version < 4) || mem_size )
    {
        ptr = ptr & 0xFFFF;
    }
}

void test_value_and(uint32_t ptr)
{
    if ((version < 4) && mem_size )
    {
        ptr = ptr & 0xFFFF;
    }
}
