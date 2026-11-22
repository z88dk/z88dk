/* A CHAIN OF FIELD STORES THROUGH A POINTER THAT CAME BACK FROM A CALL.
 *
 *     r = alloc();  r->a = a;  r->b = b;  r->flag = f;  r->name = copy(c);
 *
 * The first store of a chain loads the value into HL and exchanges HL with DE
 * to bring the base into HL. If the base is DE-resident at that point (a call
 * result, with a parameter kept in BC across the call), the lowerer's DE belief
 * must follow the exchange; otherwise it copies the VALUE over the base and
 * writes through the wrong address.
 */
#include "test.h"

typedef struct item { struct item *next; int tag; } item;
typedef struct rule {
    item *match;
    item *replace;
    unsigned restart:1;
    unsigned barrier:1;
    char *cond;
    void *vars;
    struct rule *next;
} rule;

static rule pool[6];
static int npool, ncalls;
static rule *root, *cur;
static int dummy;

static void *alloc_rule(unsigned n) { (void)n; ncalls++; return &pool[npool++]; }
static char *dup(const char *s)     { ncalls++; return (char *)s; }
static void *mkvars(int n)          { (void)n; ncalls++; return &dummy; }

static rule *new_rule(item *match, item *replace, char *cond, int restart, int barrier)
{
    rule *pr;

    pr = alloc_rule(sizeof(rule));
    pr->match = match;
    pr->replace = replace;
    pr->restart = restart;
    pr->barrier = barrier;

    if (cond && *cond)
        pr->cond = dup(cond);
    else
        pr->cond = 0;

    pr->vars = mkvars(4);

    if (!root)
        root = cur = pr;
    else
        cur = cur->next = pr;
    return pr;
}

/* two-word structure, no bitfields: the plainest chain */
typedef struct pair { int *p; int *q; int n; } pair;
static pair pairs[3];
static int np;
static void *alloc_pair(void) { return &pairs[np++]; }
static pair *new_pair(int *p, int *q, int n)
{
    pair *r = alloc_pair();
    r->p = p;
    r->q = q;
    r->n = n;
    return r;
}

void test_stchain(void)
{
    item i1, i2, i3, i4;
    char buf[4] = { 'x', 0, 0, 0 };
    char empty[1] = { 0 };
    rule *r1, *r2, *r3;
    int a = 1, b = 2;
    pair *p1, *p2;

    r1 = new_rule(&i1, &i2, buf, 1, 0);
    assertEqual(r1 == &pool[0], 1);
    assertEqual(r1->match == &i1, 1);
    assertEqual(r1->replace == &i2, 1);
    assertEqual((int)r1->restart, 1);
    assertEqual((int)r1->barrier, 0);
    assertEqual(r1->cond == buf, 1);
    assertEqual(r1->vars == &dummy, 1);
    assertEqual(root == r1, 1);
    assertEqual(cur == r1, 1);

    r2 = new_rule(&i3, &i4, empty, 0, 1);
    assertEqual(r2 == &pool[1], 1);
    assertEqual(r2->match == &i3, 1);
    assertEqual(r2->replace == &i4, 1);
    assertEqual((int)r2->restart, 0);
    assertEqual((int)r2->barrier, 1);
    assertEqual(r2->cond == 0, 1);
    assertEqual(r1->next == r2, 1);
    assertEqual(cur == r2, 1);

    r3 = new_rule(&i2, &i1, 0, 1, 1);
    assertEqual(r3 == &pool[2], 1);
    assertEqual(r3->match == &i2, 1);
    assertEqual(r3->replace == &i1, 1);
    assertEqual((int)r3->restart, 1);
    assertEqual((int)r3->barrier, 1);
    assertEqual(r3->cond == 0, 1);
    assertEqual(r2->next == r3, 1);
    assertEqual(ncalls, 3 + 1 + 3);        /* 3 allocs, 1 dup, 3 mkvars */

    p1 = new_pair(&a, &b, 7);
    p2 = new_pair(&b, &a, 9);
    assertEqual(p1 == &pairs[0], 1);  assertEqual(p2 == &pairs[1], 1);
    assertEqual(p1->p == &a, 1);  assertEqual(p1->q == &b, 1);  assertEqual(p1->n, 7);
    assertEqual(p2->p == &b, 1);  assertEqual(p2->q == &a, 1);  assertEqual(p2->n, 9);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("field-store chain through a pointer returned from a call");
    suite_add_test(test_stchain);
    return suite_run();
}
