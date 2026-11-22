#pragma bank 2000
int bank2000_inner(int x) __banked
{
    int y = x * 3;
    return y;
}
const int bank2000_val = 4321;
const long bank2000_big = 0x01020304L;
