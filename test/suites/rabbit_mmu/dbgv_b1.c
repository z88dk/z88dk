static int s_bank1 = 5;
int g_bank1 = 6;
#pragma bank 1
const int c_bank1 = 7;
int bank1_inc(int x) __banked
{
    static int calls;
    int y = x + 1;
    calls++;
    return y + s_bank1 + g_bank1 + c_bank1;
}
