#pragma bank 1
static const int step = 3;
struct pair { int a; int b; };
static int twice(int x) { return x * 2; }
int bank1_calc(int x) __banked
{
    struct pair p;

    p.a = twice(x);
    p.b = step;
    return p.a + p.b;
}
