extern int bank1_inc(int x) __banked;
extern __banked const int bank3_val;
extern __banked const char bank3_name[];
int g_root = 111;
static int s_root = 222;
int main(void)
{
    static int s_main = 333;
    int r = bank1_inc(41);
    return r + g_root + s_root + s_main + bank3_val + bank3_name[0];
}
