/*
 *	Read from a file
 *
 *	int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
 *
 *	Calls read() in fcntl to do the dirty work
 *
 *	Returns number of members written
 *
 *	We have to take account of ungotten characters
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fread.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
	if ( (fp->flags&(_IOUSE|_IOWRITE)==(_IOUSE|_IOWRITE))  && \
			fchkstd(fp)== 0) {
		int	written=size*nmemb;

		if (written) {
			(unsigned char *)*ptr=(unsigned char)fgetc(fp);
			written=write(fp->desc.fd,ptr+1,written-1);
		/* Return number of members read */
			return (written/size);
		}
	}
	return 0;
}


