/* Same file name as ../dup1/dup.c, another directory: both modules write
 * N:Fdup.c$e (check_dupname.sh) */
enum e { C = 1, D };
int f1(void);
enum e g2 = D;

int main(void)
{
    volatile int x = g2;
    return x + f1();
}
