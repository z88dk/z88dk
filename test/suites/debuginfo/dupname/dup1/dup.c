/* Same file name as ../dup2/dup.c, another directory: both modules write
 * N:Fdup.c$e (check_dupname.sh) */
enum e { A = 1, B };
enum e g1 = B;

int f1(void)
{
    return g1;
}
