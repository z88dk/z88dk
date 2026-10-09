/* [de-call-asm] A call is taken to read DE only when the callee can take an
 * argument there: __sdcccall(1), a 4-byte fastcall argument, or a DE
 * preserve. The emitter's per-call record now also answers for asm-linkage
 * targets and `call l_jphl`; l_case and l_setjmp are clean by audit.
 *
 *  - sc1_ptr     an indirect __sdcccall(1) call whose 2nd argument rides DE:
 *                DE must survive into l_jphl.
 *  - plain_ptr   an indirect smallc call after a table address computed in
 *                DE; the fold may now use `ld de,_sym`.
 *  - sw_after    a switch (l_case) right after a symbol-plus-index address.
 *  - jmp_after   setjmp right after a zero store to a local.
 *  - lib_after   strlen (asm linkage) after an array address.
 *
 * Every CPU builds it. _keep runs the opt-out.
 */
#include "test.h"
#include <setjmp.h>
#include <string.h>

static int tab[8] = { 3, 1, 4, 1, 5, 9, 2, 6 };
static char names[4][6] = { "a", "bb", "ccc", "dddd" };
static jmp_buf jb;
static int seen;

#if defined(__GBZ80) || defined(__8080) || defined(__8085) || defined(__KR580VM1) || defined(__VM1)
#define SC1                     /* __sdcccall(1) is z80-family only */
#else
#define SC1 __sdcccall(1)
#endif

static int sub2(int a, int b) SC1
{
    return a - b;
}

static void bump(void)
{
    seen++;
}

typedef int (*sc1fn)(int, int) SC1;
typedef void (*voidfn)(void);

static sc1fn sp = sub2;
static voidfn vp = bump;

static int sc1_ptr(int i, int j)
{
    return sp(tab[i], tab[j]);
}

static int plain_ptr(int i)
{
    int v = tab[i];

    vp();
    return v + tab[i + 1];
}

static int sw_after(int i)
{
    int v = tab[i];

    switch (i) {
    case 0: return v + 100;
    case 1: return v + 200;
    case 2: return v + 300;
    }
    return v;
}

static int jmp_after(int i)
{
    volatile int stage = 0;

    if (setjmp(jb) == 0) {
        stage = tab[i];
        if (stage > 3)
            longjmp(jb, 1);
        return stage;
    }
    return stage * 10;
}

static int lib_after(int i)
{
    return (int)strlen(names[i]) * 10 + tab[i];
}

static void test_sc1_ptr(void)
{
    Assert(sc1_ptr(5, 0) == 6, "9 - 3");
    Assert(sc1_ptr(0, 5) == -6, "3 - 9");
    Assert(sc1_ptr(4, 4) == 0, "equal");
}

static void test_plain_ptr(void)
{
    seen = 0;
    Assert(plain_ptr(2) == 5, "4 + 1");
    Assert(plain_ptr(6) == 8, "2 + 6");
    Assert(seen == 2, "callback ran");
}

static void test_sw_after(void)
{
    Assert(sw_after(0) == 103, "case 0");
    Assert(sw_after(1) == 201, "case 1");
    Assert(sw_after(2) == 304, "case 2");
    Assert(sw_after(5) == 9, "default");
}

static void test_jmp_after(void)
{
    Assert(jmp_after(0) == 3, "no longjmp");
    Assert(jmp_after(4) == 50, "longjmp");
}

static void test_lib_after(void)
{
    Assert(lib_after(0) == 13, "a");
    Assert(lib_after(3) == 41, "dddd");
}

int suite_decallasm(void)
{
    suite_setup("de-call-asm");
    suite_add_test(test_sc1_ptr);
    suite_add_test(test_plain_ptr);
    suite_add_test(test_sw_after);
    suite_add_test(test_jmp_after);
    suite_add_test(test_lib_after);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_decallasm();
    exit(res);
}
