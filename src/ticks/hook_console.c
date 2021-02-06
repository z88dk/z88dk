
#include "ticks.h"

#include <stdio.h>
#ifndef WIN32
#include <termios.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>                         // For declarations of isatty()
#else
#include <conio.h>
#include <io.h>
#endif
#include <stdlib.h>


#ifndef WIN32
int kbhit(void)
{
    struct termios original;
    struct termios term;
    int    oldf,ch;

    tcgetattr(0, &original);
    memcpy(&term, &original, sizeof(term));

    term.c_lflag &= ~(ICANON|ECHO);
    tcsetattr(0, TCSANOW, &term);

    oldf = fcntl(0, F_GETFL, 0);
    fcntl(0, F_SETFL, oldf | O_NONBLOCK);

    ch = getchar();

//    tcsetattr(0, TCSANOW, &original);
    fcntl(0, F_SETFL, oldf);
 
    if (ch != EOF) {
        ungetc(ch, stdin);
        return 1;
    }
    return -1;
}


int getch()
{
    int val;
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

    val = getchar();

//    tcsetattr(0, TCSANOW, &old_kbd_mode);
    return val;
}




#endif


int hook_console_out(int port, int value)
{
    if (ioport !=-1 && (port&0xff) == ioport) {
        fputc(c,stdout);
        return 0;
    }

    return -1;
}

int hook_console_in(int port)
{
    if (ioport !=-1 && (port&0xff) == ioport) {
        return getch();
    }
    return -1;   
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
    int val;
    if (isatty(fileno(stdin)))
        val = getch();          // read one character at a time if connected to a tty
    else
        val = getchar();        // read in cooked mode if redirected from a file

    if ( val != -1 ) {
        l = val % 256;
        h = val / 256;
        SET_ERROR(Z88DK_ENONE);
    } else {
        SET_ERROR(Z88DK_EINVAL);
        l = h = 255;
    }
}

static void cmd_pollkey(void)
{
    int   val = kbhit();

    if ( val ) {
        val = getch();
        l = val % 256;
        h = val / 256;
    } else {
        l = h = 255;
    }

    SET_ERROR(Z88DK_ENONE);
}

void hook_console_init(hook_command *cmds)
{
    cmds[CMD_PRINTCHAR] = cmd_printchar;
    cmds[CMD_READKEY] = cmd_readkey;
    cmds[CMD_POLLKEY] = cmd_pollkey;
}
