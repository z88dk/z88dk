#include "enums.h"
enum colour { RED, GREEN = 5, BLUE };
enum shared ga_sh = SH_TWO;
enum { ANA = -3, ANB = 300 } ga_anon = ANA;
enum colour ga_col = BLUE;
static enum colour s_col = GREEN;
enum colour ga_arr[2] = { RED, BLUE };
enum colour *ga_ptr = &ga_arr[1];
int ga_int = 6, ga_ienum = BLUE;   /* an int initialised by an enumerator: no enum tag */
typedef enum colour col_t;
col_t ga_tdef = GREEN;      /* an enum through a typedef */
long ga_long = 6;           /* integers next to the enums: no enum tag */
unsigned ga_uns = 6; enum colour ga_unsized[] = { GREEN, BLUE, RED };   /* sized by its initialiser */
int fb(void), fc(void);

int fa(enum colour param)
{
    static enum colour st = RED, stu[] = { BLUE, GREEN };    /* unsized static local */
    enum colour loc = GREEN;
    int plain = (int)loc + ga_int;
    st = param;
    loc = st;
    plain = plain + (int)loc + (int)st;
    return plain;           /* <-- check_enums.sh BREAK LINE A */
}

int fa2(void)
{
    static enum shared st = SH_ONE;     /* same name as fa()'s, another enum */
    st = SH_TWO;
    return (int)st + ga_int;    /* <-- check_enums.sh BREAK LINE A2 */
}

int main(void)
{
    volatile int x = fa(BLUE) + fa2() + fb() + fc();
    return x;
}
