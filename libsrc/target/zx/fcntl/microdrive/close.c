/*
 *	Close a file on Microdrive
 *	Stefano Bodrato - Feb. 2005..2021
 *
 *	int close(int handle)
 *	closes file and frees memory
 *
 *	$Id: close.c $
 */

#include <fcntl.h>
#include <zxinterface1.h>

//#include <stdio.h>
#include <malloc.h>


int close(int fd)
{

struct M_CHAN *if1_file;
int flags;

	if1_file = (void *) fd;
	flags = (if1_file)->flags & 0xff;

	if ((flags == O_APPEND) || (flags == O_WRONLY))
	{
		//printf ("\nClosing file on drive \n",);

		if1_write_record (if1_file->drive, if1_file);
		
/* DEBUG - experiments to see how the M_CHAN structure survived
		#pragma printf %u
		printf ("\n Cartridge name: %s",if1_getname( (char *) if1_file->hdname));
		printf ("\n File name: %s",if1_getname( (char *) if1_file->name));
		printf ("\nRecord flags: ");
		int x;
		for (x=7; x >-1; x--)  (if1_file->recflg & (2^x)) ? fputc_cons('1') : fputc_cons('0');
		printf ("\n");
*/
		
		//if1_file->recflg |= 2;	// Set EOF bit on last record
	}

	free(fd);
	return 0;
}

