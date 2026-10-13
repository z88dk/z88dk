/* strlen of a string literal is a compile-time constant: plain, empty,
 * embedded NUL, in an expression, as a loop bound and a call argument. */
#include "test.h"
#include <string.h>

static const char *volatile vp;
static int sink;

static size_t plain(void)   { return strlen("hello"); }
static size_t empty(void)   { return strlen(""); }
static size_t nul(void)     { return strlen("ab\0cd"); }
static size_t sum(void)     { return strlen("abc") + strlen("de") * 2; }
static int    cmp(void)     { return strncmp("quit now", "quit", strlen("quit")); }
static int    loop(void)    { int i, n = 0; for (i = 0; i < (int)strlen("wxyz"); i++) n += i; return n; }
static size_t rt(const char *s) { return strlen(s); }
static size_t dyn(const char *s) { return strlen(s) + strlen("xy"); }

static void test_strlenlit(void)
{
    vp = "hello";
    assertEqual(rt(vp), 5);
    assertEqual(plain(), 5);
    assertEqual(plain(), rt("hello"));
    assertEqual(empty(), 0);
    assertEqual(nul(), 2);
    assertEqual(sum(), 7);
    assertEqual(cmp(), 0);
    assertEqual(loop(), 6);
    assertEqual(dyn("abcd"), 6);
    sink = (int)strlen("abc");
    assertEqual(sink, 3);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("strlen literal");
    suite_add_test(test_strlenlit);
    return suite_run();
}
