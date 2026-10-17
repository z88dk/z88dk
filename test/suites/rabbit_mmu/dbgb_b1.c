#pragma bank 1
extern int bank2_inner(int b) __banked;
int bank1_outer(int a) __banked
{
    int o = a * 2;
    o += bank2_inner(o);
    return o;
}
