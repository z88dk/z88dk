



#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include "machine.h"


#include "cmds.h"


static hook_command  hooks[256];

static Z80 z80;
static int quitting;

byte RAM[65536];


word LoopZ80(Z80 *R)
{
    if ( quitting ) {
        return INT_QUIT;
    }
    return INT_NONE;
}


void cmd_exit(Z80 *R)
{
    exit(R->HL.B.l);
}



void PatchZ80(Z80 *R)
{
    int   val;


    if ( hooks[R->AF.B.h] != NULL ) {
        hooks[R->AF.B.h](R);
    } else {
        printf("Unknown code %d\n",R->AF.B.h);
        exit(1);
    }
}


/* Patching instruction:
 *
 * a = code
 */
void JumpZ80(word PC)
{
    // printf("Jumping to %d\n",(int)PC);
}


static char *load_file(char *filename)
{
    FILE     *fp;
    
    if ( ( fp = fopen(filename,"rb") ) == NULL ) {
        printf("Cannot load file %s\n",filename);
        exit(1);
    }
    fread(&RAM[0], sizeof(RAM[0]), 65536, fp);

    fclose(fp);
}


static void sighandler(int sig)
{
    quitting = 1;
}

int main(int argc, char *argv[])
{
    int   ch;
    int   i;
    int   alarmtime = 30;
    word  breakaddr = 65535;
    char *progname = argv[0];

    while ( ( ch = getopt(argc, argv, "w:b:")) != -1 ) {
        switch ( ch ) {
        case 'w':
            alarmtime = atoi(optarg);
            break;
        case 'b':
            breakaddr = atoi(optarg);
            break;
        }
    }

    argc -= optind;
    argv += optind;

    if ( argc < 1 ) {
        printf("Usage: %s [program to run]\n", progname);
        printf("Options: -w timeout - timeout time\n");
        printf("         -b break address - disables timeout\n");
        exit(1);
    }


    /* Clear memory */
    memset(RAM,0,sizeof(RAM));
    for ( i = 0; i < sizeof(hooks) / sizeof(hooks[0]); i++ ) {
        hooks[i] = NULL;
    }

    hooks[CMD_EXIT] = cmd_exit;
    hook_io_init(hooks);
    hook_console_init(hooks);

    if ( breakaddr != 65535 ) {
        signal(SIGALRM, sighandler);
    }
    z80.Trap = breakaddr;

    if ( alarmtime != -1 ) {
        alarm(alarmtime);  /* Abort a test run if it's been too long */
    }

    /* Reset the machine */
    ResetZ80(&z80);
    load_file(argv[0]);

    RunZ80(&z80);



    return 1;
}
