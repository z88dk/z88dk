/* Tests classic z88dk library ABI conventions (__z88dk_fastcall, __z88dk_callee,
 * smallc), memory allocation (malloc/calloc/realloc/free), stdlib utilities,
 * and setjmp/longjmp across multiple iterations to ensure stack balance. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

extern int abs_fastcall(int value) __z88dk_fastcall;
extern int memcmp_callee(const void *, const void *, size_t) __smallc __z88dk_callee;

static int compare(const void *left, const void *right)
{
    int a = *(const int *)left;
    int b = *(const int *)right;
    return (a > b) - (a < b);
}

int main(void)
{
    static jmp_buf env;
    for (int i = 0; i < 100; ++i) {
        int values[] = {7, -3, 1, 7, 0};
        int expected[] = {-3, 0, 1, 7, 7};
        qsort(values, 5, sizeof(int), compare);
        for (int j = 0; j < 5; ++j)
            if (values[j] != expected[j])
                return 1;
        int key = 1;
        if (bsearch(&key, values, 5, sizeof(int), compare) != &values[2])
            return 2;
        char *buf = malloc(16);
        if (!buf)
            return 3;
        strcpy(buf, "abc");
        if (strlen(buf) != 3 || strcmp(buf, "abd") >= 0)
            return 4;
        if (memcmp_callee(buf, "abc", 3) != 0)
            return 8;
        free(buf);
        buf = calloc(4, 4);
        if (!buf)
            return 9;
        for (int j = 0; j < 16; ++j)
            if (buf[j] != 0)
                return 10;
        strcpy(buf, "abc");
        char *larger = realloc(buf, 32);
        if (!larger || strcmp(larger, "abc") != 0)
            return 11;
        free(larger);
        if (abs_fastcall(-42) != 42)
            return 5;
        if (wcmatch("a*", "abc") == 0)
            return 6;
        int result = setjmp(env);
        if (result == 0)
            longjmp(env, 7);
        if (result != 7)
            return 7;
    }
    printf("ALL PASS\n");
    printf("X");
    return 0;
}
