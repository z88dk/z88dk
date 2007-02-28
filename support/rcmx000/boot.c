

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

static int debug_hex=0;
static int debug_dtr=0;
static int debug_flush=0;

static int debug_poll=0;

static int debug_rw=0;

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
static void do_poll(int serfd)
{
  struct pollfd fds[2];

  memset(fds, 0, 2*sizeof(struct pollfd));

  if (debug_poll) fprintf(stderr, "Entering do_poll()\n");

  fds[0].fd=serfd;
  fds[1].fd=0; /* stdin */

  fds[0].events=POLLIN;
  fds[1].events=POLLIN;

  fds[0].revents=0;
  fds[1].revents=0;

  poll(fds, 2, -1);

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
  fprintf(stderr, "Usage: %s <ttydev> <divisor> [-b/-r] <coldloadfile> <binfile>\n", argv0);
  exit(1);
}

static void talk(int tty)
{
  unsigned char ch;

  while(1)
    {
      do_poll(tty); /** Infinite wait for either stdin or data from serial */
      
      if (check_fd(tty))
	{
	  if (debug_rw) fprintf(stderr, "   Before read serial...\n");
	  read(tty, &ch, 1);
	  if (debug_rw) fprintf(stderr, "   After read serial...\n");
	  
	  if (debug_hex) fprintf(stderr, "Got: %.2x (hex))\n", ch);
      
	  /** Print unprintables as stars '*' */
	  if (ch>=' ' && ch<='~')
	    {
	      printf("%c", ch);
	    }
	  else if (ch==13)
	    {
	      printf("\n");
	    }
	  else if (ch==10)
	    {
	      printf("\n");
	    }
	  else
	    {
	      printf("<%.2X>", ch);
	    }
	  fflush(stdout);
	}
      else if (check_fd(0))
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

    }
}


int main(int argc, char *argv[])
{
  /** Assume hex-ascii */
  int is_bin=0;

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

  if (argc!=6)
  {
    usage(argv[0]);
  }
  
  ttyname=argv[1];
  divisor=atoi(argv[2]);
  fname=argv[4];
  
  binfilename=argv[5];

  if (argc==6)
  {
    if (strlen(argv[3])==2)
      {
	if (0==strncmp(argv[3], "-b", 2))
	  {
	    is_bin=1;
	  }
	else if (0==strncmp(argv[3], "-r", 2))
	  {
	    is_raw=1;
	  }
	else
	  {
	    usage(argv[0]);
	  }
      }
    else
      {
	usage(argv[0]);
      }
  }
  
  coldboot=fopen(fname, "rb");
  
  if (coldboot==NULL)
    {
      fprintf(stderr, "Could not open %s\n", fname);
      exit(1);
    }

  binfile=fopen(binfilename, "rb");
  
  if (binfile==NULL)
    {
      fprintf(stderr, "Could not open %s\n", binfilename);
      exit(1);
    }

  tty=open(ttyname, O_RDWR|O_NOCTTY);
  if (tty==-1)
    {
      fprintf(stderr, "Could not open device: %s\n", ttyname);
      exit(1);      
    }

  change_baudrate(tty, 2400);

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


  i=0;

  if (is_raw)
    {
      printf("Using the -r (raw) option means that we will download the whole program\n");
      printf("with the ultra slow bootstrap utility @ 2400 baud, this means even\n");
      printf("the smallest hello-world program will take about 13-14 seconds to\n");
      printf("complete, please be patient.\n");
      printf("Also note that stdout will not work until it is set up in user code!!!\n");
    }

  while (!feof(coldboot))
    {
      if (is_bin || is_raw)
	{
	  fread(&ch, 1, 1, coldboot);
	}
      else
	{
	  /** Wait 'till we find non-ws */
	  while (0==fscanf(coldboot, "%2x", &ch))
	    {
	    }
	}

      if (feof(coldboot)) break;

      /** TODO: combine boot.c and mk_boot_code.c into one utility. It is 
       *  stupid to have the .LOD files */
      
      if (i==0x23 && !is_raw)
	{
	  if (ch==42)
	    {
	      ch=divisor-1;
	      fprintf(stderr, "Changing divisor to: %d\n", ch);
	    }
	  else
	    {
	      fprintf(stderr, "Wrong magic pattern in .LOD file, have you changed bootstrap.asm???\n");
	      exit(1);
	    }
	}

      /** Patch code so we jump over BA,BE handshake and baudrate bumping code */
      if (i==0x3e && is_raw)
	{
	  /** Are we the dummy mnemonic ld hl,NN ???  */
	  if (ch==0x21)
	    {
	      ch=0xc3;  /** jp NN mnemonic, address is same */
	      fprintf(stderr, "Changing to jp at address 0x03h\n");
	    }
	  else
	    {
	      fprintf(stderr, "Wrong magic pattern in .LOD file, have you changed bootstrap.asm???\n");
	      exit(1);
	    }
	}

      write(tty, &ch, 1);

      if (debug_hex) fprintf(stderr, "wrote: %.2x \n", ch);
      
      i++;
    }

  if (is_raw) 
    {
      fprintf(stderr, "Waiting indefinately for reply...\n");
      talk(tty);
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
  talk(tty);
}
