/*
 *      Part of the library for fcntlt
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 27/4/99
 *
 *      Access is either
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1    Starts afresh?!?!?
 *      O_APPEND = 256
 *
 *      All others are ignored(!)
 *
 * -----
 * $Id: open.c,v 1.2 2016-06-13 19:55:47 dom Exp $
 */

#include <cpm.h>
#include <stdio.h>
#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open(char *name, int flags, mode_t mode)
{
    struct fcb *fc;
    unsigned char uid,pad;
    int   fd;

    if ( ++flags > U_RDWR )
		flags = U_RDWR;

    if ( ( fc = getfcb() ) == NULL ) {
	return -1;
    }

    if ( setfcb(fc,name) == 0 ) {  /* We had a real file, not a device */
		if ( flags == U_READ && bdos(CPM_VERS,0) >= 0x30 )
			fc->name[5] |= 0x80;    /* read only mode */
		uid = getuid();
		setuid(fc->uid);

		if ( (mode & O_WRONLY) == O_WRONLY  )
			remove(name);

		if ( bdos(CPM_OPN,fc) == -1 ) {
			clearfcb(fc);
			setuid(uid);
			if ( flags > U_READ ) {  /* If returned error and writer then create */
			fd = creat(name,0);
			if ( fd == -1 )
				return -1;
			fc = _fcb[fd];
			fc->use = flags;
			return fd;
			}
			return -1;   /* An error */
		}

		setuid(uid);
		fc->use = flags;
    }
    fd =  ((fc - &_fcb[0])/sizeof(struct fcb));
	if (mode & O_APPEND)
		lseek(fd,0L,SEEK_END);

    return fd;
}
