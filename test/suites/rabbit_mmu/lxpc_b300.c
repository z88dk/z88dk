#pragma bank 300
extern int bank2000_inner(int x) __banked;
long bank300_calc(long a, int b) __banked
{
    long r = a * b;

    r += bank2000_inner(b);
    return r;
}
