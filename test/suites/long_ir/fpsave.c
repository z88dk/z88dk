/* Frame-pointer calls save the frame register (ADR 0122, issue #3209).
 *
 * Z80, -fframe-pointer only. The callees are __naked and set IX to 0.
 * They do not write IY: a fastcall function pointer is dispatched
 * through IY in frame-pointer mode. An 80cc C callee would preserve IX
 * in its own prologue, so it cannot stand in for newlib's sccz80 objects.
 *
 * Each caller keeps a real frame (a volatile array). The value under
 * test is stored into a volatile local after the call, so a pop of the
 * frame that lands after that store fails. Stack mode is not a target.
 * IX may be an idx2 home there, and the compiler does not save it.
 */
#include "test.h"

struct Pair {
    int a;
    int b;
};

typedef int (*ip_t)(int);
typedef int (*fcp_t)(int) __z88dk_fastcall;

static int kill_int(int x) __naked
{
#asm
    ld hl,2
    add hl,sp
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld ix,0
    ret
#endasm
}

static int kill_none(void) __naked
{
#asm
    ld hl,42
    ld ix,0
    ret
#endasm
}

static int kill_fc(int x) __z88dk_fastcall __naked
{
#asm
    ld ix,0
    ret
#endasm
}

/* __smallc pushes left to right, so the second argument is at sp+2.
 * Result is 2 * second + first. A swapped pop order returns 62 for
 * (20, 22) instead of 64. */
static int kill_ce(int a, int b) __z88dk_callee __naked
{
#asm
    pop de
    pop hl
    pop bc
    add hl,hl
    add hl,bc
    ld ix,0
    push de
    ret
#endasm
}

/* Caller emits ld a,<argument words>. The frame word must stay out
 * of that count. */
static int kill_va(int a, int b, int c, ...) __naked
{
#asm
    ld l,a
    ld h,0
    ld ix,0
    ret
#endasm
}

/* DEHL = 1:x. A cleanup pop into DE shows up in the high word. */
static long kill_long(int x) __naked
{
#asm
    ld hl,2
    add hl,sp
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,1
    ld ix,0
    ret
#endasm
}

/* Last argument (the int) is at sp+2 under __smallc. The struct image
 * sits below it. */
static int kill_st(struct Pair p, int n) __naked
{
#asm
    ld hl,2
    add hl,sp
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld ix,0
    ret
#endasm
}

static int direct_call(int x)
{
    volatile int guard[2];
    volatile int got;

    guard[0] = 11;
    guard[1] = 22;
    got = kill_int(x);
    if (guard[0] != 11) return -1;
    if (guard[1] != 22) return -2;
    return got;
}

static int zero_call(void)
{
    volatile int guard[2];
    volatile int got;

    guard[0] = 3;
    guard[1] = 4;
    got = kill_none();
    if (guard[0] != 3) return -1;
    if (guard[1] != 4) return -2;
    return got;
}

static int local_ptr(int x)
{
    volatile int guard[2];
    volatile int got;
    ip_t p;

    guard[0] = 15;
    guard[1] = 16;
    p = kill_int;
    got = p(x);
    if (guard[0] != 15) return -1;
    if (guard[1] != 16) return -2;
    return got;
}

static int reload_ptr(int x)
{
    volatile int guard[2];
    volatile ip_t tab[2];
    volatile int got;
    int sel;

    guard[0] = 1;
    guard[1] = 2;
    tab[0] = kill_int;
    tab[1] = kill_int;
    sel = kill_none();
    got = tab[sel & 1](x);
    if (guard[0] != 1) return -1;
    if (guard[1] != 2) return -2;
    if (sel != 42) return -3;
    return got;
}

static int array_ptr(int x)
{
    volatile int guard[2];
    volatile ip_t tab[2];
    volatile int got;

    guard[0] = 13;
    guard[1] = 14;
    tab[0] = kill_int;
    tab[1] = kill_int;
    got = tab[1](x);
    if (guard[0] != 13) return -1;
    if (guard[1] != 14) return -2;
    return got;
}

static int apply(ip_t fn, int x)
{
    volatile int guard[2];
    volatile ip_t tab[2];
    volatile int got;
    int sel;

    guard[0] = 5;
    guard[1] = 6;
    tab[0] = fn;
    tab[1] = fn;
    sel = kill_none();
    got = tab[sel & 1](x);
    if (guard[0] != 5) return -1;
    if (guard[1] != 6) return -2;
    if (sel != 42) return -3;
    return got;
}

static int via_apply(int x)
{
    volatile int guard[2];
    volatile int got;

    guard[0] = 7;
    guard[1] = 8;
    got = apply(kill_int, x);
    if (guard[0] != 7) return -4;
    if (guard[1] != 8) return -5;
    return got;
}

static int nested_call(int x)
{
    volatile int guard[2];
    volatile int got;

    guard[0] = 9;
    guard[1] = 10;
    got = kill_int(kill_int(x));
    if (guard[0] != 9) return -1;
    if (guard[1] != 10) return -2;
    return got;
}

static int struct_call(void)
{
    struct Pair s;
    volatile int guard[2];
    volatile int got;

    s.a = 3;
    s.b = 4;
    guard[0] = 7;
    guard[1] = 8;
    got = kill_st(s, kill_none());
    if (guard[0] != 7) return -1;
    if (guard[1] != 8) return -2;
    return got;
}

static int fast_direct(int x)
{
    volatile int guard[2];
    volatile int got;

    guard[0] = 1;
    guard[1] = 2;
    got = kill_fc(x);
    if (guard[0] != 1) return -1;
    if (guard[1] != 2) return -2;
    return got;
}

static int fast_ptr(int x)
{
    volatile int guard[2];
    volatile int got;
    fcp_t p;

    guard[0] = 3;
    guard[1] = 4;
    p = kill_fc;
    got = p(x);
    if (guard[0] != 3) return -1;
    if (guard[1] != 4) return -2;
    return got;
}

static int fast_reload(int x)
{
    volatile int guard[2];
    volatile fcp_t tab[2];
    volatile int got;
    int sel;

    guard[0] = 5;
    guard[1] = 6;
    tab[0] = kill_fc;
    tab[1] = kill_fc;
    sel = kill_none();
    got = tab[sel & 1](x);
    if (guard[0] != 5) return -1;
    if (guard[1] != 6) return -2;
    if (sel != 42) return -3;
    return got;
}

static int callee_call(void)
{
    volatile int guard[2];
    volatile int got;

    guard[0] = 1;
    guard[1] = 2;
    got = kill_ce(20, 22);
    if (guard[0] != 1) return -1;
    if (guard[1] != 2) return -2;
    return got;
}

static int variadic_call(void)
{
    volatile int guard[2];
    volatile int got3;
    volatile int got4;

    guard[0] = 1;
    guard[1] = 2;
    got3 = kill_va(1, 2, 3);
    got4 = kill_va(1, 2, 3, 4);
    if (guard[0] != 1) return -1;
    if (guard[1] != 2) return -2;
    if (got3 != 3) return got3;
    return got4;
}

static int long_call(int x)
{
    volatile int guard[2];
    volatile long got;
    int hi;

    guard[0] = 8;
    guard[1] = 9;
    got = kill_long(x);
    hi = (int)(got >> 16);
    if (guard[0] != 8) return -1;
    if (guard[1] != 9) return -2;
    if ((int)got != x) return -3;
    if (hi != 1) return -4;
    return x;
}

static void test_direct(void)      { assertEqual(direct_call(40), 40); }
static void test_zero(void)        { assertEqual(zero_call(), 42); }
static void test_local_ptr(void)   { assertEqual(local_ptr(40), 40); }
static void test_reload(void)      { assertEqual(reload_ptr(40), 40); }
static void test_array(void)       { assertEqual(array_ptr(40), 40); }
static void test_callback(void)    { assertEqual(via_apply(40), 40); }
static void test_nested(void)      { assertEqual(nested_call(40), 40); }
static void test_struct(void)      { assertEqual(struct_call(), 42); }
static void test_fast_direct(void) { assertEqual(fast_direct(40), 40); }
static void test_fast_ptr(void)    { assertEqual(fast_ptr(40), 40); }
static void test_fast_reload(void) { assertEqual(fast_reload(40), 40); }
static void test_callee(void)      { assertEqual(callee_call(), 64); }
static void test_variadic(void)    { assertEqual(variadic_call(), 4); }
static void test_long(void)        { assertEqual(long_call(40), 40); }

int main(void)
{
    suite_setup("fpsave");
    suite_add_test(test_direct);
    suite_add_test(test_zero);
    suite_add_test(test_local_ptr);
    suite_add_test(test_reload);
    suite_add_test(test_array);
    suite_add_test(test_callback);
    suite_add_test(test_nested);
    suite_add_test(test_struct);
    suite_add_test(test_fast_direct);
    suite_add_test(test_fast_ptr);
    suite_add_test(test_fast_reload);
    suite_add_test(test_callee);
    suite_add_test(test_variadic);
    suite_add_test(test_long);
    return suite_run();
}
