
#include "ticks.h"

#include <stdio.h>
#ifndef WIN32
#include <termios.h>
#endif
#include <stdlib.h>

void console_raw_printchar(int c)
{
    fputc(c,stdout);
}

int console_raw_read()
{
    int val;
#ifndef WIN32
    struct termios old_kbd_mode;    /* orig keyboard settings   */
    struct termios new_kbd_mode;

    if (tcgetattr (0, &old_kbd_mode)) {
    }  
    memcpy (&new_kbd_mode, &old_kbd_mode, sizeof(struct termios));
    new_kbd_mode.c_lflag &= ~(ICANON | ECHO);  /* new kbd flags */
    new_kbd_mode.c_cc[VTIME] = 0;
    new_kbd_mode.c_cc[VMIN] = 1;
    if (tcsetattr (0, TCSANOW, &new_kbd_mode)) {
    }
#endif

    val = getchar();

#ifndef WIN32
    /* reset original keyboard  */
    if (tcsetattr (0, TCSANOW, &old_kbd_mode)) {
    }
#endif
    return val;
}


static void cmd_printchar(void)
{
    if ( l == '\n' || l == '\r' ) {
        fputc('\n',stdout);
    } else if ( l == 8 || l == 127 ) {
        // VT100 code, understood by all terminals, honest
        printf("%c[1D",27);
    } else {
        fputc(l,stdout);
    }
    SET_ERROR(Z88DK_ENONE);
    fflush(stdout);
}


static void cmd_readkey(void)
{
    int   val = console_raw_read();

    l = val % 256;
    h = val / 256;

    SET_ERROR(Z88DK_ENONE);
}

void hook_console_init(hook_command *cmds)
{
    cmds[CMD_PRINTCHAR] = cmd_printchar;
    cmds[CMD_READKEY] = cmd_readkey;
}
