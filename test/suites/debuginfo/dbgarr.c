/* Debug-info regression (80cc, -debug): arrays sized by their initialiser.
 *
 * `char gs[] = "glob"` has no size when its symbol is created and gets it
 * from initials(). Its cdb record has to carry the final size ({5}), not the
 * unsized {-1}, for the file statics, the static local and the globals alike
 * (the record of a global used to be written twice, the first with {-1}).
 *
 * check-arrays.sh reads the arrays back through the debugger and scans the
 * map for any unsized record.
 */

char gs[] = "glob";
static char fs[] = "file";
static char ca[] = "abc", cb[] = "de";

int main(void)
{
    static char ss[] = "stat";

    return gs[0] + fs[0] + ss[0] + ca[0] + cb[0];
}
