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

void test_rshift8_const(void)
{
     unsigned char val = 0x80;

     // RHS is folded by compiler
     Assert( val >> 0 == 0x80 >> 0, ">>0");
     Assert( val >> 1 == 0x80 >> 1, ">>1");
     Assert( val >> 2 == 0x80 >> 2, ">>2");
     Assert( val >> 3 == 0x80 >> 3, ">>3");
     Assert( val >> 4 == 0x80 >> 4, ">>4");
     Assert( val >> 5 == 0x80 >> 5, ">>5");
     Assert( val >> 6 == 0x80 >> 6, ">>6");
     Assert( val >> 7 == 0x80 >> 7, ">>7");
     Assert( val >> 8 == 0x80 >> 8, ">>8");
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


#ifndef __8080__
  #ifndef __GBZ80__
void test_rshift64_var(void)
{
     long long val = 0x8000000000000000LL;
     int  v = 0;

     // RHS is folded by compiler
     Assert( val >> v ==  0x8000000000000000LL >> 0, ">>0");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 1, ">>1");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 2, ">>2");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 3, ">>3");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 4, ">>4");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 5, ">>5");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 6, ">>6");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 7, ">>7");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 8, ">>8");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 9, ">>9");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 10, ">>10");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 11, ">>11");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 12, ">>12");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 13, ">>13");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 14, ">>14");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 15, ">>15");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 16, ">>16");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 17, ">>17");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 18, ">>18");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 19, ">>19");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 20, ">>20");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 21, ">>21");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 22, ">>22");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 23, ">>23");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 24, ">>24");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 25, ">>25");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 26, ">>26");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 27, ">>27");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 28, ">>28");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 29, ">>29");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 30, ">>30");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 31, ">>31");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 32, ">>32");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 33, ">>33");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 34, ">>34");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 35, ">>35");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 36, ">>36");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 37, ">>37");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 38, ">>38");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 39, ">>39");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 40, ">>40");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 41, ">>41");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 42, ">>42");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 43, ">>43");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 44, ">>44");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 45, ">>45");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 46, ">>46");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 47, ">>47");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 48, ">>48");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 49, ">>49");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 50, ">>50");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 51, ">>51");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 52, ">>52");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 53, ">>53");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 54, ">>54");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 55, ">>55");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 56, ">>56");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 57, ">>57");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 58, ">>58");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 59, ">>59");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 60, ">>60");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 61, ">>61");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 62, ">>62");
     ++v;
     Assert( val >> v ==  0x8000000000000000LL >> 63, ">>63");    
}


void test_rshift64_const(void)
{
     long long val = 0x8000000000000000LL;

     // RHS is folded by compiler
     Assert( val >> 0 ==  0x8000000000000000LL >> 0, ">>0");
     Assert( val >> 1 ==  0x8000000000000000LL >> 1, ">>1");
     Assert( val >> 2 ==  0x8000000000000000LL >> 2, ">>2");
     Assert( val >> 3 ==  0x8000000000000000LL >> 3, ">>3");
     Assert( val >> 4 ==  0x8000000000000000LL >> 4, ">>4");
     Assert( val >> 5 ==  0x8000000000000000LL >> 5, ">>5");
     Assert( val >> 6 ==  0x8000000000000000LL >> 6, ">>6");
     Assert( val >> 7 ==  0x8000000000000000LL >> 7, ">>7");
     Assert( val >> 8 ==  0x8000000000000000LL >> 8, ">>8");
     Assert( val >> 9 ==  0x8000000000000000LL >> 9, ">>9");
     Assert( val >> 10 ==  0x8000000000000000LL >> 10, ">>10");
     Assert( val >> 11 ==  0x8000000000000000LL >> 11, ">>11");
     Assert( val >> 12 ==  0x8000000000000000LL >> 12, ">>12");
     Assert( val >> 13 ==  0x8000000000000000LL >> 13, ">>13");
     Assert( val >> 14 ==  0x8000000000000000LL >> 14, ">>14");
     Assert( val >> 15 ==  0x8000000000000000LL >> 15, ">>15");
     Assert( val >> 16 ==  0x8000000000000000LL >> 16, ">>16");
     Assert( val >> 17 ==  0x8000000000000000LL >> 17, ">>17");
     Assert( val >> 18 ==  0x8000000000000000LL >> 18, ">>18");
     Assert( val >> 19 ==  0x8000000000000000LL >> 19, ">>19");
     Assert( val >> 20 ==  0x8000000000000000LL >> 20, ">>20");
     Assert( val >> 21 ==  0x8000000000000000LL >> 21, ">>21");
     Assert( val >> 22 ==  0x8000000000000000LL >> 22, ">>22");
     Assert( val >> 23 ==  0x8000000000000000LL >> 23, ">>23");
     Assert( val >> 24 ==  0x8000000000000000LL >> 24, ">>24");
     Assert( val >> 25 ==  0x8000000000000000LL >> 25, ">>25");
     Assert( val >> 26 ==  0x8000000000000000LL >> 26, ">>26");
     Assert( val >> 27 ==  0x8000000000000000LL >> 27, ">>27");
     Assert( val >> 28 ==  0x8000000000000000LL >> 28, ">>28");
     Assert( val >> 29 ==  0x8000000000000000LL >> 29, ">>29");
     Assert( val >> 30 ==  0x8000000000000000LL >> 30, ">>30");
     Assert( val >> 31 ==  0x8000000000000000LL >> 31, ">>31");
     Assert( val >> 32 ==  0x8000000000000000LL >> 32, ">>32");
     Assert( val >> 33 ==  0x8000000000000000LL >> 33, ">>33");
     Assert( val >> 34 ==  0x8000000000000000LL >> 34, ">>34");
     Assert( val >> 35 ==  0x8000000000000000LL >> 35, ">>35");
     Assert( val >> 36 ==  0x8000000000000000LL >> 36, ">>36");
     Assert( val >> 37 ==  0x8000000000000000LL >> 37, ">>37");
     Assert( val >> 38 ==  0x8000000000000000LL >> 38, ">>38");
     Assert( val >> 39 ==  0x8000000000000000LL >> 39, ">>39");
     Assert( val >> 40 ==  0x8000000000000000LL >> 40, ">>40");
     Assert( val >> 41 ==  0x8000000000000000LL >> 41, ">>41");
     Assert( val >> 42 ==  0x8000000000000000LL >> 42, ">>42");
     Assert( val >> 43 ==  0x8000000000000000LL >> 43, ">>43");
     Assert( val >> 44 ==  0x8000000000000000LL >> 44, ">>44");
     Assert( val >> 45 ==  0x8000000000000000LL >> 45, ">>45");
     Assert( val >> 46 ==  0x8000000000000000LL >> 46, ">>46");
     Assert( val >> 47 ==  0x8000000000000000LL >> 47, ">>47");
     Assert( val >> 48 ==  0x8000000000000000LL >> 48, ">>48");
     Assert( val >> 49 ==  0x8000000000000000LL >> 49, ">>49");
     Assert( val >> 50 ==  0x8000000000000000LL >> 50, ">>50");
     Assert( val >> 51 ==  0x8000000000000000LL >> 51, ">>51");
     Assert( val >> 52 ==  0x8000000000000000LL >> 52, ">>52");
     Assert( val >> 53 ==  0x8000000000000000LL >> 53, ">>53");
     Assert( val >> 54 ==  0x8000000000000000LL >> 54, ">>54");
     Assert( val >> 55 ==  0x8000000000000000LL >> 55, ">>55");
     Assert( val >> 56 ==  0x8000000000000000LL >> 56, ">>56");
     Assert( val >> 57 ==  0x8000000000000000LL >> 57, ">>57");
     Assert( val >> 58 ==  0x8000000000000000LL >> 58, ">>58");
     Assert( val >> 59 ==  0x8000000000000000LL >> 59, ">>59");
     Assert( val >> 60 ==  0x8000000000000000LL >> 60, ">>60");
     Assert( val >> 61 ==  0x8000000000000000LL >> 61, ">>61");
     Assert( val >> 62 ==  0x8000000000000000LL >> 62, ">>62");
     Assert( val >> 63 ==  0x8000000000000000LL >> 63, ">>63");    
}

void test_rshift64_const_unsigned(void)
{
     unsigned long long val = 0x8000000000000000ULL;

     // RHS is folded by compiler
     Assert( val >> 0 ==  0x8000000000000000ULL >> 0, ">>0");
     Assert( val >> 1 ==  0x8000000000000000ULL >> 1, ">>1");
     Assert( val >> 2 ==  0x8000000000000000ULL >> 2, ">>2");
     Assert( val >> 3 ==  0x8000000000000000ULL >> 3, ">>3");
     Assert( val >> 4 ==  0x8000000000000000ULL >> 4, ">>4");
     Assert( val >> 5 ==  0x8000000000000000ULL >> 5, ">>5");
     Assert( val >> 6 ==  0x8000000000000000ULL >> 6, ">>6");
     Assert( val >> 7 ==  0x8000000000000000ULL >> 7, ">>7");
     Assert( val >> 8 ==  0x8000000000000000ULL >> 8, ">>8");
     Assert( val >> 9 ==  0x8000000000000000ULL >> 9, ">>9");
     Assert( val >> 10 ==  0x8000000000000000ULL >> 10, ">>10");
     Assert( val >> 11 ==  0x8000000000000000ULL >> 11, ">>11");
     Assert( val >> 12 ==  0x8000000000000000ULL >> 12, ">>12");
     Assert( val >> 13 ==  0x8000000000000000ULL >> 13, ">>13");
     Assert( val >> 14 ==  0x8000000000000000ULL >> 14, ">>14");
     Assert( val >> 15 ==  0x8000000000000000ULL >> 15, ">>15");
     Assert( val >> 16 ==  0x8000000000000000ULL >> 16, ">>16");
     Assert( val >> 17 ==  0x8000000000000000ULL >> 17, ">>17");
     Assert( val >> 18 ==  0x8000000000000000ULL >> 18, ">>18");
     Assert( val >> 19 ==  0x8000000000000000ULL >> 19, ">>19");
     Assert( val >> 20 ==  0x8000000000000000ULL >> 20, ">>20");
     Assert( val >> 21 ==  0x8000000000000000ULL >> 21, ">>21");
     Assert( val >> 22 ==  0x8000000000000000ULL >> 22, ">>22");
     Assert( val >> 23 ==  0x8000000000000000ULL >> 23, ">>23");
     Assert( val >> 24 ==  0x8000000000000000ULL >> 24, ">>24");
     Assert( val >> 25 ==  0x8000000000000000ULL >> 25, ">>25");
     Assert( val >> 26 ==  0x8000000000000000ULL >> 26, ">>26");
     Assert( val >> 27 ==  0x8000000000000000ULL >> 27, ">>27");
     Assert( val >> 28 ==  0x8000000000000000ULL >> 28, ">>28");
     Assert( val >> 29 ==  0x8000000000000000ULL >> 29, ">>29");
     Assert( val >> 30 ==  0x8000000000000000ULL >> 30, ">>30");
     Assert( val >> 31 ==  0x8000000000000000ULL >> 31, ">>31");
     Assert( val >> 32 ==  0x8000000000000000ULL >> 32, ">>32");
     Assert( val >> 33 ==  0x8000000000000000ULL >> 33, ">>33");
     Assert( val >> 34 ==  0x8000000000000000ULL >> 34, ">>34");
     Assert( val >> 35 ==  0x8000000000000000ULL >> 35, ">>35");
     Assert( val >> 36 ==  0x8000000000000000ULL >> 36, ">>36");
     Assert( val >> 37 ==  0x8000000000000000ULL >> 37, ">>37");
     Assert( val >> 38 ==  0x8000000000000000ULL >> 38, ">>38");
     Assert( val >> 39 ==  0x8000000000000000ULL >> 39, ">>39");
     Assert( val >> 40 ==  0x8000000000000000ULL >> 40, ">>40");
     Assert( val >> 41 ==  0x8000000000000000ULL >> 41, ">>41");
     Assert( val >> 42 ==  0x8000000000000000ULL >> 42, ">>42");
     Assert( val >> 43 ==  0x8000000000000000ULL >> 43, ">>43");
     Assert( val >> 44 ==  0x8000000000000000ULL >> 44, ">>44");
     Assert( val >> 45 ==  0x8000000000000000ULL >> 45, ">>45");
     Assert( val >> 46 ==  0x8000000000000000ULL >> 46, ">>46");
     Assert( val >> 47 ==  0x8000000000000000ULL >> 47, ">>47");
     Assert( val >> 48 ==  0x8000000000000000ULL >> 48, ">>48");
     Assert( val >> 49 ==  0x8000000000000000ULL >> 49, ">>49");
     Assert( val >> 50 ==  0x8000000000000000ULL >> 50, ">>50");
     Assert( val >> 51 ==  0x8000000000000000ULL >> 51, ">>51");
     Assert( val >> 52 ==  0x8000000000000000ULL >> 52, ">>52");
     Assert( val >> 53 ==  0x8000000000000000ULL >> 53, ">>53");
     Assert( val >> 54 ==  0x8000000000000000ULL >> 54, ">>54");
     Assert( val >> 55 ==  0x8000000000000000ULL >> 55, ">>55");
     Assert( val >> 56 ==  0x8000000000000000ULL >> 56, ">>56");
     Assert( val >> 57 ==  0x8000000000000000ULL >> 57, ">>57");
     Assert( val >> 58 ==  0x8000000000000000ULL >> 58, ">>58");
     Assert( val >> 59 ==  0x8000000000000000ULL >> 59, ">>59");
     Assert( val >> 60 ==  0x8000000000000000ULL >> 60, ">>60");
     Assert( val >> 61 ==  0x8000000000000000ULL >> 61, ">>61");
     Assert( val >> 62 ==  0x8000000000000000ULL >> 62, ">>62");
     Assert( val >> 63 ==  0x8000000000000000ULL >> 63, ">>63");    
}
  #endif
#endif

int suite_rshift()
{
    suite_setup("Right shift Tests");

#ifndef __8080__
  #ifndef __GBZ80__
    suite_add_test(test_rshift64_const);
    suite_add_test(test_rshift64_const_unsigned);
    suite_add_test(test_rshift64_var);
  #endif
#endif

    suite_add_test(test_rshift32_const);
    suite_add_test(test_rshift32_const_unsigned);
    suite_add_test(test_rshift32_var);
    suite_add_test(test_rshift16_const);
    suite_add_test(test_rshift16_var);
    suite_add_test(test_rshift8_const);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_rshift();

    exit(res);
}
