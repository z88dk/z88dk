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
 * $Id: fread.c,v 1.4 2002-06-08 17:15:19 dom Exp $
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
		    int c = fgetc(fp);
		    /* Horrible hack around here */
		    if ( c > 0 ) {
			*ptr = (unsigned char )c;
			readen=read(fp->desc.fd,ptr+1,readen-1);
			++readen;
			/* Return number of members read */
			return (readen/size);
		    }
		}
	}
	return 0;
}


