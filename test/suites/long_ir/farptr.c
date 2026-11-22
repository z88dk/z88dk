/* A __far pointer is four bytes in registers and three in memory. Stored,
 * loaded and stepped through a computed address (array element, struct member,
 * pointer parameter, post-step) it must touch exactly three bytes and step
 * three bytes, whatever the CPU.
 */
#include "test.h"

/* A __far pointer is 3 bytes in memory. Stored through a computed address
   (array element, struct member) it must not touch the neighbouring byte. */
struct far_rec { unsigned char pre; char * __far fp; unsigned char post; };
static char * __far far_mk(long v) { return (char * __far)v; }
int far_ptrmem(void)
{
    char * __far arr[3];
    struct far_rec rec;
    char * __far *pp = arr;
    int i, ok = 1;
    unsigned char *raw = (unsigned char *)arr;

    for (i = 0; i < 9; i++) raw[i] = 0xA5;
    for (i = 0; i < 3; i++) pp[i] = far_mk(0x1000L * (i + 1) + i);
    for (i = 0; i < 3; i++)
        if ((unsigned long)arr[i] != 0x1000UL * (i + 1) + i) ok = 0;
    if ((unsigned long)pp[2] != 0x3002UL) ok = 0;
    rec.pre = 0x11; rec.post = 0x22;
    rec.fp = far_mk(0x20304L);
    if (rec.pre != 0x11 || rec.post != 0x22) ok = 0;
    if ((unsigned long)rec.fp != 0x20304UL) ok = 0;
    return ok;
}

/* The same through a pointer parameter: `*q++` steps 3 bytes, and a constant
   far pointer stores 3 bytes. */
int far_ptrstep(char * __far *q, unsigned char *raw)
{
    char * __far a, * __far b;
    int ok = 1, i;
    for (i = 0; i < 12; i++) raw[i] = 0xA5;
    q[0] = far_mk(0x10001L);
    q[1] = far_mk(0x20002L);
    a = *q++; b = *q++;
    if ((unsigned long)a != 0x10001UL || (unsigned long)b != 0x20002UL) ok = 0;
    q = (char * __far *)raw;
    q[1] = 0;
    q[2] = (char * __far)0x40506L;
    if (raw[2] != 0xA5 || raw[3] || raw[4] || raw[5] || raw[6] != 6 || raw[7] != 5
        || raw[8] != 4 || raw[9] != 0xA5) ok = 0;
    *q++ = far_mk(0x70809L);
    if (raw[0] != 9 || raw[2] != 7 || raw[3] != 0 || q != (char * __far *)(raw + 3)) ok = 0;
    return ok;
}

struct far_s { unsigned char a; char * __far p; unsigned char b; };
union far_u { char * __far p; unsigned char c[3]; };
struct far_s far_gs[2];
char * __far far_gi[2] = { (char * __far)0x10101L, (char * __far)0x20202L };

/* Array and struct shapes: a local initialiser, an array of structs, a union,
   and stepping a pointer to far pointers. */
int far_shapes(void)
{
    char * __far l[3] = { (char * __far)0x50505L, (char * __far)0x60606L, (char * __far)0x70707L };
    struct far_s a[2];
    union far_u u;
    char * __far *pp = l;
    int i, ok = 1;

    if ((unsigned long)l[0] != 0x50505UL || (unsigned long)l[1] != 0x60606UL
        || (unsigned long)l[2] != 0x70707UL) ok = 0;
    if ((unsigned long)far_gi[0] != 0x10101UL || (unsigned long)far_gi[1] != 0x20202UL) ok = 0;
    for (i = 0; i < 2; i++) { a[i].a = 0x11; a[i].b = 0x22; a[i].p = far_mk(0x1000L + i); }
    for (i = 0; i < 2; i++) {
        far_gs[i].a = 3; far_gs[i].b = 4; far_gs[i].p = far_mk(0x2000L + i);
        if ((unsigned long)a[i].p != 0x1000UL + i || a[i].a != 0x11 || a[i].b != 0x22) ok = 0;
    }
    for (i = 0; i < 2; i++)
        if ((unsigned long)far_gs[i].p != 0x2000UL + i || far_gs[i].a != 3 || far_gs[i].b != 4) ok = 0;
    u.p = far_mk(0x0A0B0CL);
    if (u.c[0] != 0x0C || u.c[1] != 0x0B || u.c[2] != 0x0A) ok = 0;
    if ((unsigned long)*(pp + 1) != 0x60606UL || (unsigned long)pp[2] != 0x70707UL) ok = 0;
    if ((int)((pp + 2) - pp) != 2 || (int)((unsigned char *)(pp + 2) - (unsigned char *)pp) != 6) ok = 0;
    pp += 2; pp--;
    if ((unsigned long)*pp != 0x60606UL) ok = 0;
    return ok;
}

static void check_shapes(void)  { assertEqual(far_shapes(), 1); }
static void check_ptrmem(void)  { assertEqual(far_ptrmem(), 1); }
static void check_ptrstep(void)
{
    unsigned char raw[12];
    char * __far fa[3];
    assertEqual(far_ptrstep(fa, raw), 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("far pointer in memory");
    suite_add_test(check_ptrmem);
    suite_add_test(check_shapes);
    suite_add_test(check_ptrstep);
    return suite_run();
}
