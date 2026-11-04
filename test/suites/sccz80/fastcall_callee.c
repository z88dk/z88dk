#include "test.h"
#include <stdio.h>
#include <stdlib.h>

static int int_fc(int a) __z88dk_fastcall __z88dk_callee
{
    return a;
}

static long long_fc(long a) __z88dk_fastcall __z88dk_callee
{
    return a + 1;
}

/* 80cc's caller also pops a fastcall callee's stacked arguments. */
#ifndef __80CC
static int int2_fc(int a, int b) __z88dk_fastcall __z88dk_callee
{
    return a + b;
}

static int char_fc(int a, char c) __z88dk_fastcall __z88dk_callee
{
    return a + c;
}

static long long2_fc(int a, long b) __z88dk_fastcall __z88dk_callee
{
    return b + a;
}
#endif

static double double_fc(double a) __z88dk_fastcall __z88dk_callee
{
    return a;
}

#ifndef __80CC
static double double2_fc(int a, double b) __z88dk_fastcall __z88dk_callee
{
    return b + a;
}
#endif

static int plain_fast(int a) __z88dk_fastcall
{
    return a + 1;
}

static int plain_callee(int a, int b) __z88dk_callee
{
    return a + b;
}

#ifndef __80CC
#ifndef __8080
#ifndef __GBZ80
static long long longlong_fc(long long a) __z88dk_fastcall __z88dk_callee
{
    return a + 1;
}

static long long longlong_ret(int a, int b) __z88dk_fastcall __z88dk_callee
{
    return (long long)a + b;
}
#endif
#endif
#endif

/* canary is the local nearest the caller's return address. pad[] keeps that
   return address itself in place when a callee pops several extra words. */
static void check_words(int canary, int pad0, int want_canary)
{
    assertEqual(canary, want_canary);
    assertEqual(pad0, 1);
}

void test_int_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    int r;

    canary = 0x1234;
    pad[0] = 1;
    r = int_fc(41);
    assertEqual(r, 41);
    check_words(canary, pad[0], 0x1234);
}

#ifndef __80CC
void test_int2_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    int r;

    canary = 0x2345;
    pad[0] = 1;
    r = int2_fc(3, 5);
    assertEqual(r, 8);
    check_words(canary, pad[0], 0x2345);
}

void test_char_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    int r;

    canary = 0x3456;
    pad[0] = 1;
    r = char_fc(20, 3);
    assertEqual(r, 23);
    check_words(canary, pad[0], 0x3456);
}
#endif

void test_long_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    long r;

    canary = 0x4567;
    pad[0] = 1;
    r = long_fc(100);
    assertEqual(r, 101L);
    check_words(canary, pad[0], 0x4567);
}

#ifndef __80CC
void test_long2_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    long r;

    canary = 0x5678;
    pad[0] = 1;
    r = long2_fc(4, 50);
    assertEqual(r, 54L);
    check_words(canary, pad[0], 0x5678);
}
#endif

void test_double_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    double r;

    canary = 0x6789;
    pad[0] = 1;
    r = double_fc(2.5);
    assertEqual(r, 2.5);
    check_words(canary, pad[0], 0x6789);
}

#ifndef __80CC
void test_double2_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    double r;

    canary = 0x789a;
    pad[0] = 1;
    r = double2_fc(3, 2.5);
    assertEqual(r, 5.5);
    check_words(canary, pad[0], 0x789a);
}
#endif

void test_plain_fastcall(void)
{
    volatile int canary;
    volatile int pad[6];
    int r;

    canary = 0x1111;
    pad[0] = 1;
    r = plain_fast(6);
    assertEqual(r, 7);
    check_words(canary, pad[0], 0x1111);
}

void test_plain_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    int r;

    canary = 0x2222;
    pad[0] = 1;
    r = plain_callee(3, 5);
    assertEqual(r, 8);
    check_words(canary, pad[0], 0x2222);
}

#ifndef __80CC
#ifndef __8080
#ifndef __GBZ80
void test_longlong_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    long long r;

    canary = 0x3333;
    pad[0] = 1;
    r = longlong_fc(9);
    assertEqual(r, 10);
    check_words(canary, pad[0], 0x3333);
}

void test_longlong_ret_fastcall_callee(void)
{
    volatile int canary;
    volatile int pad[6];
    long long r;

    canary = 0x4444;
    pad[0] = 1;
    r = longlong_ret(3, 5);
    assertEqual(r, 8);
    check_words(canary, pad[0], 0x4444);
}
#endif
#endif
#endif

int suite_fastcall_callee(void)
{
    suite_setup("Fastcall callee");
    suite_add_test(test_plain_fastcall);
    suite_add_test(test_plain_callee);
    suite_add_test(test_int_fastcall_callee);
#ifndef __80CC
    suite_add_test(test_int2_fastcall_callee);
    suite_add_test(test_char_fastcall_callee);
#endif
    suite_add_test(test_long_fastcall_callee);
#ifndef __80CC
    suite_add_test(test_long2_fastcall_callee);
#endif
    suite_add_test(test_double_fastcall_callee);
#ifndef __80CC
    suite_add_test(test_double2_fastcall_callee);
#endif
#ifndef __80CC
#ifndef __8080
#ifndef __GBZ80
    suite_add_test(test_longlong_fastcall_callee);
    suite_add_test(test_longlong_ret_fastcall_callee);
#endif
#endif
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_fastcall_callee();
    exit(res);
}
