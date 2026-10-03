/* AN sp-MODE FUNCTION KEEPS THE CALLER'S IX ACROSS AN INDIRECT CALL.
 *
 * In sp mode IX is callee-saved: fp-mode callers (sccz80, zsdcc) use it as
 * their frame pointer. A function that dispatches a call through IX must save
 * and restore it; one that makes a plain near call (`call l_jphl`) never
 * touches IX, so the push/pop was dead and is no longer emitted. The
 * fastcall dispatch still goes through IX and still saves it.
 *
 * Each driver loads a sentinel into IX, calls the function under test, and
 * reads IX back. Z80-family only, sp mode only (fp mode owns IX).
 */
#include "test.h"

static unsigned ix_after;
static int hits;

static void bump(void)             { hits++; }
static int  inc5(int x) __z88dk_fastcall { hits += x; return x + 5; }

static void (*cb)(void) = bump;
typedef int (*fcp)(int) __z88dk_fastcall;
static fcp fcb = inc5;

/* plain near indirect call: no IX needed */
static void plain(void)            { if (cb) cb(); }
/* plain indirect call with arguments and a result */
static int  plain_arg(int (*f)(int, int), int a, int b) { return f(a, b); }
/* fastcall dispatch: goes through IX */
static int  via_fastcall(int v)    { return fcb(v); }

static int add2(int a, int b)      { return a + b; }

static void test_ixind(void)
{
    hits = 0;

    __asm__("ld ix,0x5a5a");
    plain();
    __asm__("ld (_ix_after),ix");
    assertEqual(ix_after, 0x5a5a);
    assertEqual(hits, 1);

    __asm__("ld ix,0x1234");
    assertEqual(plain_arg(add2, 3, 4), 7);
    __asm__("ld (_ix_after),ix");
    assertEqual(ix_after, 0x1234);

    __asm__("ld ix,0x7777");
    assertEqual(via_fastcall(10), 15);
    __asm__("ld (_ix_after),ix");
    assertEqual(ix_after, 0x7777);
    assertEqual(hits, 11);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("sp-mode IX across indirect calls");
    suite_add_test(test_ixind);
    return suite_run();
}
