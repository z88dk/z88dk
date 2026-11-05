/* Debug-info regression (-debug): a for statement opens a block of its own.
 *
 * The variable a for declares is recorded in the for's block, one level below
 * the enclosing block, and the loop body is a block inside it: p, i, j and k
 * each have a block of their own, and so has the last for, which declares
 * nothing (m is in its body, a block below it). sccz80 and 80cc write the same
 * records (#3254). check_forblk.sh compares them with forblk.records, checks
 * that 80cc's for headers and back jumps carry the for's block, and reads i and
 * j back.
 */

int g;

int f(int a)
{
    int t = a;
    if (a) {
        int p = t;
        t += p;
    }
    for (int i = 1; i < 3; i++) {
        for (int j = 2; j < 4; j++)
            t += i + j;
    }
    for (int k = 0; k < 2; k++)
        t += k;
    for (a = 0; a < 2; a++) {
        int m = a;
        t += m;
    }
    return t;
}

int main(void)
{
    g = f(1);
    return 0;
}
