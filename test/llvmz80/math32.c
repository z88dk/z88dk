#include <stdio.h>

__attribute__((noinline)) static float arithmetic(float left, float right)
{
    return (left + right) / right;
}

int main(void)
{
    volatile float left = 1.25f;
    volatile float right = 0.5f;
    for (int i = 0; i < 100; ++i)
        if (arithmetic(left, right) != 3.5f)
            return 1;
    puts("ALL PASS");
    return 0;
}
