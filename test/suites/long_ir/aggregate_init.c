/* Local aggregate zero-initialisation `= {0}` / `= {}` — lowered as a block
   IR_MEMSET of the whole slot (init_is_all_zero), not per-element stores that
   blow the budget on a big array-of-struct. Guards testsuite/initialise_to_zero.
   dirty() fills the stack first so a non-zeroed slot would read garbage. */
#include "test.h"

struct y { long l; };
struct x { int a; char c; struct y blah[3]; };

static void dirty(void){ volatile char buf[200]; int i; for (i = 0; i < 200; i++) buf[i] = (char)0xAA; }

static int zero_arr_struct(void)
{
    struct x un[5] = {0};
    int s = 0, i, j;
    for (i = 0; i < 5; i++) {
        s += un[i].a + un[i].c;
        for (j = 0; j < 3; j++) s += (int)un[i].blah[j].l;
    }
    return s;                 /* all zero → 0 */
}
static int zero_one_struct(void)
{
    struct x u = {0};
    return u.a + u.c + (int)u.blah[0].l + (int)u.blah[2].l;   /* 0 */
}
static int zero_arr_int(void)
{
    int a[16] = {0};
    int s = 0, i;
    for (i = 0; i < 16; i++) s += a[i];
    return s;                 /* 0 */
}
static int first_set(void)
{
    int a[8] = {7};           /* a[0]=7, rest 0 — not all-zero path */
    int s = 0, i;
    for (i = 0; i < 8; i++) s += a[i];
    return s;                 /* 7 */
}

static void test_agg_init(void)
{
    dirty(); assertEqual(zero_arr_struct(), 0);
    dirty(); assertEqual(zero_one_struct(), 0);
    dirty(); assertEqual(zero_arr_int(), 0);
    dirty(); assertEqual(first_set(), 7);
}
int main(void){ suite_setup("agg-init"); suite_add_test(test_agg_init); return suite_run(); }
