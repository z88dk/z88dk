/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2019
 *
 *  TVC scanf, with built-in TVC editor, flashing cursor, whistles 
 *  and bells.
 *
 */

#include <tvc.h>

char *tvc_fgets_cons(char* str, size_t max) {
    int pos=0;
    char c;
    asm_tvc_ed_cfix();
    str[pos] = 0;
    do {
        c = asm_tvc_ed_getch();
        if(c == TVC_CHAR_ESC) {
            str[0] = 0x00;
            break;
        } else if (c == TVC_CHAR_RETURN) {
            break;
        }
        str[pos] = c;
        str[++pos] = 0x00;
    } while (pos<max-1);
    return str;
}
