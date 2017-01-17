/*

 Grundy Newbrain Specific libraries

 Stefano Bodrato - 30/05/2007


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 Rename a file

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

int rename(char *s, char *d);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 $Id: rename.c,v 1.1 2007-06-11 07:09:35 stefano Exp $

*/

#include <stdio.h>
#include <newbrain.h>


int rename(char *oldname, char *newname)
{
	/*  Open the directory device on stream 15 */
	nb_open( OUTP, 15, DEV_SDISCIO, 0, "" );
	
	/* send 'RENAME' command (1) to directory device */
	nb_puts( 15, "1" );
	/* pass file name or file mask */
	nb_puts( 15, oldname );
	nb_puts( 15, " " );
	nb_puts( 15, newname );
	/* <CR> */
	nb_puts( 15, "\n" );
	
	nb_close( 15 );
	return (0);
}
