#include <stdio.h>

#pragma output CRT_CLEAR_SCREEN = 1

int main(void)
{
    puts("crt0 cleared the DSS text screen before main().");
    return 0;
}
