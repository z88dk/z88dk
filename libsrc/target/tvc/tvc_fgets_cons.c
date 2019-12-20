/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2019
 *
 *  TVC gets, with built-in TVC editor, flashing cursor, whistles
 *  and bells.
 *  Upon closing the string with ENTER the last character in the
 *  string will be a 0x0D character - in sync with the fgets implementations.
 *
 */

#include <tvc.h>

char *tvc_fgets_cons(char* str, size_t max) {
    int pos=0;
    char c;
    tvc_ed_cfix();
    str[pos] = 0;
    do {
        c = tvc_ed_getch();
        if(c == TVC_CHAR_ESC) {
            str[0] = 0x00;
            break;
        }
        str[pos] = c;
        str[++pos] = 0x00;
    } while ((c!=TVC_CHAR_RETURN) && (pos<max-1));
    return str;
}
