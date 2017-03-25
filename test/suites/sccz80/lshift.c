#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void test_lshift16_var(void)
{
     int val = 1;
     int  v = 0;

     // RHS is folded by compiler
     Assert( val << v == 1  << 0, "<<0");
     ++v;
     Assert( val << v == 1  << 1, "<<1");
     ++v;
     Assert( val << v == 1  << 2, "<<2");
     ++v;
     Assert( val << v == 1  << 3, "<<3");
     ++v;
     Assert( val << v == 1  << 4, "<<4");
     ++v;
     Assert( val << v == 1  << 5, "<<5");
     ++v;
     Assert( val << v == 1  << 6, "<<6");
     ++v;
     Assert( val << v == 1  << 7, "<<7");
     ++v;
     Assert( val << v == 1  << 8, "<<8");
     ++v;
     Assert( val << v == 1  << 9, "<<9");
     ++v;
     Assert( val << v == 1  << 10, "<<10");
     ++v;
     Assert( val << v == 1  << 11, "<<11");
     ++v;
     Assert( val << v == 1  << 12, "<<12");
     ++v;
     Assert( val << v == 1  << 13, "<<13");
     ++v;
     Assert( val << v == 1  << 14, "<<14");
     ++v;
     Assert( val << v == 1  << 15, "<<15");
     ++v;
     Assert( val << v == 1  << 16, "<<16"); // Undefined
     ++v;
     Assert( val << v == 1  << 17, "<<17"); // Undefined
}

void test_lshift32_var(void)
{
     long val = 1;
     int  v = 0;

     // RHS is folded by compiler
     Assert( val << v == 1L << 0, "<<0");
     ++v;
     Assert( val << v == 1L << 1, "<<1");
     ++v;
     Assert( val << v == 1L << 2, "<<2");
     ++v;
     Assert( val << v == 1L << 3, "<<3");
     ++v;
     Assert( val << v == 1L << 4, "<<4");
     ++v;
     Assert( val << v == 1L << 5, "<<5");
     ++v;
     Assert( val << v == 1L << 6, "<<6");
     ++v;
     Assert( val << v == 1L << 7, "<<7");
     ++v;
     Assert( val << v == 1L << 8, "<<8");
     ++v;
     Assert( val << v == 1L << 9, "<<9");
     ++v;
     Assert( val << v == 1L << 10, "<<10");
     ++v;
     Assert( val << v == 1L << 11, "<<11");
     ++v;
     Assert( val << v == 1L << 12, "<<12");
     ++v;
     Assert( val << v == 1L << 13, "<<13");
     ++v;
     Assert( val << v == 1L << 14, "<<14");
     ++v;
     Assert( val << v == 1L << 15, "<<15");
     ++v;
     Assert( val << v == 1L << 16, "<<16");
     ++v;
     Assert( val << v == 1L << 17, "<<17");
     ++v;
     Assert( val << v == 1L << 18, "<<18");
     ++v;
     Assert( val << v == 1L << 19, "<<19");
     ++v;
     Assert( val << v == 1L << 20, "<<20");
     ++v;
     Assert( val << v == 1L << 21, "<<21");
     ++v;
     Assert( val << v == 1L << 22, "<<22");
     ++v;
     Assert( val << v == 1L << 23, "<<23");
     ++v;
     Assert( val << v == 1L << 24, "<<24");
     ++v;
     Assert( val << v == 1L << 25, "<<25");
     ++v;
     Assert( val << v == 1L << 26, "<<26");
     ++v;
     Assert( val << v == 1L << 27, "<<27");
     ++v;
     Assert( val << v == 1L << 28, "<<28");
     ++v;
     Assert( val << v == 1L << 29, "<<29");
     ++v;
     Assert( val << v == 1L << 30, "<<30");
     ++v;
     Assert( val << v == 1L << 31, "<<31");
     ++v;
     Assert( val << v == 1L << 32, "<<32"); // Undefined behaviour
     ++v;
     Assert( val << v == 1L << 33, "<<33"); // Undefined, but it should match
}

void test_lshift16_const(void)
{
     int val = 1;

     // RHS is folded by compiler
     Assert( val << 0 == 1 << 0, "<<0");
     Assert( val << 1 == 1 << 1, "<<1");
     Assert( val << 2 == 1 << 2, "<<2");
     Assert( val << 3 == 1 << 3, "<<3");
     Assert( val << 4 == 1 << 4, "<<4");
     Assert( val << 5 == 1 << 5, "<<5");
     Assert( val << 6 == 1 << 6, "<<6");
     Assert( val << 7 == 1 << 7, "<<7");
     Assert( val << 8 == 1 << 8, "<<8");
     Assert( val << 9 == 1 << 9, "<<9");
     Assert( val << 10 == 1 << 10, "<<10");
     Assert( val << 11 == 1 << 11, "<<11");
     Assert( val << 12 == 1 << 12, "<<12");
     Assert( val << 13 == 1 << 13, "<<13");
     Assert( val << 14 == 1 << 14, "<<14");
     Assert( val << 15 == 1 << 15, "<<15");
     Assert( val << 16 == 1 << 16, "<<16"); // Undefined
     Assert( val << 17 == 1 << 17, "<<17"); // Undefined
}

void test_lshift32_const(void)
{
     long val = 1;

     // RHS is folded by compiler
     Assert( val << 0 == 1L << 0, "<<0");
     Assert( val << 1 == 1L << 1, "<<1");
     Assert( val << 2 == 1L << 2, "<<2");
     Assert( val << 3 == 1L << 3, "<<3");
     Assert( val << 4 == 1L << 4, "<<4");
     Assert( val << 5 == 1L << 5, "<<5");
     Assert( val << 6 == 1L << 6, "<<6");
     Assert( val << 7 == 1L << 7, "<<7");
     Assert( val << 8 == 1L << 8, "<<8");
     Assert( val << 9 == 1L << 9, "<<9");
     Assert( val << 10 == 1L << 10, "<<10");
     Assert( val << 11 == 1L << 11, "<<11");
     Assert( val << 12 == 1L << 12, "<<12");
     Assert( val << 13 == 1L << 13, "<<13");
     Assert( val << 14 == 1L << 14, "<<14");
     Assert( val << 15 == 1L << 15, "<<15");
     Assert( val << 16 == 1L << 16, "<<16");
     Assert( val << 17 == 1L << 17, "<<17");
     Assert( val << 18 == 1L << 18, "<<18");
     Assert( val << 19 == 1L << 19, "<<19");
     Assert( val << 20 == 1L << 20, "<<20");
     Assert( val << 21 == 1L << 21, "<<21");
     Assert( val << 22 == 1L << 22, "<<22");
     Assert( val << 23 == 1L << 23, "<<23");
     Assert( val << 24 == 1L << 24, "<<24");
     Assert( val << 25 == 1L << 25, "<<25");
     Assert( val << 26 == 1L << 26, "<<26");
     Assert( val << 27 == 1L << 27, "<<27");
     Assert( val << 28 == 1L << 28, "<<28");
     Assert( val << 29 == 1L << 29, "<<29");
     Assert( val << 30 == 1L << 30, "<<30");
     Assert( val << 31 == 1L << 31, "<<31");
     Assert( val << 32 == 1L << 32, "<<32"); // Undefined behaviour
     Assert( val << 33 == 1L << 33, "<<33"); // Undefined, but it should match
}

int suite_lshift()
{
    suite_setup("Left shift Tests");

    suite_add_test(test_lshift32_const);
    suite_add_test(test_lshift32_var);
    suite_add_test(test_lshift16_const);
    suite_add_test(test_lshift16_var);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_lshift();

    exit(res);
}
