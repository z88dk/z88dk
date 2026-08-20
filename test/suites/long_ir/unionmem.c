/* Folded offset-0 member store into a LOCAL struct/union.
 *
 * The parser collapses a member access at offset 0 to a bare lvalue, so
 * `u.f = x` reaches ir_build as `(= (lv=u) x)` with no member node left.
 * The store path took the element type from `sym->ctype->ptr` -- which is
 * the ARRAY element type. A struct/union TAG has no `->ptr`, so the member
 * fell back to KIND_INT/width 2:
 *
 *   - a 4-byte member was silently truncated to its low 2 bytes;
 *   - a 6-byte double member aborted the compile outright with
 *     "ir_lower: CONV_TRUNC 6->2 not supported".
 *
 * The assignment node's own type IS the member type; the folded member READ
 * already relied on that. Only the LOCAL case was affected -- a global union
 * goes down a different path -- so every union below must be a local.
 *
 * The float member is only written/read through the integer member, so this
 * stays valid whatever the target's FP format is: it checks that the store
 * wrote the member's full width, not any particular encoding.
 */
#include "test.h"

union u32 { unsigned long l; float f; };
union mix { unsigned int i; unsigned long l; };

/* 4-byte member of a local union: the whole 32 bits must survive. */
static unsigned long ul_roundtrip(unsigned long v)
{
    union u32 t;
    t.l = v;
    return t.l;
}

/* Writing the float member must not leave the other 4 bytes untouched --
   before the fix only 2 bytes were written (or the compile aborted). */
static unsigned long f_store_width(void)
{
    union u32 t;
    t.l = 0xFFFFFFFFUL;
    t.f = 0.0f;              /* zero in every supported format */
    return t.l;              /* low 4 bytes must have been overwritten */
}

/* Union without any float member: the same folded-store path, width 4. */
static unsigned long mix_roundtrip(unsigned long v)
{
    union mix m;
    m.l = v;
    return m.l;
}

/* The narrow member still stores narrow -- the fix must not widen it. */
static unsigned int mix_narrow(unsigned int v)
{
    union mix m;
    m.l = 0;
    m.i = v;
    return m.i;
}

static void test_unionmem(void)
{
    assertEqual(ul_roundtrip(0x12345678UL) == 0x12345678UL, 1);
    assertEqual(ul_roundtrip(0xDEADBEEFUL) == 0xDEADBEEFUL, 1);
    assertEqual(ul_roundtrip(0x0000FFFFUL) == 0x0000FFFFUL, 1);
    assertEqual(ul_roundtrip(0xFFFF0000UL) == 0xFFFF0000UL, 1);

    assertEqual(f_store_width() == 0xFFFFFFFFUL, 0);

    assertEqual(mix_roundtrip(0xCAFEBABEUL) == 0xCAFEBABEUL, 1);
    assertEqual(mix_narrow(0xBEEF) == 0xBEEF, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Folded member store into a local union");
    suite_add_test(test_unionmem);
    return suite_run();
}
