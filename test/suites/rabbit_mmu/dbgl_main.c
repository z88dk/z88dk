extern int bank1_inc(int x) __banked;
int result;

int main(void)
{
    result = bank1_inc(41);
    return 0;
}
