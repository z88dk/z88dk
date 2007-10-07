


#include "Z80/z80.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cmds.h"


static Z80 z80;
static int quitting;

byte RAM[65536];

#if 0
byte DebugZ80(register Z80 *R)
{
	printf("\tAF=%04x BC=%04x DE=%04x HL=%04x IX=%04x IY=%04x\n"
           "\tAF'%04x BC'%04x DE'%04x HL'%04x PC=%04x SP=%04x\n",
           R->AF.W,  R->BC.W,  R->DE.W,  R->HL.W,  R->IX.W, R->IY.W,
		   R->AF1.W, R->BC1.W, R->DE1.W, R->HL1.W, R->PC.W, R->SP.W); 

}
#endif

word LoopZ80(Z80 *R)
{
    if ( quitting ) {
        return INT_QUIT;
    }
    return INT_NONE;
}


void PatchZ80(Z80 *R)
{
    switch (R->AF.B.h ) {
    case CMD_EXIT:
        exit(R->HL.B.l);
    case CMD_PRINTCHAR:
        if ( R->HL.B.l == '\n' || R->HL.B.l == '\r' ) {
            fputc('\n',stdout);
        } else {
            fputc(R->HL.B.l,stdout);
        }
        fflush(stdout);
        break;
    default:
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


    if ( argc < 2 ) {
        printf("Usage: %s [program to run]\n");
        exit(1);
    }


    /* Clear memory */
    memset(RAM,0,sizeof(RAM));

    signal(SIGALRM, sighandler);

    alarm(5);  /* 30 seconds should be enough... */

    /* Reset the machine */
    ResetZ80(&z80);
    load_file(argv[1]);

    RunZ80(&z80);



    return 1;
}
