/*
 *	int stat(char *filename, struct stat *buf)
 *
 *	Return information about a file
 *
 *	djm 13/3/2000
 *
 *	Just a tad z88 specific!
 *
 * -----
 * $Id: stat.c,v 1.2 2001-04-18 14:59:40 stefano Exp $
 */


#include <sys/stat.h>
#include <z88.h>
#include <stdio.h>

/* Size of a z88 block */
#define BLKSIZE 64

int stat(char *filename, struct stat *buf)
{
	int	dor;	/* file dor */
	int	flags;	
	long	time;
	long	date;
	char	buffer[8];	/* Buffer for reading times */

	if ( (dor=opendor(filename)) ==0)
		return -1;
	/* To figure out if we have a dir or a file we try to
	 * read the extent..if we fail then it wasn't a regular
	 * file
	 */
	printf("Opened dor %d\n",dor);
	flags=0777;	/* rwxrwxrwx */
	readdor(dor,'X',4,&buf->st_size);
	iferror {
		buf->st_size=512L;	/* Std dir size(!) */
		flags+=0040000;
	}
	printf("Read size %lu\n",buf->st_size);
	buffer[0]=0;
	readdor(dor,'U',6,buffer);	/* Read Update time */
	closedor(dor);
	time=*(long *)buffer;
	buffer[3]=0;
	date=*(long*)&buffer[3];
	/* I don't like this, but it seems best way to do it */
	buf->st_ctime=buf->st_mtime=buf->st_atime=doepoch(date,time);
	buf->st_mode=flags;
	/* Now fill in some other things (aka faking!)*/
	buf->st_blksize=BLKSIZE;
	buf->st_blocks=buf->st_size/(long)BLKSIZE;
	/* UID & GID stuff */
	buf->st_gid=0;
	buf->st_uid=0;
	/* Device stuff */
	buf->st_dev=1;
	buf->st_rdev=0;
	/* Inode - try to make unique..maybe time will be sufficiently so*/
	buf->st_ino=buf->st_ctime;
	/* Links */
	buf->st_nlink=0;
	return(0);
}



