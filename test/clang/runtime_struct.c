/* runtime_struct.c -- struct-by-value argument and return across functions.
 *
 * GREEN: a small struct passed BY VALUE into a function and RETURNED by value
 *        round-trips correctly.  Exercises the aggregate-passing ABI (sret /
 *        register-or-stack struct lowering).  Portable: passes under both the
 *        classic clib and newlib.
 */
#include <stdio.h>

typedef struct { int x, y; } P;

static int sum_by_value(P p)      { return p.x + p.y; }
static P   make(int a, int b)     { P p; p.x = a; p.y = b; return p; }
static P   swap(P p)              { P q; q.x = p.y; q.y = p.x; return q; }

int main(void) {
    P p = make(3, 4);
    P s = swap(p);
    printf("sum=%d x=%d y=%d sx=%d sy=%d\n", sum_by_value(p), p.x, p.y, s.x, s.y);
    return 0;
}
