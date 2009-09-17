

#include <stdio.h>
#include <stdlib.h>

#include <poll.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <signal.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/ioctl.h>

#include <sys/poll.h>

#include "mysock.h"

#include "bootbytes.h"

static int debug_hex=0;
static int debug_dtr=0;
static int debug_rts=0;
static int debug_flush=0;

static int debug_poll=0;

static int debug_rw=0;


/** In this mode, all chars 10,13,32-255 are sent to console, while the
 *  chars 0-9, 11-12, 14-31 are sent to the tcp/ip connection
 *  so we can get information but not confuse our xmodem client
 *  with debug garbage
 */
static int option_xmodem=0;

static void rts_ctl(int fd, int val)
{
    int flags=0;

    ioctl(fd, TIOCMGET, &flags);
    if (debug_rts) fprintf(stderr, "Flags are %x.\n", flags);

    if (val)
    {
	flags |= TIOCM_RTS;
    }
    else
    {
	flags &= ~TIOCM_RTS;
    }

    ioctl(fd, TIOCMSET, &flags);
    if (debug_rts) fprintf(stderr, "Setting %x.\n", flags);

    ioctl(fd, TIOCMGET, &flags);
    if (debug_rts) fprintf(stderr, "Flags are %x.\n", flags);

    return;
}


static void dtr_ctl(int fd, int dtrval)
{
    int dtrflags=0;

    ioctl(fd, TIOCMGET, &dtrflags);
    if (debug_dtr) fprintf(stderr, "dtrFlags are %x.\n", dtrflags);

    if (dtrval)
    {
	dtrflags |= TIOCM_DTR;
    }
    else
    {
	dtrflags &= ~TIOCM_DTR;
    }

    ioctl(fd, TIOCMSET, &dtrflags);
    if (debug_dtr) fprintf(stderr, "Setting %x.\n", dtrflags);

    ioctl(fd, TIOCMGET, &dtrflags);
    if (debug_dtr) fprintf(stderr, "dtrFlags are %x.\n", dtrflags);

    return;
}

static void change_baudrate(int fd, int baudr)
{
  struct termios ios;

  memset(&ios, 0, sizeof(ios));

  tcgetattr(fd, &ios);

  if (debug_flush) fprintf(stderr, "IBaud=%d\n", cfgetispeed(&ios));
  if (debug_flush) fprintf(stderr, "OBaud=%d\n", cfgetospeed(&ios));

  switch(baudr)
    {
    case 2400:
      {
	cfsetospeed(&ios, B2400);
	break;
      }
    case 57600:
      {
	cfsetospeed(&ios, B57600);
	break;
      }
    default:
      {
	fprintf(stderr, "Illegal baudrate: %d\n", baudr);
	exit(1);
      }
    }
  
  tcsetattr(fd, TCSADRAIN, &ios);

}

static void msleep(int msec)
{
  poll(NULL, 0, msec);
}


/** Will wait indefinately for either stdin or serial data */
static void do_poll(int serfd, int sockaccp_fd, int socktraf_fd)
{
  struct pollfd fds[4];

  memset(fds, 0, 2*sizeof(struct pollfd));

  if (debug_poll) fprintf(stderr, "Entering do_poll()\n");

  fds[0].fd=serfd;
  fds[1].fd=0; /* stdin */
  fds[2].fd=sockaccp_fd;
  fds[3].fd=socktraf_fd;

  fds[0].events=POLLIN;
  fds[1].events=POLLIN;
  fds[2].events=POLLIN;
  fds[3].events=POLLIN;

  fds[0].revents=0;
  fds[1].revents=0;
  fds[2].revents=0;
  fds[3].revents=0;

  /** If sockaccp_fd is zero we only check serial and stdin */
  /** If sockaccp_fd=1 we also check socktraf_fd if it is non-zero */
  poll(fds, sockaccp_fd==0?2:(socktraf_fd==0?3:4), -1);

  if (debug_poll) fprintf(stderr, "Leaving do_poll()\n");
}

static int check_fd(int anfd)
{
  struct pollfd fds;
  fds.fd=anfd;
  fds.events=POLLIN;
  fds.revents=0;

  poll(&fds, 1, 0);

  if (debug_poll)
    {
      if (fds.revents & POLLIN)
	{
	  if (debug_poll) fprintf(stderr, "fd=%d, we have pollin data\n", anfd);
	}
      else
	{
	  if (debug_poll) fprintf(stderr, "fd=%d, we have NO pollin data\n", anfd);	  
	}
    }
  
  return (fds.revents & POLLIN);
}

/** Code below here should be fairly portable **/

static void usage(const char* argv0)
{
  fprintf(stderr, "Boot mode: (Normal load and execution of program to ram)\n");
  fprintf(stderr, "Usage: %s [-p/-x <num>] -b <ttydev> <divisor> <binfile>\n", argv0);
  fprintf(stderr, "   or\n", argv0);
  fprintf(stderr, "Raw mode: (Only used to get the baudrate division number)\n");
  fprintf(stderr, "Usage: %s [-p/-x <num>] -r <ttydev> <coldload binfile>\n", argv0);
  fprintf(stderr, "   or\n", argv0);

  fprintf(stderr, "Flash mode: (Will store program permanently in flash)\n");
  fprintf(stderr, "Usage: %s -f <ttydev> <divisor> <binfile>\n", argv0);
  fprintf(stderr, "   or\n", argv0);
  
  fprintf(stderr, "Direct mode: (Will copy a preloaded image from the flash to the ram and then run it\n");
  fprintf(stderr, "Usage: %s [-p/-x <num>] -d <ttydev> <divisor> <binfile>\n", argv0);
  fprintf(stderr, "-x is same as -p but characters will get piped to both socket and stdout\n", argv0);


  exit(1);
}



static void sendchar(int tty, int traf_fd, char ch)
{
  /** If traf_fd is set we send to socket */
  if (debug_rw) fprintf(stderr, "traf_fd=%d\n", traf_fd);
  if (traf_fd)
    {
      if (option_xmodem)
	{
	  /** Filter out control chars 0-31 and send them to socket
	   *  i.e. xmodem client, the rest is debug to stdout
	   * Newline (10 & 13) are also sent to stdout!
	   */
	  if (ch==10 || ch==13)
	    {
	      char tmp='\n';
	      fwrite(&tmp, 1, sizeof(char), stdout);
	    }	      
	  else if (ch>31)
	    {
	      fwrite(&ch, 1, sizeof(char), stdout);
	    }
	  else
	    {
	      mysock_write_persist(traf_fd, &ch, 1);
	    }
	}
      else
	{
	  mysock_write_persist(traf_fd, &ch, 1);
	}
      fflush(stdout);
    }
  else
    {
      if (debug_rw) fprintf(stderr, "Before fwrite\n");

      if (ch>=' ' && ch<='~')
	{
	  fwrite(&ch, 1, sizeof(char), stdout);
	}
      else if (ch==13)
	{
	  fwrite("\n", 1, sizeof(char), stdout);
	}
      else if (ch==10)
	{
	  fwrite("\n", 1, sizeof(char), stdout);
	}
      else
	{
	  char spbuf[100];
	  sprintf(spbuf, "<%.2X>", ch);
	  fwrite(spbuf, 4, sizeof(char), stdout);
	}
      
      fflush(stdout);
    }
}


static void talk(int tty, int sockport)
{
  unsigned char ch;
  int accp_fd=0;
  int traf_fd=0;

  if (sockport!=0)
    {
      /** We set up listener on this port */
      accp_fd=mysock_create_listener(sockport);
    }

  while(1)
    {
      do_poll(tty, accp_fd, traf_fd); /** Infinite wait for either stdin, socket or data from serial */
      
      if (check_fd(tty))
	{
	  if (debug_rw) fprintf(stderr, "   Before read serial...\n");
	  read(tty, &ch, 1);
	  if (debug_rw) fprintf(stderr, "   After read serial...\n");
	  
	  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
      

	  sendchar(tty, traf_fd, ch);

	}
      else if (traf_fd==0)
	{
	  /** Only run this code if we have not yet connected socket */

	  if (check_fd(0))
	    {
	      if (debug_rw) fprintf(stderr, "   Before read stdin...\n");
	      
	      read(0, &ch, 1);
	      
	      if (debug_rw) fprintf(stderr, "   After read stdin...\n");
	      
	      if (debug_rw) fprintf(stderr, "   Read stdin=%d\n", ch);
	      
	      write(tty, &ch, 1);
	      
	      if (!check_fd(tty))
		{
		  msleep(100); /** Just sleep to give target a chance to respond */
		}
	    }

	  if (accp_fd>0)
	    {
	      if (check_fd(accp_fd))
		{
		  if (debug_rw) fprintf(stderr,"accp_fd=%d\n", accp_fd);
		  
		  traf_fd=mysock_get_incoming_connection(accp_fd);
		}
	    }
	}
      else
	{
	  /** Here we talk (and respond) via the socket instead */
	  if (check_fd(traf_fd))
	    {
	      int status;

	      if (debug_rw) fprintf(stderr, "   Before read socket...\n");
	      
	      status=read(traf_fd, &ch, 1);
	      
	      /** socket connection closed, wait for new (or stdin) */
	      if (status==0)
		{
		  traf_fd=0;
		}
	      else
		{
		  if (debug_rw) fprintf(stderr, "   After read socket...\n");
		  
		  if (debug_rw) fprintf(stderr, "   Read socket=%d\n", ch);
		  
		  write(tty, &ch, 1);
		}
	    }
	}
    }
}


int main(int argc, char *argv[])
{
  char **argvp=argv;

  char *argv0=argv[0];

  int do_flash=0;

  /** This flag is set if we communicate raw with the target */
  int is_raw=0;

  unsigned char ch;

  int divisor;

  char* ttyname;

  char* fname;

  char* binfilename;

  int tty;

  FILE *coldboot;

  FILE *binfile;

  /** To keep the size of the .bin file */
  long fsize;

  unsigned csum;

  int i;
  
  /** If this is set to non-zero we listen for characters here 
   *  to take over from terminal
   */
  int sockport=0;

  if (argc<4 || argc>7)
    {
      usage(argv0);
    }

  if ( (0==strncmp(argvp[1], "-p", 2)) ||(0==strncmp(argvp[1], "-x", 2)) )
    {

      if (0==strncmp(argvp[1], "-x", 2))
	{
	  printf("Setting for xmodem\n");

	  option_xmodem=1;
	}

      /** We should have a socket listener, all other arguments pushed two steps... */

      /** We demand at least two more arguments (i.e. argc six or greater) */
      if (argc<6)
	{
	  usage(argv0);
	}

      sockport=atoi(argvp[2]);
      argvp += 2;

      argc-=2;



    }
  
  if (0==strncmp(argvp[1], "-b", 2))
    {
      if (argc!=5) usage(argv0);
      
      ttyname=argvp[2];
      divisor=atoi(argvp[3]);
      binfilename=argvp[4];

      binfile=fopen(binfilename, "rb");
      
      if (binfile==NULL)
	{
	  fprintf(stderr, "Could not open %s\n", binfilename);
	  exit(1);
	}
    }
  else if (0==strncmp(argvp[1], "-r", 2))
    {
      if (argc!=4) usage(argv0);

      ttyname=argvp[2];
      fname=argvp[3];

      binfile=NULL;

      is_raw=1;
    }
  else if (0==strncmp(argvp[1], "-d", 2))
    {
      if (argc!=3) usage(argv0);

      ttyname=argvp[2];
      /** Runs directly from flash with no download */
      tty=open(ttyname, O_RDWR|O_NOCTTY);

      dtr_ctl(tty,0);
      rts_ctl(tty,0);

      if (tty==-1)
	{
	  fprintf(stderr, "Could not open device: %s\n", ttyname);
	  exit(1);      
	}

      /** User handles reset directly on target */
      
      change_baudrate(tty, 57600);
      
      talk(tty, sockport);
      
      return 0;
    }
  else if (0==strncmp(argvp[1], "-s", 2))
    {
      /** Silent (hidden) option, this requires a special modified cable to be useful 
          It lets you manipulate smode0/1  with RTS of serial line, thus starting
	  from flash remotedly via cable.
	  
	  Mainly useful when debugging the -d option...
      */

      if (argc!=3) usage(argv0);

      ttyname=argvp[2];
      tty=open(ttyname, O_RDWR|O_NOCTTY);
      if (tty==-1)
	{
	  fprintf(stderr, "Could not open device: %s\n", ttyname);
	  exit(1);      
	}

      printf("Pulling rts(smode) = 0\n");
      rts_ctl(tty, 0);
      
      sleep(1);
      printf("Asserting dtr(reset)=0\n");
      dtr_ctl(tty, 0);
      
      sleep(1);
      printf("Pulling dtr(reset)=1\n");
      dtr_ctl(tty, 1);
      
      sleep(1);
      printf("Pulling dtr(reset)=0\n");
      dtr_ctl(tty, 0);

      change_baudrate(tty, 57600);

      /** Vaccum out any characters accumulated during reset */
      {
	char ch;
	while (check_fd(tty)) read(tty, &ch, 1);
      }

      talk(tty, sockport);
      
      return 0;
    }
  else if (0==strncmp(argvp[1], "-f", 2))
    {
      if (argc!=5) usage(argv0);

      ttyname=argvp[2];
      divisor=atoi(argvp[3]);
      binfilename=argvp[4];

      binfile=fopen(binfilename, "rb");

      do_flash=1;
      
      if (binfile==NULL)
	{
	  fprintf(stderr, "Could not open %s\n", binfilename);
	  exit(1);
	}
    }
  else
    {
      usage(argv0);
    }
  
  if (is_raw)
    {
      coldboot=fopen(fname, "rb");  
      if (coldboot==NULL)
	{
	  fprintf(stderr, "Could not open %s\n", fname);
	  exit(1);
	}
    }

  tty=open(ttyname, O_RDWR|O_NOCTTY);
  if (tty==-1)
    {
      fprintf(stderr, "Could not open device: %s\n", ttyname);
      exit(1);      
    }

  change_baudrate(tty, 2400);

  /** Set smode0,1 to high in this normal case */
  rts_ctl(tty, 0);

  /** Reset active **/
  dtr_ctl(tty, 1);

  /** Reset turned off */
  dtr_ctl(tty, 0);

  /** Time to stabilize */
  msleep(500);

  /** Flush serial port */
  while (check_fd(tty))
    {
      unsigned char junk;
      read(tty, &junk, 1);
      if (debug_flush) fprintf(stderr, "Flushed %.2x off serial line\n", junk);
    }

  if (is_raw)  /** Take whole file from coldboot file @ 2400 */
    {
      printf("Using the -r (raw) option means that we will download the whole program\n");
      printf("with the ultra slow bootstrap utility @ 2400 baud, this means even\n");
      printf("the smallest hello-world program will take about 13-14 seconds to\n");
      printf("complete, please be patient.\n");
      printf("Also note that stdout will not work until it is set up in user code!!!\n");

      i=0;
      while (!feof(coldboot))
	{
	  fread(&ch, 1, 1, coldboot);
	  if (feof(coldboot)) break;

	  /** Make the rawmode target code bypass the handshake BA BE etc. */
	  if (i==0x3e)
	    {
	      /** Are we the dummy mnemonic ld hl,NN ???  */
	      if (ch==0x21)
		{
		  ch=0xc3;  /** jp NN mnemonic, address is same */
		  fprintf(stderr, "Changing to jp at address 0x03h\n");
		}
	      else
		{
		  fprintf(stderr, "Wrong magic pattern in .LOD file, have you changed rcmx000_boot.asm???\n");
		  exit(1);
		}
	    }
	  
	  write(tty, &ch, 1);
	  
	  if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);
	  
	  i++;
	}
      
    }
  else  /** We take the cold boot section from this binaries own data... */
    {
      for (i=0;i<s_num_bytes;i++)
	{
	  ch=s_lodfile[i];


	  /** Patch the divisor in... */
	  if (i==0x23)
	    {
	      if (ch==42)
		{
		  ch=divisor-1;
		  fprintf(stderr, "Changing stored divisor to: %d\n", ch);
		}
	      else
		{
		  fprintf(stderr, "Wrong magic pattern in baud rate coeff, have you changed rcmx000_boot.asm??? addr=%x\n", i);
		  exit(1);
		}
	    }

	  write(tty, &ch, 1);      
	  if (debug_hex) fprintf(stderr, "(raw) wrote: %.2x \n", ch);
	}
      
    }

  if (is_raw) 
    {
      fprintf(stderr, "Waiting indefinately for reply...\n");
      talk(tty, sockport);
      exit(0);
    }

  /** Handshake protocol to bump baudrate */
  
  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
  if (ch!=0xba)
    {
      fprintf(stderr, "Wrong magic pattern\n");
      exit(1);
    }

  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
  if (ch!=0xbe)
    {
      fprintf(stderr, "Wrong magic pattern\n");
      exit(1);
    }

  ch=(divisor/24)-1;
  write(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);
  
  /** Bump the actual baudrate */
  change_baudrate(tty, 57600);


  ch=42;
  write(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);

  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
  if (ch!=42)
    {
      fprintf(stderr, "Wrong value returned from target\n");
      exit(1);
    }

  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
  if (ch!=(divisor/24)-1)
    {
      fprintf(stderr, "Wrong baudrate divisor in return\n");
      exit(1);
    }

  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
  if ( ch != (0xff^(divisor/24)-1) )
    {
      fprintf(stderr, "Wrong baudrate divisor in return\n");
      exit(1);
    }

  csum=0;

  /** Now we transfer the .bin file but first we find out its length */
  {
    fseek(binfile, 0, SEEK_END);
    
    fsize=ftell(binfile);
    
    if (debug_hex) fprintf(stderr, "fsize=%d\n", fsize);
    
    /** Network order, two bytes size (max 64k ;-) */
    ch=fsize&255;
    write(tty, &ch, 1);
    if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);
    
    csum += ch;

    ch=(fsize>>8)&255;
    write(tty, &ch, 1);
    if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);

    csum += ch;
  }

  fseek(binfile, 0, SEEK_SET);

  for (i=0;i<fsize;i++)
    {
      fread(&ch, 1, 1, binfile);

      if (do_flash)
	{

	  /** If we store this image we need to note the baudrate
	      and since baud register is write-only it must be in ram 
	      The reason we patch here is that we dont know this
	      value until boot is run with its baud rate divisor
	      argument.
	  */
	  if (i==0xae)
	    {
	      if (ch==42)
		{
		  fprintf(stderr, "Patching the correct baudrate into the image file for later use\n");
		  ch=divisor/24-1;
		}
	      else
		{
		  fprintf(stderr, "**Wrong magic number, did you change rcmx000_boot.asm???");
		  exit(1);
		}
	    }

	  /** Patch in flashing command if do_flash is set */
	  if (i==0x8 && do_flash) 
	    {
	      printf ("ch=%d\n", ch);
	      
	      printf("Doing flashing of target...\n");
	      ch=1;
	    }
	}
      csum += ch;
      
      if (feof(binfile))
	{
	  fprintf(stderr, "Unexpected EOF in .bin file\n");
	  exit(1);
	}
      
      write(tty, &ch, 1);
      if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);
    }

  if (debug_hex) fprintf(stderr, "Checksum lo: %.2x (hex))\n", csum&255);
  if (debug_hex) fprintf(stderr, "Checksum hi: %.2x (hex))\n", (csum>>8)&255);
  /** Read the checksum */

  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got Checksum lo: %.2x (hex))\n", ch);
  if (ch!=(csum&255))
    {
      fprintf(stderr, "Wrong checksum\n");
      exit(1);
    }

  read(tty, &ch, 1);
  if (debug_hex) fprintf(stderr, "Got Checksum hi: %.2x (hex))\n", ch);
  if (ch!=((csum/256)&255))
    {
      fprintf(stderr, "Wrong checksum\n");
      exit(1);
    }
  
  /** Start conversation with stdin/stdout of target */
  talk(tty, sockport);
}
