/* [prepush-straddle] A value defined inside a pre-pushed argument group and
 * read after the call (examples/console/mm.c). BC is saved at the group's
 * first push, before the value exists, so a BC home for it would be undone by
 * the restore after the call. The shape used to abort the compile in sp mode. */
#include "test.h"

static int acc, calls;
static char hist[64];
static int npeg = 4, bflag, ntries = 7, ngames = 2;

static void say(const char *s, int v) { acc += v * 3 + (s[0] == 'x'); calls++; }
static void say1(const char *s) { acc += s[0]; calls++; }
static void say2(const char *s, int a, int b) { acc += a + b + s[0]; calls++; }
static int check(void) { return 5; }
static int rguess(const char *p, char *w) { w[0] = p[0]; return 1; }
static int match(char *a, int g) { (void)a; return g == 2 ? (4 << 4) : (g == 0 ? 0x21 : 0x03); }

static int play(int argc, char **argv)
{
    int i, j, guesses, t = 0;
    char *trial, *arg;
    for (i = 1; i < argc; i++) {
        if (*(arg = argv[i]) == '-')
            switch (*++arg) {
            default: say1(argv[i]); return -1;
            }
        { say1("usage"); return -1; }
    }
    for (guesses = 0;; guesses++) {
        if (bflag)
            say("x", check());
        if (!rguess("test", trial = &hist[npeg * guesses]))
            break;
        j = match(trial, guesses);
        say(j >> 4 ? "x" : "y", j >> 4);
        if ((j >> 4) - 1) t += 7;
        if (j == (npeg << 4)) {
            say("x", ++guesses);
            i = ntries / ngames;
            say2("a", i, ntries * 100 / ngames % 100);
            return t + guesses;
        }
    }
    return -2;
}

static void test_prestrad(void)
{
    char *argv[1] = { "mm" };
    acc = calls = 0;
    /* guesses 0: j=0x21, (j>>4)-1=1 -> +7; 1: j=0x03, (j>>4)-1=-1 -> +7;
       2: j=0x40, (j>>4)-1=3 -> +7, then return 21 + 3 */
    assertEqual(play(1, argv), 21 + 3);
    assertEqual(calls, 3 + 1 + 1);
    /* acc: 3*(2+0+4) + 2 (x for nonzero j>>4) + (3*3+1) + (3 + 300%100... ) */
    assertEqual(acc, 3 * (2 + 0 + 4) + 2 + (3 * 3 + 1) + (3 + 350 % 100 + 'a'));
}

int main(int argc, char *argv[])
{
    suite_setup("prestrad");
    suite_add_test(test_prestrad);
    return suite_run();
}
