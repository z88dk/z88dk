#include "enums.h"
enum colour { CYAN = 1, RED = 10, MAGENTA };
enum shared gb_sh = SH_ONE;
enum { BNA = 7, BNB } gb_anon = BNB;
enum colour gb_col = MAGENTA;
static enum colour s_col = RED;
int gb_int = 12;

int fb(void)
{
    static enum colour st = CYAN;
    st = MAGENTA;
    return (int)st + (int)s_col + gb_int;   /* <-- check_enums.sh BREAK LINE B */
}
