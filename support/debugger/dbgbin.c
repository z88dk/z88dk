#include "mysock.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

static int dodbg=-1;

static int sock_debug=0;

/** If this is set to non-null we dream up a listener port and put
 *  it in the file with this name
 */
static char* portfile=NULL;

static int dbg_sock=0;


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

static void sighandler(int sig)
{
  void debug_target_quit_next();
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

  debug_target_set_socket(dbg_sock);

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

    signal(SIGALRM, sighandler);

    if ( alarmtime != -1 ) {
        alarm(alarmtime);  /* Abort a test run if it's been too long */
    }

    /* Reset the target */
    debug_target_reset();

    /** init regs, this is only necessary if we use the r option */
    debug_target_init_regs(regs);

    debug_target_load_file(argv[0]);

    if (dodbg!=-1)
      {
	listen_dbg();
	/** For debugging etc */
	write_pid_and_port(dodbg, "debug");
      }

    if (num_instr==0)
      {
	debug_target_run();
      }
    else
      {
	debug_target_instr(num_instr);
      }

    if (do_dump_reg_flag)
      {
	char buf[1024];
	debug_target_dump_regs(buf, 1024);
	
	printf(buf);
      }
    
    mach_exit(0);
}
