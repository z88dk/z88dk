/* Debug-info regression: a source with a long absolute path. The Makefile
 * compiles it by that path, so the path is in the scope of every file-static
 * and local record, and <file>.<function>.<local> passes 128 characters.
 * ticks, z88dk-gdb and z88dk-dis used to overflow a 128-byte name while
 * reading the map, and crashed or lost the locals. check_longpath.sh asserts
 * what `info locals` and `print` show.
 */

int g = 7;
static int gs = 9;                  /* a file static */

static int twice(int x)             /* a file-static function */
{
    int y = x + x;
    return y;                       /* BREAK twice: x = 7, y = 14 */
}

int main(void)
{
    int a = 3;
    int b = 4;
    a = a + b;
    g = twice(a) + gs;              /* BREAK main: a = 7, b = 4 */
    return a;
}
