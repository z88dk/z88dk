/* Debug-info regression (-debug): a breakpoint on a line that opens a function
 * stops in the function.
 *
 * The line of addp, the file's first function, with its { on the signature
 * line, has a file-scope C_LINE besides the function's, at the start of the
 * module (crt0_init). The line of twice is in two functions at one address
 * (the end of addp, the start of twice). check_brkline.sh breaks on both.
 */

int g;

static int addp(int v) { return v + 1; }

static int twice(int v) {
    return v * 2;
}

int main(void)
{
    g = twice(addp(41));
    return 0;
}
