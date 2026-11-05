/* Debug-info regression (80cc, -debug): a line holding code of two blocks has
 * a C_LINE for each block, not only for the first one.
 *
 * Line 17 starts in f's block and ends in the if's; line 20 starts in the
 * inner block and ends back in f's; line 21 holds two sibling blocks; line 22
 * holds a statement and a for. check_clinescope.sh checks the scopes of their
 * C_LINEs, and that a breakpoint on a line goes to the line's first code: on
 * line 17 the if test, which runs although the if's block does not, and on
 * line 20 g += z, before t++.
 */

int g;

int f(int a)
{
    int t = a;
    if (a > 1) { int y = t + 1; g = y; }
    {
        int z = t;
        g += z; } t++;
    { int u = t; g += u; } { int v = t; g += v; }
    t++; for (a = 0; a < 2; a++) g += a;
    return t;
}

int main(void)
{
    g = f(1);
    return 0;
}
