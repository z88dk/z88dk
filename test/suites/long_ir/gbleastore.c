/* [remat-lea] on gbz80: storing `&local` or `&param` to a global. The address
 * is rematerialised from the frame (IR_LEA), so the gbz80 constant word store
 * must not take it: it is not a link-time symbol (it printed `_?` and did not
 * assemble).
 *
 *  - int_param    a word parameter, through a volatile pointer
 *  - long_param   a long parameter, through a plain pointer
 *  - long_local   a long local, through a volatile pointer
 *
 * Every CPU builds it; only gbz80 has the constant word store.
 */
#include "test.h"

static int *volatile esc_i;
static long *esc_l;
static long *volatile esc_lv;

static int int_param(int a)
{
    esc_i = &a;
    *esc_i += 2;
    return a + 1;
}

static long long_param(long a)
{
    esc_l = &a;
    *esc_l += 0x10000L;
    return a + 1;
}

static long long_local(long b)
{
    long a = b;

    esc_lv = &a;
    *esc_lv += 0x20000L;
    return a + 1;
}

static void test_int_param(void)
{
    Assert(int_param(5) == 8, "int param");
}

static void test_long_param(void)
{
    Assert(long_param(0x30005L) == 0x40006L, "long param");
}

static void test_long_local(void)
{
    Assert(long_local(0x30005L) == 0x50006L, "long local");
}

int suite_gbleastore(void)
{
    suite_setup("gb-lea-store");
    suite_add_test(test_int_param);
    suite_add_test(test_long_param);
    suite_add_test(test_long_local);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_gbleastore();
    exit(res);
}
