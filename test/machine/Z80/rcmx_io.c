
#include "rcmx_io.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>

/** Set in rcmx_io_init */
static int rcmx_io_debug;

extern byte RAM[65536];

static int select_stdin_and_sleep(int usleep)
{
  int retval;
  fd_set stdin_fd;

  struct timeval tv;

  tv.tv_sec=0;
  tv.tv_usec=usleep;

  FD_ZERO(&stdin_fd);
  
  FD_SET(0, &stdin_fd);

  retval = select(1, &stdin_fd, NULL, NULL, &tv);

  if (rcmx_io_debug) fprintf(stderr, "select returned: %d\n", retval);

  return retval;
}



void rcmx_io_init()
{
  /** We bypass all download etc. this is equal to raw mode when
      using support/rcmx000 
  */
  RAM[3]=0xc3;

  rcmx_io_debug=0;
}



byte rcmx_io_internal_in(word A)
{

  if (rcmx_io_debug) fprintf(stderr, "rcmx_io_internal_in:\n");
  if (rcmx_io_debug) fprintf(stderr, "A=%.4X\n", A);

  /** Only the serial A I/O is implemented (= emulated)
   *  right now
   */
  switch (A)
    {
    case 0xc3:
      {
	/** if bit 7 is one, we have a new character to read */
	/** If bit 3 is zero we are allowed to send another character */


	/** We cannot avoid active wait, since we don't know which
	 *  bit the program wants. We make a sleep here so
	 *  that the characters are paced at approx the serial
	 *  rate:
	 *  If baud=57600, we have about 5760 chars per second
	 *  so we sleep for 1/5760 ~=  174 useconds
	 */

	if (select_stdin_and_sleep(174))
	  {
	    return 128; /** Ok to write another char + something to read */
	  }
	else
	  {
	    return 0;   /** Ok to write another char + nothing to read */
	  }

	break;
      }

    case 0xc0:
      {
	return fgetc(stdin);
	break;
      }

    }

  /* All other I/O returns zero */
  return 0;

}

byte rcmx_io_external_in(word A)
{
  /** Just ignore external i/o reads */
}

void rcmx_io_internal_out(word A, byte V)
{
  if (rcmx_io_debug) fprintf(stderr, "rcmx_io_internal_out:\n");
  if (rcmx_io_debug) fprintf(stderr, "A=%.4X V=%.2X\n", A, V);

  /** Only the serial A I/O is implemented (= emulated)
   *  right now
   */
  switch (A)
    {
    case 0xc0:
      {
	if (rcmx_io_debug) printf("<<<<<<<<<<<<%c>>>>>>>>>>>>", V);

	fputc(V, stdout);

	fflush(stdout);
	
	break;
      }
    }
}

void rcmx_io_external_out(word A, byte V)
{
  /** Just ignore external i/o writes */
}
