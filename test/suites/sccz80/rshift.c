#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void test_rshift16_var(void)
{
     int val = 0x8000;
     int  v = 0;

     // RHS is folded by compiler
     Assert( val >> v == 0x8000 >> 0, ">>0");
     ++v;
     Assert( val >> v == 0x8000 >> 1, ">>1");
     ++v;
     Assert( val >> v == 0x8000 >> 2, ">>2");
     ++v;
     Assert( val >> v == 0x8000 >> 3, ">>3");
     ++v;
     Assert( val >> v == 0x8000 >> 4, ">>4");
     ++v;
     Assert( val >> v == 0x8000 >> 5, ">>5");
     ++v;
     Assert( val >> v == 0x8000 >> 6, ">>6");
     ++v;
     Assert( val >> v == 0x8000 >> 7, ">>7");
     ++v;
     Assert( val >> v == 0x8000 >> 8, ">>8");
     ++v;
     Assert( val >> v == 0x8000 >> 9, ">>9");
     ++v;
     Assert( val >> v == 0x8000 >> 10, ">>10");
     ++v;
     Assert( val >> v == 0x8000 >> 11, ">>11");
     ++v;
     Assert( val >> v == 0x8000 >> 12, ">>12");
     ++v;
     Assert( val >> v == 0x8000 >> 13, ">>13");
     ++v;
     Assert( val >> v == 0x8000 >> 14, ">>14");
     ++v;
     Assert( val >> v == 0x8000 >> 15, ">>15");
     ++v;
//     Assert( val >> v == 0x8000 >> 16, ">>16"); // Undefined
     ++v;
//     Assert( val >> v == 0x8000 >> 17, ">>17"); // Undefined
}

void test_rshift32_var(void)
{
     long val = 0x80000000L;
     int  v = 0;

     // RHS is folded by compiler
     Assert( val >> v == 0x80000000L >> 0, ">>0");
     ++v;
     Assert( val >> v == 0x80000000L >> 1, ">>1");
     ++v;
     Assert( val >> v == 0x80000000L >> 2, ">>2");
     ++v;
     Assert( val >> v == 0x80000000L >> 3, ">>3");
     ++v;
     Assert( val >> v == 0x80000000L >> 4, ">>4");
     ++v;
     Assert( val >> v == 0x80000000L >> 5, ">>5");
     ++v;
     Assert( val >> v == 0x80000000L >> 6, ">>6");
     ++v;
     Assert( val >> v == 0x80000000L >> 7, ">>7");
     ++v;
     Assert( val >> v == 0x80000000L >> 8, ">>8");
     ++v;
     Assert( val >> v == 0x80000000L >> 9, ">>9");
     ++v;
     Assert( val >> v == 0x80000000L >> 10, ">>10");
     ++v;
     Assert( val >> v == 0x80000000L >> 11, ">>11");
     ++v;
     Assert( val >> v == 0x80000000L >> 12, ">>12");
     ++v;
     Assert( val >> v == 0x80000000L >> 13, ">>13");
     ++v;
     Assert( val >> v == 0x80000000L >> 14, ">>14");
     ++v;
     Assert( val >> v == 0x80000000L >> 15, ">>15");
     ++v;
     Assert( val >> v == 0x80000000L >> 16, ">>16");
     ++v;
     Assert( val >> v == 0x80000000L >> 17, ">>17");
     ++v;
     Assert( val >> v == 0x80000000L >> 18, ">>18");
     ++v;
     Assert( val >> v == 0x80000000L >> 19, ">>19");
     ++v;
     Assert( val >> v == 0x80000000L >> 20, ">>20");
     ++v;
     Assert( val >> v == 0x80000000L >> 21, ">>21");
     ++v;
     Assert( val >> v == 0x80000000L >> 22, ">>22");
     ++v;
     Assert( val >> v == 0x80000000L >> 23, ">>23");
     ++v;
     Assert( val >> v == 0x80000000L >> 24, ">>24");
     ++v;
     Assert( val >> v == 0x80000000L >> 25, ">>25");
     ++v;
     Assert( val >> v == 0x80000000L >> 26, ">>26");
     ++v;
     Assert( val >> v == 0x80000000L >> 27, ">>27");
     ++v;
     Assert( val >> v == 0x80000000L >> 28, ">>28");
     ++v;
     Assert( val >> v == 0x80000000L >> 29, ">>29");
     ++v;
     Assert( val >> v == 0x80000000L >> 30, ">>30");
     ++v;
     Assert( val >> v == 0x80000000L >> 31, ">>31");
     ++v;
//     Assert( val >> v == 0x80000000L >> 32, ">>32"); // Undefined behaviour
     ++v;
//     Assert( val >> v == 0x80000000L >> 33, ">>33"); // Undefined, but it should match
}

void test_rshift16_const(void)
{
     int val = 0x8000;

     // RHS is folded by compiler
     Assert( val >> 0 == 0x8000 >> 0, ">>0");
     Assert( val >> 1 == 0x8000 >> 1, ">>1");
     Assert( val >> 2 == 0x8000 >> 2, ">>2");
     Assert( val >> 3 == 0x8000 >> 3, ">>3");
     Assert( val >> 4 == 0x8000 >> 4, ">>4");
     Assert( val >> 5 == 0x8000 >> 5, ">>5");
     Assert( val >> 6 == 0x8000 >> 6, ">>6");
     Assert( val >> 7 == 0x8000 >> 7, ">>7");
     Assert( val >> 8 == 0x8000 >> 8, ">>8");
     Assert( val >> 9 == 0x8000 >> 9, ">>9");
     Assert( val >> 10 == 0x8000 >> 10, ">>10");
     Assert( val >> 11 == 0x8000 >> 11, ">>11");
     Assert( val >> 12 == 0x8000 >> 12, ">>12");
     Assert( val >> 13 == 0x8000 >> 13, ">>13");
     Assert( val >> 14 == 0x8000 >> 14, ">>14");
     Assert( val >> 15 == 0x8000 >> 15, ">>15");
//     Assert( val >> 16 == 0x8000 >> 16, ">>16"); // Undefined
//     Assert( val >> 17 == 0x8000 >> 17, ">>17"); // Undefined
}

void test_rshift32_const(void)
{
     long val = 0x80000000;

     // RHS is folded by compiler
     Assert( val >> 0 == 0x80000000L >> 0, ">>0");
     Assert( val >> 1 == 0x80000000L >> 1, ">>1");
     Assert( val >> 2 == 0x80000000L >> 2, ">>2");
     Assert( val >> 3 == 0x80000000L >> 3, ">>3");
     Assert( val >> 4 == 0x80000000L >> 4, ">>4");
     Assert( val >> 5 == 0x80000000L >> 5, ">>5");
     Assert( val >> 6 == 0x80000000L >> 6, ">>6");
     Assert( val >> 7 == 0x80000000L >> 7, ">>7");
     Assert( val >> 8 == 0x80000000L >> 8, ">>8");
     Assert( val >> 9 == 0x80000000L >> 9, ">>9");
     Assert( val >> 10 == 0x80000000L >> 10, ">>10");
     Assert( val >> 11 == 0x80000000L >> 11, ">>11");
     Assert( val >> 12 == 0x80000000L >> 12, ">>12");
     Assert( val >> 13 == 0x80000000L >> 13, ">>13");
     Assert( val >> 14 == 0x80000000L >> 14, ">>14");
     Assert( val >> 15 == 0x80000000L >> 15, ">>15");
     Assert( val >> 16 == 0x80000000L >> 16, ">>16");
     Assert( val >> 17 == 0x80000000L >> 17, ">>17");
     Assert( val >> 18 == 0x80000000L >> 18, ">>18");
     Assert( val >> 19 == 0x80000000L >> 19, ">>19");
     Assert( val >> 20 == 0x80000000L >> 20, ">>20");
     Assert( val >> 21 == 0x80000000L >> 21, ">>21");
     Assert( val >> 22 == 0x80000000L >> 22, ">>22");
     Assert( val >> 23 == 0x80000000L >> 23, ">>23");
     Assert( val >> 24 == 0x80000000L >> 24, ">>24");
     Assert( val >> 25 == 0x80000000L >> 25, ">>25");
     Assert( val >> 26 == 0x80000000L >> 26, ">>26");
     Assert( val >> 27 == 0x80000000L >> 27, ">>27");
     Assert( val >> 28 == 0x80000000L >> 28, ">>28");
     Assert( val >> 29 == 0x80000000L >> 29, ">>29");
     Assert( val >> 30 == 0x80000000L >> 30, ">>30");
     Assert( val >> 31 == 0x80000000L >> 31, ">>31");
//     Assert( val >> 32 == 0x80000000L >> 32, ">>32"); // Undefined behaviour
//     Assert( val >> 33 == 0x80000000L >> 33, ">>33"); // Undefined, but it should match
}

void test_rshift32_const_unsigned(void)
{
     unsigned long val = 0x80000000;

     // RHS is folded by compiler
     Assert( val >> 0 == 0x80000000UL >> 0, ">>0");
     Assert( val >> 1 == 0x80000000UL >> 1, ">>1");
     Assert( val >> 2 == 0x80000000UL >> 2, ">>2");
     Assert( val >> 3 == 0x80000000UL >> 3, ">>3");
     Assert( val >> 4 == 0x80000000UL >> 4, ">>4");
     Assert( val >> 5 == 0x80000000UL >> 5, ">>5");
     Assert( val >> 6 == 0x80000000UL >> 6, ">>6");
     Assert( val >> 7 == 0x80000000UL >> 7, ">>7");
     Assert( val >> 8 == 0x80000000UL >> 8, ">>8");
     Assert( val >> 9 == 0x80000000UL >> 9, ">>9");
     Assert( val >> 10 == 0x80000000UL >> 10, ">>10");
     Assert( val >> 11 == 0x80000000UL >> 11, ">>11");
     Assert( val >> 12 == 0x80000000UL >> 12, ">>12");
     Assert( val >> 13 == 0x80000000UL >> 13, ">>13");
     Assert( val >> 14 == 0x80000000UL >> 14, ">>14");
     Assert( val >> 15 == 0x80000000UL >> 15, ">>15");
     Assert( val >> 16 == 0x80000000UL >> 16, ">>16");
     Assert( val >> 17 == 0x80000000UL >> 17, ">>17");
     Assert( val >> 18 == 0x80000000UL >> 18, ">>18");
     Assert( val >> 19 == 0x80000000UL >> 19, ">>19");
     Assert( val >> 20 == 0x80000000UL >> 20, ">>20");
     Assert( val >> 21 == 0x80000000UL >> 21, ">>21");
     Assert( val >> 22 == 0x80000000UL >> 22, ">>22");
     Assert( val >> 23 == 0x80000000UL >> 23, ">>23");
     Assert( val >> 24 == 0x80000000UL >> 24, ">>24");
     Assert( val >> 25 == 0x80000000UL >> 25, ">>25");
     Assert( val >> 26 == 0x80000000UL >> 26, ">>26");
     Assert( val >> 27 == 0x80000000UL >> 27, ">>27");
     Assert( val >> 28 == 0x80000000UL >> 28, ">>28");
     Assert( val >> 29 == 0x80000000UL >> 29, ">>29");
     Assert( val >> 30 == 0x80000000UL >> 30, ">>30");
     Assert( val >> 31 == 0x80000000UL >> 31, ">>31");
//     Assert( val >> 32 == 0x80000000UL >> 32, ">>32"); // Undefined behaviour
//     Assert( val >> 33 == 0x80000000UL >> 33, ">>33"); // Undefined, but it should match
}

int suite_rshift()
{
    suite_setup("Right shift Tests");

#ifndef __8080__
    suite_add_test(test_rshift32_const);
    suite_add_test(test_rshift32_const_unsigned);
    suite_add_test(test_rshift32_var);
#endif
    suite_add_test(test_rshift16_const);
    suite_add_test(test_rshift16_var);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_rshift();

    exit(res);
}
