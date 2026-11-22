/* struct/union passed BY VALUE as a parameter (and argument).
 *
 * 80cc once rejected struct params (build_fail "param kind 11 not yet
 * supported"). The caller now pushes a COPY of the struct onto the stack
 * (IR_PUSH_STRUCT: allocate size + block-copy, byte i at sp+i — matches sccz80
 * and SDCC sdcccall(0)); the callee reads/writes it IN PLACE in the arg area
 * (PARAM_IN_PLACE — no local copy, no double stack).
 *
 * Runs on z80 (math48) and gbz80/8080/8085 (mbf32). Only int/char/long fields
 * (no long long / float) so it links on every CPU AND exercises the no-`ldir`
 * block-copy path (z80asm's __z80asm__ldir lowering) on 808x/gbz80. Args are
 * runtime values where folding could otherwise hide a bug.
 */

#include "test.h"

struct two  { int x; int y; };                 /* 4 bytes, even */
struct big  { char a; int b; long c; };         /* 7 bytes, odd, mixed width */
union  iu   { int i; char c[2]; };

/* --- single struct param, multi-field --------------------------------- */
int sv_sum_two(struct two p) { return p.x + p.y; }

static void test_struct_param(void)
{
    struct two t;
    t.x = 10; t.y = 20;
    Assert(sv_sum_two(t) == 30, "struct-by-value param: read both members");
}

/* --- odd-size struct with mixed-width fields --------------------------- */
long sv_sum_big(struct big s) { return (long)s.a + s.b + s.c; }

static void test_struct_mixed_odd(void)
{
    struct big b;
    b.a = 1; b.b = 200; b.c = 30000L;
    Assert(sv_sum_big(b) == 30201L,
           "odd-size mixed-width struct param (char+int+long, 7 bytes)");
}

/* --- two struct args + struct mixed with scalar args ------------------ */
int sv_two_structs(struct two p, struct two q) { return p.x + p.y + q.x + q.y; }
int sv_mixed(int pre, struct two p, int post)  { return pre * 100 + p.x + p.y + post; }

static void test_struct_multi_and_mixed(void)
{
    struct two t, q;
    t.x = 3; t.y = 4; q.x = 5; q.y = 6;
    Assert(sv_two_structs(t, q) == 18, "two struct-by-value args");
    Assert(sv_mixed(2, t, 9) == 216, "struct arg between scalar args (2*100+3+4+9)");
}

/* --- modifying a member in place (the param is the callee's copy) ------ */
int sv_modify(struct two p) { p.x += 5; p.y += 7; return p.x + p.y; }

static void test_struct_inplace_write(void)
{
    struct two t;
    t.x = 3; t.y = 4;
    Assert(sv_modify(t) == 19, "writing a by-value struct member in place (8+11)");
    /* the caller's t is unaffected — it pushed a copy */
    Assert(t.x == 3 && t.y == 4, "caller's struct unchanged after by-value call");
}

/* --- union by value --------------------------------------------------- */
int sv_uni(union iu v) { return v.i; }

static void test_union_param(void)
{
    union iu u;
    u.i = 0x1234;
    Assert(sv_uni(u) == 0x1234, "union-by-value param");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("struct/union by-value parameters");
    suite_add_test(test_struct_param);
    suite_add_test(test_struct_mixed_odd);
    suite_add_test(test_struct_multi_and_mixed);
    suite_add_test(test_struct_inplace_write);
    suite_add_test(test_union_param);
    return suite_run();
}
