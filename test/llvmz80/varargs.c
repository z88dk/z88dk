#include <stdarg.h>
#include <stdio.h>
#include <string.h>

__attribute__((noinline)) static int sum(int count, ...)
{
    va_list ap, copy;
    int result = 0;
    va_start(ap, count);
    va_copy(copy, ap);
    int first = va_arg(copy, int);
    va_end(copy);
    while (count--)
        result += va_arg(ap, int);
    va_end(ap);
    return first == 10 ? result : -1;
}

__attribute__((noinline)) static int format(char *out, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int result = vsnprintf(out, 32, fmt, ap);
    va_end(ap);
    return result;
}

#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
__attribute__((noinline)) static int c23_sum(int count, ...)
{
    va_list ap;
    va_start(ap);
    int result = 0;
    while (count--)
        result += va_arg(ap, int);
    va_end(ap);
    return result;
}
#endif

int main(void)
{
    char out[32];
    for (int i = 0; i < 100; ++i) {
        if (sum(3, 10, 20, 30) != 60)
            return 1;
        if (format(out, "%d:%s", 42, "ok") != 5)
            return 2;
        if (strcmp(out, "42:ok") != 0)
            return 3;
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
        if (c23_sum(3, 10, 20, 30) != 60)
            return 4;
#endif
    }
    puts("ALL PASS");
    return 0;
}
