


#include "Z80/Z80.h"
#include "mysock.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include "cmds.h"


/*
int DAsm(char *S,word A)
{
  fprintf(stderr, "Disassembly is not working at present\n");
  exit(1);
}
*/


static Z80 z80;
static int quitting;
static int doasm=-1;
static int dodbg=-1;

static int sock_debug=0;

/** If this is set to non-null we dream up a listener port and put
 *  it in the file with this name
 */
static char* portfile=NULL;

static int dbg_sock=0;

byte RAM[65536];

static FILE* logf=NULL;

static void cleanup_pidfile()
{
  char username[1024];
  char dirname[1024];
  char syscmdbuff[1024];

  sprintf(username, getenv("USER"));
  if (strlen(username) == 0)
    {
      fprintf(stderr, "Couldn't get users name (getenv)\n");
      exit(1);
    }

  sprintf(dirname, "/tmp/%s/%d", username, getpid());

  sprintf(syscmdbuff, "rm -rf %s", dirname);
  system(syscmdbuff);
  if (0!=system(syscmdbuff))
    {
      fprintf(stderr, "Command: ``%s`` failed\n");
      exit(1);
    }
}

static void mach_exit(int val)
{
  if (logf!=NULL)
    {
      fclose(logf);
    }

  cleanup_pidfile();

  exit (val);
}

static void dump_regs(char *buff, Z80 *R)
{
  sprintf(buff, "\tAF=%04x BC=%04x DE=%04x HL=%04x IX=%04x IY=%04x\n"
	 "\tAF'%04x BC'%04x DE'%04x HL'%04x PC=%04x SP=%04x\n",
	 R->AF.W,  R->BC.W,  R->DE.W,  R->HL.W,  R->IX.W, R->IY.W,
	 R->AF1.W, R->BC1.W, R->DE1.W, R->HL1.W, R->PC.W, R->SP.W); 
}



void JumpZ80(word PC)
{
    // printf("Jumping to %d\n",(int)PC);
}


word LoopZ80(Z80 *R)
{
    if ( quitting ) {
        return INT_QUIT;
    }
    return INT_NONE;
}



void PatchZ80(Z80 *R)
{
    int   val;

    switch (R->AF.B.h ) {
    case CMD_EXIT:
        mach_exit(R->HL.B.l);
    case CMD_PRINTCHAR:
        if ( R->HL.B.l == '\n' || R->HL.B.l == '\r' ) {
            fputc('\n',stdout);
        } else {
            fputc(R->HL.B.l,stdout);
        }
        fflush(stdout);
        break;
    case CMD_DBG:
      /** 
	  The user is supposed to
	  provide a nl terminated hex string with an even
	  number of chars
      */
      if (dodbg!=-1)
	{
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

	      mysock_write_persist(dbg_sock, bf, strlen(bf));
	    }
	  fflush(stdout);

	  mysock_write_persist(dbg_sock, "\r", 1);
	  
	  /** Here we are at the actual debug prompt where we just wait */
	  
	  for (i=0;;i++)
	    {
	      n_read=mysock_read_data(dbg_sock, &linebf[i], 1, -1);

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
	}
      break;
 case CMD_READKEY:
        val = getchar();
        R->HL.W = val;
        break;
    default:
        printf("Unknown code %d\n",R->AF.B.h);
        mach_exit(1);
    }
}






static char *load_file(char *filename, int addr_offset)
{
    FILE     *fp;
    
    if ( ( fp = fopen(filename,"rb") ) == NULL ) {
      fprintf(stderr, "Cannot load file %s\n",filename);
        mach_exit(1);
    }
    fread(&RAM[addr_offset], sizeof(RAM[0]), 65536-addr_offset, fp);

    fclose(fp);
}

static void sighandler(int sig)
{
    quitting = 1;
}

void dumpmem4(int conn, int pc, int len)
{
  char tmp[1024];
  int i;
  sprintf(tmp, "%.4X ", pc);
  mysock_write_persist(conn, tmp, strlen(tmp));
  
  for (i=0;i<len;i++)
    {
      sprintf(tmp, "%.2X ", RAM[pc+i]);
      mysock_write_persist(conn, tmp, strlen(tmp));
    }
  
  for (i=len;i<=4;i++)
    {
      sprintf(tmp, "   ");
      mysock_write_persist(conn, tmp, strlen(tmp));
    }
}

/** It is up to caller to make this unique in global wide system,
  also caller has to assert that the path exists 
*/
static void write_pid_and_port_literal(int portno, char *filename)
{
  FILE *pfile;

  pfile = fopen(filename, "w");
  
  fprintf(pfile, "%d\n",portno);
  fclose(pfile);
}


static void listen_dbg()
{
  int accp;

  if (dodbg==-1)
    {
      fprintf(stderr, "main.c, listen_dbg: -1 is not a port number\n");
      exit(1);
    }

  if (dodbg)
    {
      accp=mysock_create_listener(dodbg);
    }
  else
    {
      accp=mysock_create_listener_random(&dodbg);
    }

  /** Make a note to user about this port */
  if (portfile != NULL)
    {
      
      /** This is from command line arg */
      write_pid_and_port_literal(dodbg, portfile);	
    }
  
  dbg_sock=mysock_get_incoming_connection(accp);

  if (dbg_sock < 0)
    {
      mach_exit(1);
    }

  if (sock_debug) printf("Now it is time to connect your debug client to the port: %d on this host!\n", dodbg);

  if (sock_debug) printf("Connection accepted\n");
}



/** This will mix the name with something hopefully uniq */
static void write_pid_and_port(int portno, char *portname)
{

  char dirname[1024];
  char filename[1024];
  char syscmdbuff[1024];
  char username[1024];
  
  int i;

  static int firsttime=1;
  /** If this pid was here before, just swoop it */
  if (firsttime)
    {
      cleanup_pidfile();
      firsttime=0;
    }

  sprintf(username, getenv("USER"));
  if (strlen(username) == 0)
    {
      fprintf(stderr, "Couldn't get users name (getenv)\n");
      mach_exit(1);
    }

  sprintf(dirname, "/tmp/%s/%d", username, getpid());


  sprintf(syscmdbuff, "mkdir -p %s", dirname);
  system(syscmdbuff);
  if (0!=system(syscmdbuff))
    {
      fprintf(stderr, "Command: ``%s`` failed\n");
      mach_exit(1);
    }

  sprintf(filename, "%s/%s", dirname, portname);

  /** The pid is in the dir name and the ports are in the directory by their name */

  write_pid_and_port_literal(portno, filename);

}

int main(int argc, char *argv[])
{
    int   ch;
    int   alarmtime = 30;
    char *progname = argv[0];
    
    /** default: forever */
    int num_instr=0;

    int do_dump_reg_flag=0;

    /** default... */
    const char *regs_default="0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000";

    char regs[1024];

    char *portnames[2][1024];
    
    /** Debug port and asm dbg port (both optional) */
    int ports[2];

    memcpy(regs, regs_default, strlen(regs_default)+1);


    while ( ( ch = getopt(argc, argv, "d:w:r:n:l:a:m:")) != -1 ) {
      switch ( ch ) 
	{
	case 'd':
	  {
	    dodbg=atoi(optarg);
	    break;
	  }

	  /** m option will find a socket of its own and put it in a 
	   *  file with the name of the argument
	   *  i.e. /tmp/my_port_no_file_which_will_be_unique_in_all_cases
	   */
	case 'm':
	  {
	    portfile=optarg;

	    dodbg=0;
	    break;
	  }

	case 'w':
	  alarmtime = atoi(optarg);
	  break;
	  
	case 'a':
	  {
	    /** If non-zero this will wait for a socket connect on dbg port */
	    doasm=atoi(optarg);
	    break;
	  }

	case 'l':
	  {
	    char fname[1024];
	    memcpy(fname, optarg, strlen(optarg)+1);
	    logf=fopen(fname, "w");
	  }

	case 'r':
	  {
	    /** 
		Initial values for registers in the following form (example):
		
		"0000 0000 0000 ffc0 0000 0000 0000 0000 0000 0000 00be ffff"
		
		corresponds to registers:
		
		-AF   BC   DE   HL   IX   IY   AF'  BC'  DE'  HL'  PC   SP  -
		
	    */

	    /** Only dump register if we get regs in this option */
	    do_dump_reg_flag=1;
	    
	    memcpy(regs, optarg, strlen(optarg)+1);
	    break;
	  }
	  
	case 'n':
	  {
	    /** Execute n instructions, then terminate with register status */
	    num_instr=atoi(optarg);
	  }
	  break;
	}
    }
    
    argc -= optind;
    argv += optind;

    if ( argc < 1 ) {
        printf("Usage: %s [program to run]\n", progname);
	printf("   w - alarmtime, abort test after signal\n");
	printf("   r - regs initial value\n");
	printf("   n - Execute a certain number of instructions then terminate, dumping register\n");
        mach_exit(1);
    }

    /* Clear memory */
    memset(RAM,0,sizeof(RAM));

    signal(SIGALRM, sighandler);

    if ( alarmtime != -1 ) {
        alarm(alarmtime);  /* Abort a test run if it's been too long */
    }

    /* Reset the machine */
    ResetZ80(&z80);

    /** init regs, this is only necessary if we use the r option */
    sscanf(regs, "%x %x %x %x %x %x %x %x %x %x %x %x",
	   &z80.AF.W,  &z80.BC.W,  &z80.DE.W, &z80.HL.W, 
	   &z80.IX.W, &z80.IY.W, &z80.AF1.W, &z80.BC1.W,
	   &z80.DE1.W, &z80.HL1.W, &z80.PC.W, &z80.SP.W);

    load_file(argv[0], z80.PC.W);

    /** For debugging etc */
    write_pid_and_port(doasm, "asm");

    if (dodbg!=-1)
      {
	listen_dbg();
	/** For debugging etc */
	write_pid_and_port(dodbg, "debug");
      }

    if (doasm!=-1)
      {
	/*run_asm(&z80);*/
      }
    else
      {
	if (num_instr==0)
	  {
	    RunZ80(&z80);
	  }
	else
	  {
	    InstrZ80(&z80, num_instr);
	  }
      }

    if (do_dump_reg_flag)
      {
	char buf[1024];
	dump_regs(buf, &z80);
	
	printf(buf);
      }
    
    mach_exit(0);
}
