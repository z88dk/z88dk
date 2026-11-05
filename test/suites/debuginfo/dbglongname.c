/* Debug-info regression: long names, compiled by the long path of the
 * longpath target. A struct tag of 126 characters (the compilers' limit) makes
 * the type field of a record longer than 128 characters, and a function name
 * of 100 characters makes the static-local name ticks looks up (st_<function>_<name>)
 * longer than 128 too, and pick() returns a pointer to the struct, so the type
 * field of its function record is longer than 128 as well. check_longname.sh
 * asserts what ticks shows.
 */

struct tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq { int m1; int m2; };

static struct tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq gt = { 5, 6 };

int fwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww(int x)
{
    static int sl = 11;
    struct tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq lt;
    struct tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq *pp[2];
    lt.m1 = x;
    lt.m2 = gt.m2 + sl;
    pp[0] = &lt;
    pp[1] = &gt;
    x = pp[0]->m1 + pp[1]->m2;      /* BREAK f */
    return x + lt.m2;
}

static struct tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq *pick(int i)
{
    struct tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq *r = &gt;
    r->m1 = r->m1 + i;              /* BREAK p */
    return r;
}

int main(void)
{
    return fwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww(3) + pick(1)->m1;
}
