/*
 *	Read from a file
 *
 *	int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
 *
 *	Calls read() in fcntl to do the dirty work
 *
 *	Returns number of members readen
 *
 *	We have to take account of ungotten characters
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fread.c,v 1.3 2001-12-16 21:14:54 dom Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
	if ( (fp->flags&(_IOUSE|_IOREAD)==(_IOUSE|_IOREAD))  && \
			fchkstd(fp)== 0) {
		int	readen=size*nmemb;

		if (readen) {
			/* Pick up ungot character */
			(unsigned char *)*ptr=(unsigned char)fgetc(fp);
			readen=read(fp->desc.fd,ptr+1,readen-1);
		/* Return number of members read */
			return (readen/size);
		}
	}
	return 0;
}


