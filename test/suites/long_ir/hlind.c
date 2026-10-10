/* A word read at a small offset from a pointer, including negative offsets,
 * offsets past a signed byte, a value kept across a second read, and a symbol
 * address loaded and then overwritten. */
#include "test.h"

struct big { int w[80]; };
struct rec { int a; int b; char c; int d; int e; };

int tab[16];
struct big bigrec;
struct rec rr;
int gsel;

static int fa(struct rec *p)                { return p->a; }
static int fb(struct rec *p)                { return p->b; }
static int fd(struct rec *p)                { return p->d; }
static int fe(struct rec *p)                { return p->e; }
static int sum2(struct rec *p)              { return p->b + p->d; }
static int neg3(int *p)                     { return p[-3]; }
static int neg60(int *p)                    { return p[-60]; }
static int pos63(int *p)                    { return p[63]; }
static int pos64(int *p)                    { return p[64]; }
static int pos70(struct big *p)             { return p->w[70]; }
static int far0(struct big *p)              { return p->w[79] + p->w[0]; }
static int keep(struct rec *p)              { int x = p->d; int y = p->e; return x * 3 + y; }
static int sel(int i)                       { return tab[i] == 4096; }
static int viaptr(struct rec *p, int k)     { return k ? p->d : p->e; }
struct node { int val; struct node *next; int pad; int tag; };
static int sumlist(struct node *p)
{
    int t = 0;
    while (p) { t += p->val + p->tag; p = p->next; }
    return t;
}
static int sumrecs(struct rec *p, int n)
{
    int i, t = 0;
    for (i = 0; i < n; i++) t += p[i].d - p[i].e;
    return t;
}
static unsigned uw(unsigned *p)             { return p[2] + p[3]; }

static void check(void)
{
    int i;
    int arr[130];
    unsigned ua[6] = { 1, 2, 30000, 40000, 5, 6 };

    rr.a = 11; rr.b = 22; rr.c = 33; rr.d = 44; rr.e = 55;
    assertEqual(fa(&rr), 11);
    assertEqual(fb(&rr), 22);
    assertEqual(fd(&rr), 44);
    assertEqual(fe(&rr), 55);
    assertEqual(sum2(&rr), 66);
    assertEqual(keep(&rr), 44 * 3 + 55);
    assertEqual(viaptr(&rr, 1), 44);
    assertEqual(viaptr(&rr, 0), 55);
    for (i = 0; i < 130; i++) arr[i] = i * 7 - 300;
    assertEqual(neg3(&arr[10]), arr[7]);
    assertEqual(neg60(&arr[100]), arr[40]);
    assertEqual(pos63(&arr[1]), arr[64]);
    assertEqual(pos64(&arr[1]), arr[65]);
    for (i = 0; i < 80; i++) bigrec.w[i] = 1000 + i;
    assertEqual(pos70(&bigrec), 1070);
    assertEqual(far0(&bigrec), 1079 + 1000);
    assertEqual(uw(ua), (unsigned)(30000 + 40000));
    {
        struct node n3, n2, n1;
        struct rec rs[4];
        n3.val = 7; n3.next = 0;   n3.pad = 0; n3.tag = 100;
        n2.val = 5; n2.next = &n3; n2.pad = 0; n2.tag = 200;
        n1.val = 3; n1.next = &n2; n1.pad = 0; n1.tag = 300;
        assertEqual(sumlist(&n1), 3 + 5 + 7 + 300 + 200 + 100);
        assertEqual(sumlist(0), 0);
        for (i = 0; i < 4; i++) { rs[i].d = i * 10; rs[i].e = i; }
        assertEqual(sumrecs(rs, 4), (0 + 10 + 20 + 30) - (0 + 1 + 2 + 3));
    }
    for (i = 0; i < 16; i++) tab[i] = i;
    tab[5] = 4096;
    assertEqual(sel(5), 1);
    assertEqual(sel(4), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("word read at pointer plus offset; dead address load");
    suite_add_test(check);
    return suite_run();
}
