/* Constant-index access to an ARRAY MEMBER of a LOCAL struct.
 *
 * `s.arr[i]` on a stack struct folded the member offset in TWICE: the member
 * step (`.arr`) adds offsetof(arr) to the address node, and the subscript then
 * added `index*elem + offsetof(arr)` on top of it. The two sibling branches in
 * that subscript (constant-pointer, and the general case) subtract the offset
 * back out; the stack-array branch did not. `struct x { int a; char c;
 * struct y blah[3]; }` addressed blah at 6 instead of 3, so blah[2] read two
 * bytes PAST the end of a 15-byte struct.
 *
 * It stayed hidden because the shape it broke first was a zero-initialised
 * struct, where reading the wrong (also zero) bytes gives the right answer --
 * so every value here is DISTINCT and NON-ZERO, and the offsets are asserted
 * directly as well as the values.
 *
 * A global struct takes a different branch and was always correct; it is the
 * control. Runtime (non-constant) indices take the scaled-OP_MULT path, also
 * always correct, and are covered too.
 */
#include "test.h"
typedef unsigned long u32;

struct y { u32 l; };
struct x { int a; char c; struct y blah[3]; };
struct w { char c; u32 arr[3]; };

static struct x g;          /* control: global takes the other branch */

static void fill_x(struct x *p)
{
    p->a = 0x1234; p->c = 0x5a;
    p->blah[0].l = 0x11111111ul;
    p->blah[1].l = 0x22222222ul;
    p->blah[2].l = 0x33333333ul;   /* the element that ran off the end */
}

/* Offsets, asserted directly, with CONSTANT indices -- that is the shape that
   was broken. A runtime index takes the scaled-OP_MULT path and was always
   correct, so off_rt is the control. sizeof is 15 and was always right, so a
   wrong offset for blah[2] (4 bytes at 11) puts it past the end. */
static int off_c0(void){ struct x u; return (int)((char *)&u.blah[0] - (char *)&u); }
static int off_c1(void){ struct x u; return (int)((char *)&u.blah[1] - (char *)&u); }
static int off_c2(void){ struct x u; return (int)((char *)&u.blah[2] - (char *)&u); }
static int off_rt(int i){ struct x u; return (int)((char *)&u.blah[i] - (char *)&u); }

static u32 local_const_idx(int which)
{
    struct x u;
    fill_x(&u);
    if (which == 0) return u.blah[0].l;
    if (which == 1) return u.blah[1].l;
    return u.blah[2].l;            /* the failing one */
}

static u32 local_runtime_idx(int i)
{
    struct x u;
    fill_x(&u);
    return u.blah[i].l;            /* scaled-OP_MULT path */
}

static u32 global_const_idx(void)
{
    fill_x(&g);
    return g.blah[2].l;            /* control */
}

/* A one-byte prefix: blah at 1, not 2. */
static u32 short_prefix(void)
{
    struct w v;
    v.c = 0x7e;
    v.arr[0] = 0xaaaaaaaaul; v.arr[1] = 0xbbbbbbbbul; v.arr[2] = 0xccccccccul;
    return v.arr[2];
}

/* Writing through the same address must land where the read looks. */
static u32 write_then_read(void)
{
    struct x u;
    fill_x(&u);
    u.blah[2].l = 0x44444444ul;
    return u.blah[2].l;
}

/* A field of a GLOBAL array element at a runtime index: `g_recs[i].c`. The
 * field offset rides in the symbol operand (`_g_recs+4`) and the index is
 * added to it, so a wrong fold shows as a neighbouring field or element read
 * and written instead. Every value is distinct. */
struct rec { int a; int b; int c; int d; };
static struct rec g_recs[4];
static int g_grid[4][4];

static void sym_field_fill(void)
{
    int i;
    for (i = 0; i < 4; i++) {
        g_recs[i].a = 0x100 + i;
        g_recs[i].b = 0x200 + i;
        g_recs[i].c = 0x300 + i;
        g_recs[i].d = 0x400 + i;
        g_grid[i][0] = 0x500 + i;
        g_grid[i][3] = 0x600 + i;
    }
}
static int sym_field_read(int i)  { return g_recs[i].c; }
static void sym_field_write(int i, int v) { g_recs[i].c = v; }
static int grid_col3(int i)       { return g_grid[i][3]; }
static void grid_col3_set(int i, int v) { g_grid[i][3] = v; }

static void sym_field_run(void)
{
    sym_field_fill();
    Assert(sym_field_read(0) == 0x300, "recs[0].c");
    Assert(sym_field_read(3) == 0x303, "recs[3].c");
    Assert(grid_col3(1) == 0x601, "grid[1][3]");
    Assert(grid_col3(2) == 0x602, "grid[2][3]");
    sym_field_write(2, 0x777);
    Assert(g_recs[2].c == 0x777, "recs[2].c written");
    Assert(g_recs[2].b == 0x202 && g_recs[2].d == 0x402, "recs[2] neighbours");
    Assert(g_recs[1].c == 0x301 && g_recs[3].c == 0x303, "other elements");
    grid_col3_set(1, 0x888);
    Assert(g_grid[1][3] == 0x888, "grid[1][3] written");
    Assert(g_grid[1][0] == 0x501 && g_grid[2][3] == 0x602, "grid neighbours");
}

static void run(void)
{
    Assert(sizeof(struct x) == 15, "sizeof struct x");
    Assert(off_c0() == 3,  "offsetof blah[0], constant index");
    Assert(off_c1() == 7,  "offsetof blah[1], constant index");
    Assert(off_c2() == 11, "offsetof blah[2], constant index");
    Assert(off_rt(2) == 11, "offsetof blah[2], runtime index");

    Assert(local_const_idx(0) == 0x11111111ul, "local blah[0]");
    Assert(local_const_idx(1) == 0x22222222ul, "local blah[1]");
    Assert(local_const_idx(2) == 0x33333333ul, "local blah[2]");

    Assert(local_runtime_idx(0) == 0x11111111ul, "runtime blah[0]");
    Assert(local_runtime_idx(2) == 0x33333333ul, "runtime blah[2]");

    Assert(global_const_idx() == 0x33333333ul, "global blah[2]");
    Assert(short_prefix() == 0xccccccccul, "one-byte prefix arr[2]");
    Assert(write_then_read() == 0x44444444ul, "write then read blah[2]");

    /* The neighbouring member must be untouched by the blah[2] write. */
    {
        struct x u;
        fill_x(&u);
        u.blah[2].l = 0x44444444ul;
        Assert(u.a == 0x1234, "a intact");
        Assert(u.c == 0x5a, "c intact");
        Assert(u.blah[1].l == 0x22222222ul, "blah[1] intact");
    }
    sym_field_run();
}
int main(int c, char **v)
{
    (void)c; (void)v;
    suite_setup("memberarr");
    suite_add_test(run);
    return suite_run();
}
