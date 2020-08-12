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
//     Assert( val << v == (1  << 16) & 0xffff, "<<16"); // Undefined
     ++v;
//     Assert( val << v == (1 << 17) & 0xffff, "<<17"); // Undefined
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
//     Assert( val << v == (1L << 32) & 0xffffffff, "<<32"); // Undefined behaviour
     ++v;
 //    Assert( val << v == (1L << 33) & 0xffffffff, "<<33"); // Undefined, but it should match
}


#ifndef __8080__
  #ifndef __GBZ80__
void test_lshift64_var(void)
{
     long long val = 1;
     int  v = 0;

     // RHS is folded by compiler
     Assert( val << v == 1LL << 0, "<<0");
     ++v;
     Assert( val << v == 1LL << 1, "<<1");
     ++v;
     Assert( val << v == 1LL << 2, "<<2");
     ++v;
     Assert( val << v == 1LL << 3, "<<3");
     ++v;
     Assert( val << v == 1LL << 4, "<<4");
     ++v;
     Assert( val << v == 1LL << 5, "<<5");
     ++v;
     Assert( val << v == 1LL << 6, "<<6");
     ++v;
     Assert( val << v == 1LL << 7, "<<7");
     ++v;
     Assert( val << v == 1LL << 8, "<<8");
     ++v;
     Assert( val << v == 1LL << 9, "<<9");
     ++v;
     Assert( val << v == 1LL << 10, "<<10");
     ++v;
     Assert( val << v == 1LL << 11, "<<11");
     ++v;
     Assert( val << v == 1LL << 12, "<<12");
     ++v;
     Assert( val << v == 1LL << 13, "<<13");
     ++v;
     Assert( val << v == 1LL << 14, "<<14");
     ++v;
     Assert( val << v == 1LL << 15, "<<15");
     ++v;
     Assert( val << v == 1LL << 16, "<<16");
     ++v;
     Assert( val << v == 1LL << 17, "<<17");
     ++v;
     Assert( val << v == 1LL << 18, "<<18");
     ++v;
     Assert( val << v == 1LL << 19, "<<19");
     ++v;
     Assert( val << v == 1LL << 20, "<<20");
     ++v;
     Assert( val << v == 1LL << 21, "<<21");
     ++v;
     Assert( val << v == 1LL << 22, "<<22");
     ++v;
     Assert( val << v == 1LL << 23, "<<23");
     ++v;
     Assert( val << v == 1LL << 24, "<<24");
     ++v;
     Assert( val << v == 1LL << 25, "<<25");
     ++v;
     Assert( val << v == 1LL << 26, "<<26");
     ++v;
     Assert( val << v == 1LL << 27, "<<27");
     ++v;
     Assert( val << v == 1LL << 28, "<<28");
     ++v;
     Assert( val << v == 1LL << 29, "<<29");
     ++v;
     Assert( val << v == 1LL << 30, "<<30");
     ++v;
     Assert( val << v == 1LL << 31, "<<31");
     ++v;
     Assert( val << v == 1LL << 32, "<<32");
     ++v;
     Assert( val << v == 1LL << 33, "<<33");
     ++v;
     Assert( val << v == 1LL << 34, "<<34");
     ++v;
     Assert( val << v == 1LL << 35, "<<35");
     ++v;
     Assert( val << v == 1LL << 36, "<<36");
     ++v;
     Assert( val << v == 1LL << 37, "<<37");
     ++v;
     Assert( val << v == 1LL << 38, "<<38");
     ++v;
     Assert( val << v == 1LL << 39, "<<39");
     ++v;
     Assert( val << v == 1LL << 40, "<<40");
     ++v;
     Assert( val << v == 1LL << 41, "<<41");
     ++v;
     Assert( val << v == 1LL << 42, "<<42");
     ++v;
     Assert( val << v == 1LL << 43, "<<43");
     ++v;
     Assert( val << v == 1LL << 44, "<<44");
     ++v;
     Assert( val << v == 1LL << 45, "<<45");
     ++v;
     Assert( val << v == 1LL << 46, "<<46");
     ++v;
     Assert( val << v == 1LL << 47, "<<47");
     ++v;
     Assert( val << v == 1LL << 48, "<<48");
     ++v;
     Assert( val << v == 1LL << 49, "<<49");
     ++v;
     Assert( val << v == 1LL << 50, "<<50");
     ++v;
     Assert( val << v == 1LL << 51, "<<51");
     ++v;
     Assert( val << v == 1LL << 52, "<<52");
     ++v;
     Assert( val << v == 1LL << 53, "<<53");
     ++v;
     Assert( val << v == 1LL << 54, "<<54");
     ++v;
     Assert( val << v == 1LL << 55, "<<55");
     ++v;
     Assert( val << v == 1LL << 56, "<<56");
     ++v;
     Assert( val << v == 1LL << 57, "<<57");
     ++v;
     Assert( val << v == 1LL << 58, "<<58");
     ++v;
     Assert( val << v == 1LL << 59, "<<59");
     ++v;
     Assert( val << v == 1LL << 60, "<<60");
     ++v;
     Assert( val << v == 1LL << 61, "<<61");
     ++v;
     Assert( val << v == 1LL << 62, "<<62");
     ++v;
     Assert( val << v == 1LL << 63, "<<63");    
}


void test_lshift64_const(void)
{
     long long val = 1;

     // RHS is folded by compiler
     Assert( val << 0 == 1LL << 0, "<<0");
     Assert( val << 1 == 1LL << 1, "<<1");
     Assert( val << 2 == 1LL << 2, "<<2");
     Assert( val << 3 == 1LL << 3, "<<3");
     Assert( val << 4 == 1LL << 4, "<<4");
     Assert( val << 5 == 1LL << 5, "<<5");
     Assert( val << 6 == 1LL << 6, "<<6");
     Assert( val << 7 == 1LL << 7, "<<7");
     Assert( val << 8 == 1LL << 8, "<<8");
     Assert( val << 9 == 1LL << 9, "<<9");
     Assert( val << 10 == 1LL << 10, "<<10");
     Assert( val << 11 == 1LL << 11, "<<11");
     Assert( val << 12 == 1LL << 12, "<<12");
     Assert( val << 13 == 1LL << 13, "<<13");
     Assert( val << 14 == 1LL << 14, "<<14");
     Assert( val << 15 == 1LL << 15, "<<15");
     Assert( val << 16 == 1LL << 16, "<<16");
     Assert( val << 17 == 1LL << 17, "<<17");
     Assert( val << 18 == 1LL << 18, "<<18");
     Assert( val << 19 == 1LL << 19, "<<19");
     Assert( val << 20 == 1LL << 20, "<<20");
     Assert( val << 21 == 1LL << 21, "<<21");
     Assert( val << 22 == 1LL << 22, "<<22");
     Assert( val << 23 == 1LL << 23, "<<23");
     Assert( val << 24 == 1LL << 24, "<<24");
     Assert( val << 25 == 1LL << 25, "<<25");
     Assert( val << 26 == 1LL << 26, "<<26");
     Assert( val << 27 == 1LL << 27, "<<27");
     Assert( val << 28 == 1LL << 28, "<<28");
     Assert( val << 29 == 1LL << 29, "<<29");
     Assert( val << 30 == 1LL << 30, "<<30");
     Assert( val << 31 == 1LL << 31, "<<31");
     Assert( val << 32 == 1LL << 32, "<<32");
     Assert( val << 33 == 1LL << 33, "<<33");
     Assert( val << 34 == 1LL << 34, "<<34");
     Assert( val << 35 == 1LL << 35, "<<35");
     Assert( val << 36 == 1LL << 36, "<<36");
     Assert( val << 37 == 1LL << 37, "<<37");
     Assert( val << 38 == 1LL << 38, "<<38");
     Assert( val << 39 == 1LL << 39, "<<39");
     Assert( val << 40 == 1LL << 40, "<<40");
     Assert( val << 41 == 1LL << 41, "<<41");
     Assert( val << 42 == 1LL << 42, "<<42");
     Assert( val << 43 == 1LL << 43, "<<43");
     Assert( val << 44 == 1LL << 44, "<<44");
     Assert( val << 45 == 1LL << 45, "<<45");
     Assert( val << 46 == 1LL << 46, "<<46");
     Assert( val << 47 == 1LL << 47, "<<47");
     Assert( val << 48 == 1LL << 48, "<<48");
     Assert( val << 49 == 1LL << 49, "<<49");
     Assert( val << 50 == 1LL << 50, "<<50");
     Assert( val << 51 == 1LL << 51, "<<51");
     Assert( val << 52 == 1LL << 52, "<<52");
     Assert( val << 53 == 1LL << 53, "<<53");
     Assert( val << 54 == 1LL << 54, "<<54");
     Assert( val << 55 == 1LL << 55, "<<55");
     Assert( val << 56 == 1LL << 56, "<<56");
     Assert( val << 57 == 1LL << 57, "<<57");
     Assert( val << 58 == 1LL << 58, "<<58");
     Assert( val << 59 == 1LL << 59, "<<59");
     Assert( val << 60 == 1LL << 60, "<<60");
     Assert( val << 61 == 1LL << 61, "<<61");
     Assert( val << 62 == 1LL << 62, "<<62");
     Assert( val << 63 == 1LL << 63, "<<63");    
}
  #endif
#endif


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
     Assert( val << 15 == (1 << 15) & 0xffff, "<<15");
//     Assert( val << 16 == (1 << 16) & 0xffff, "<<16"); // Undefined
//     Assert( val << 17 == (1 << 17) & 0xffff, "<<17"); // Undefined
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
//     Assert( val << 32 == (1L << 32) & 0xffffffff, "<<32"); // Undefined behaviour
//     Assert( val << 33 == (1L << 33) & 0xffffffff, "<<33"); // Undefined, but it should match
}

int suite_lshift()
{
    suite_setup("Left shift Tests");
#ifndef __8080__
  #ifndef __GBZ80__
    suite_add_test(test_lshift64_const);
    suite_add_test(test_lshift64_var);
  #endif
#endif
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
