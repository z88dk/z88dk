extern int bank1_outer(int a) __banked;
int main(void)
{
    int m = 100;
    m += bank1_outer(5);
    return m;
}
