/*
 *	Write to a file
 *
 *	int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp)
 *
 *	Calls write() in fcntl to do the dirty work
 *
 *	Returns number of members written
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fwrite.c,v 1.5 2012-06-13 11:04:30 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
	if ( (fp->flags&(_IOUSE|_IOWRITE)==(_IOUSE|_IOWRITE)) && fchkstd(fp)== 0 ) {
		int written=write(fp->fd,ptr,size*nmemb);
		/* Return number of members written */
		return (written/size);
	}
	return 0;
}


