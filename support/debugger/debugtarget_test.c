
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Z80/Z80.h"
#include "debugtarget.h"
#include "cmds.h"

byte RAM[65536];

static int quitflag=1;
static Z80 z80;

static int our_dbg_sock;



void debug_target_dump_regs(char *buff, int maxlen)
{
  Z80* R=&z80;
  char tmpbuff[1024];
  sprintf(tmpbuff, "\tAF=%04x BC=%04x DE=%04x HL=%04x IX=%04x IY=%04x\n"
	 "\tAF'%04x BC'%04x DE'%04x HL'%04x PC=%04x SP=%04x\n",
	 R->AF.W,  R->BC.W,  R->DE.W,  R->HL.W,  R->IX.W, R->IY.W,
	 R->AF1.W, R->BC1.W, R->DE1.W, R->HL1.W, R->PC.W, R->SP.W); 
  memcpy(buff, tmpbuff, maxlen);
}	  






void debug_target_init_regs(const char* regstr)
{
  sscanf(regstr, "%x %x %x %x %x %x %x %x %x %x %x %x",
	 &z80.AF.W,  &z80.BC.W,  &z80.DE.W, &z80.HL.W, 
	 &z80.IX.W, &z80.IY.W, &z80.AF1.W, &z80.BC1.W,
	 &z80.DE1.W, &z80.HL1.W, &z80.PC.W, &z80.SP.W);
}


void debug_target_load_file(const char *binfile)
{
    FILE     *fp;

    int addr_offset = z80.PC.W;
    
    if ( ( fp = fopen(binfile,"rb") ) == NULL ) {
      fprintf(stderr, "Cannot load file %s\n",binfile);
        exit(1);
    }
    fread(&RAM[addr_offset], sizeof(RAM[0]), 65536-addr_offset, fp);

    fclose(fp);
}


void debug_target_reset()
{
  ResetZ80(&z80);

  /* Clear memory */
  memset(RAM,0,sizeof(RAM));

  z80.Trap=-1;
}


void debug_target_run()
{
  RunZ80(&z80);
}

void debug_target_instr(int num_instr)
{
  InstrZ80(&z80, num_instr);
}

void debug_target_set_socket(int dbg_sock)
{
  our_dbg_sock=dbg_sock;
}



/** These below are linked in with the test/machine target */

void JumpZ80(word PC)
{
    // printf("Jumping to %d\n",(int)PC);
}


void debug_target_quit_next()
{
  quitflag=0;
}

word LoopZ80(Z80 *R)
{
    if ( quitflag ) {
        return INT_QUIT;
    }
    return INT_NONE;
}

void PatchZ80(Z80 *R)
{
    int   val;

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
    case CMD_DBG:
      {
	/** 
	    The user is supposed to
	    provide a nl terminated hex string with an even
	    number of chars
	*/
	/** We limit this protocol to 255 bytes */
	char bf[1024];
	
	char linebf[512];
	char tmp[3]; /** trick to make sscanf %x do what we want */
	int i,hexval;
	int strlen_linebf, n_read;
	
	/** the buffer is pointed to by HL, E is len */
	
	for (i=0;i<R->DE.B.l;i++)
	  {
	    /** Mysterios instant "DMA" read of our "hardware" memory ;-) */
	    sprintf(bf, "%.2X", RAM[R->HL.W+i]);
	    
	    mysock_write_persist(our_dbg_sock, bf, strlen(bf));
	  }
	fflush(stdout);
	
	mysock_write_persist(our_dbg_sock, "\r", 1);
	
	/** Here we are at the actual debug prompt where we just wait */
	
	for (i=0;;i++)
	  {
	    n_read=mysock_read_data(our_dbg_sock, &linebf[i], 1, -1);
	    
	    if (n_read!=1)
	      {
		fprintf(stderr, "main.c: PatchZ80, unexpected read of != 1 byte =%d\n", n_read);
		exit(1);
	      }
	    
	    if (linebf[i]==10)
	      {
		break;
	      }
	  }
	
	linebf[i]='\0';
	strlen_linebf=i;
	
	for (i=0;i<strlen_linebf/2;i++)
	  {
	    tmp[0]=linebf[i*2];
	    tmp[1]=linebf[i*2+1];
	    sscanf(tmp,"%x",&hexval);
	    
	    /** Yet another time mysterious modifications are done
	     *  with memory and registers
	     */
	    RAM[R->HL.W+i]=hexval;
	  }
	
	/** Return string length in E */
	R->DE.B.l=strlen_linebf/2;
	break;
      }
    case CMD_READKEY:
        val = getchar();
        R->HL.W = val;
        break;
    default:
        printf("Unknown code %d\n",R->AF.B.h);
        exit(1);
    }
}


