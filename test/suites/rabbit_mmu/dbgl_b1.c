#pragma bank 1
int bank1_inc(int x) __banked
{
    int y = x + 1;
    return y;
}
