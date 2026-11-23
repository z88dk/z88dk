#include "test.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* One named word. va_start sits on the first extra argument. */

static void one(char *fmt, ...)
{
    va_list v;
    int n0, n1, n2, n3;

    /* getarg reads A. Nothing may run before va_start. */
    va_start(v, fmt);
    n0 = va_arg(v, int);
    n1 = va_arg(v, int);
    n2 = va_arg(v, int);
    n3 = va_arg(v, int);
    va_end(v);
    Assert(n0 == 1, "first extra");
    Assert(n1 == 2, "second extra");
    Assert(n2 == 3, "third extra");
    Assert(n3 == -1, "last extra");
}

static void wide(char *fmt, ...)
{
    va_list v;
    unsigned long n;
    unsigned x;

    va_start(v, fmt);
    n = va_arg(v, unsigned long);
    x = va_arg(v, unsigned);
    va_end(v);
    Assert(n == 123456UL, "long extra");
    Assert(x == 0xabcd, "word after long");
}

static void mix(char *fmt, ...)
{
    va_list v;
    int a;
    unsigned long n;
    int b;

    va_start(v, fmt);
    a = va_arg(v, int);
    n = va_arg(v, unsigned long);
    b = va_arg(v, int);
    va_end(v);
    Assert(a == 7, "word before long");
    Assert(n == 123456UL, "long between words");
    Assert(b == -1, "word after mixed long");
}

/* Two named words. The list starts on the last named word. */

static void two(int a, int b, ...)
{
    va_list v;
    int sa, sb, n0, n1, n2, n3, n4;

    va_start(v, b);
    sa = a;
    sb = b;
    n0 = va_arg(v, int);
    n1 = va_arg(v, int);
    n2 = va_arg(v, int);
    n3 = va_arg(v, int);
    n4 = va_arg(v, int);
    va_end(v);
    Assert(sa == 3, "first named stays at the top slot");
    Assert(sb == -1, "second named stays at the top slot");
    Assert(n0 == 22, "list starts on the last named word");
    Assert(n1 == 1, "first extra after two names");
    Assert(n2 == 2, "second extra after two names");
    Assert(n3 == 3, "third extra after two names");
    Assert(n4 == -1, "last extra after two names");
}

static char ebuf[40];

static void formatted(char *fmt, ...)
{
    va_list v;

    va_start(v, fmt);
    vsnprintf(ebuf, sizeof(ebuf), va_ptr(v, char *), v);
    va_end(v);
}

static void test_stdarg(void)
{
    /* Keep the long and hex converters in the linked printf. */
    printf("%d %s %lu %x\n", 1, "s", 1UL, 1);

    one("F", 1, 2, 3, -1);
    wide("W", 123456UL, 0xabcd);
    mix("M", 7, 123456UL, -1);
    two(11, 22, 1, 2, 3, -1);

    formatted("%d %d %d", 1, 2, -1);
    Assert(strcmp(ebuf, "1 2 -1") == 0, "vsnprintf ints");
    formatted("Hello %s", "There");
    Assert(strcmp(ebuf, "Hello There") == 0, "vsnprintf string");
    formatted("Hello %lu %x", 123456UL, 0xabcd);
    Assert(strcmp(ebuf, "Hello 123456 abcd") == 0, "vsnprintf long");
}

int suite_stdarg(void)
{
    suite_setup("Stdarg");
    suite_add_test(test_stdarg);
    return suite_run();
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    exit(suite_stdarg());
}
