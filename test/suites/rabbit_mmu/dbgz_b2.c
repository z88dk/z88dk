#pragma bank 32
int bank2_inner(int b) __banked
{
    int i = b + 1;
    return i * 3;
}
