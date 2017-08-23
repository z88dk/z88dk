/*
 *	OSCA FLOS - free file
 *	Stefano Bodrato - March 2012
 *
 *	int close(int handle)
 *	closes file
 *
 *	$Id: close.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
 */

#include <fcntl.h>
#include <flos.h>
#include <string.h>

//#include <stdio.h>
//#include <malloc.h>

int close(int myfile)
{
	struct flos_file *flosfile;

	flosfile = (char *) myfile;
	flosfile->name[0]=0;
}

