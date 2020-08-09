
#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void int_fastcall(int a,int b) __z88dk_fastcall {
    assertEqual(3,a);
    assertEqual(5,b);
}

void test_int_fastcall() {
   int_fastcall(3,5);
}

void test_int_fastcall_ptr() {
   void (*func)(int x, int y) __z88dk_fastcall = int_fastcall;

   (func)(3,5);
}

void long_fastcall(long a,long b) __z88dk_fastcall {
    assertEqual(3,a);
    assertEqual(5,b);
}

void test_long_fastcall() {
   long_fastcall(3,5);
}

void test_long_fastcall_ptr() {
   void (*func)(long x, long y) __z88dk_fastcall = int_fastcall;

   (func)(3,5);
}

#ifndef __8080__
  #ifndef __GBZ80__
long long int_fastcall_ret_longlong(int a,int b) __z88dk_fastcall {
    assertEqual(3,a);
    assertEqual(5,b);
    return a;
}

void test_int_fastcall_ret_longlong() {
   long long ret = int_fastcall_ret_longlong(3,5);
   assertEqual(3, ret);
}

void test_int_fastcall_ret_longlong_ptr() {
   long long (*func)(int x, int y) __z88dk_fastcall = test_int_fastcall_ret_longlong;
   long long ret = func(3,5);
   assertEqual(3, ret);
}
  #endif
#endif


int suite_fastcall()
{
    suite_setup("Fastcall Tests");
    suite_add_test(test_int_fastcall);
    suite_add_test(test_int_fastcall_ptr);
    suite_add_test(test_long_fastcall);
    suite_add_test(test_long_fastcall_ptr);
#ifndef __8080__
  #ifndef __GBZ80__
    suite_add_test(test_int_fastcall_ret_longlong);
    suite_add_test(test_int_fastcall_ret_longlong_ptr);
  #endif
#endif

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_fastcall();

    exit(res);
}
