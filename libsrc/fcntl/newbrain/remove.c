/*

 Grundy Newbrain Specific libraries

 Stefano Bodrato - 30/05/2007


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 Remove a file (or many files if an ambigous filename is given)

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 int remove(char *name);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 $Id: remove.c,v 1.1 2007-06-11 07:09:35 stefano Exp $

*/


#include <stdio.h>
#include <newbrain.h>

int remove(char *name)
{
	/*  Open the directory device on stream 15 */
	nb_open( OUTP, 15, DEV_SDISCIO, 0, "" );
	
	/* send 'ERASE' command (0) to directory device */
	nb_puts( 15, "0" );
	/* pass file name or file mask */
	nb_puts( 15, name );
	/* <CR> */
	nb_puts( 15, "\n" );
	
	nb_close( 15 );
	return (0);
}
