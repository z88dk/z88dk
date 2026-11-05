/* Debug-info regression (-debug): a breakpoint on a line that opens a function
 * stops in the function.
 *
 * The lines of addp and twice, with their { on the signature line, have a
 * file-scope C_LINE of their own besides the function's; the file-scope one
 * sits at the start of the module (crt0_init for the first file).
 * check_brkline.sh breaks on both lines and reads the parameter.
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
