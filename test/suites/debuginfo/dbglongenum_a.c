/* Debug-info regression, with dbglongenum_b.c: two modules compiled by a long
 * absolute path, each with an enumerator XV of its own value. `print XV`
 * resolves to the enum of the file being debugged, whatever the path length.
 * check_longenum.sh breaks in each file.
 */

enum ea { XV = 1, YA };
enum ea va = YA;

int fb(void);

int main(void)
{
    int r = fb();
    r = r + va;                     /* BREAK a: print XV = 1 */
    return r;
}
