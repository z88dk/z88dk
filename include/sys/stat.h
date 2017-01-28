#ifndef __SYS_STAT_H__
#define __SYS_STAT_H__

/* We need some time stuff */
#include <time.h>

/*
 *	Defines and stuff for the stat functions.
 *	We try to be good and emulate as much a possible
 *	Hence all these silly defs!
 *
 *	$Id: stat.h,v 1.5 2016-03-06 21:39:17 dom Exp $
 */

struct stat {
	int	st_mode;	/* Mode */
	time_t	st_atime;	/* Last access */
	time_t	st_mtime;	/* Last modification */
	time_t	st_ctime;	/* Last change?!?! */
	long	st_size;	/* Size */
	/* These two based on real values */
	int	st_blksize;	/* Blocksize */
	int	st_blocks;	/* # of blocks */
	/* Below here is fake */
	int	st_ino;		/* Inode */
	int	st_uid;		/* UID (not supported) */
	int	st_gid;		/* GID (not supported) */
	int	st_dev;		/* Device number */
	int	st_nlink;	/* number of links */
	int	st_rdev;	/* ? */
};

extern int __LIB__ __SAVEFRAME__ stat(char *filename, struct stat *buf);

extern int __LIB__  mkdir(char *dirname);
#define mkdir(a,b) mkdir(a)

#define S_IFMT		0170000	/* file type mask */
#define S_IFLNK		0110000	/* symbolic link */
#define S_IFREG		0100000	/* or just 000000, regular */
#define S_IFBLK 	0060000	/* block special */
#define S_IFDIR 	0040000	/* directory */
#define S_IFCHR 	0020000	/* character special */
#define S_IFPIPE 	0010000	/* pipe */

#define S_UMASK 	07777	/* bits modifiable by chmod */

#define S_ISUID 	04000	/* set euid to file uid */
#define S_ISGID 	02000 	/* set egid to file gid */
#define S_ISVTX 	01000	/* */

#define S_IREAD 	0400	/* owner may read */
#define S_IWRITE 	0200 	/* owner may write */
#define S_IEXEC 	0100	/* owner may execute <directory search> */

#define S_IGREAD 	0040	/* group may read */
#define S_IGWRITE 	0020 	/* group may write */
#define S_IGEXEC 	0010	/* group may execute <directory search> */

#define S_IOREAD 	0004	/* other may read */
#define S_IOWRITE  	0002	/* other may write */
#define S_IOEXEC 	0001	/* other may execute <directory search> */

#define S_IRWXU 	00700
#define S_IRUSR 	00400
#define S_IWUSR 	00200
#define S_IXUSR 	00100

#define S_IRWXG 	00070
#define S_IRGRP 	00040
#define S_IWGRP 	00020
#define S_IXGRP 	00010

#define S_IRWXO 	00007
#define S_IROTH 	00004
#define S_IWOTH 	00002
#define S_IXOTH 	00001

#define S_ISLNK(m)	(((m) & S_IFMT) == S_IFLNK)
#define S_ISREG(m)	(((m) & S_IFMT) == S_IFREG)
#define S_ISDIR(m)	(((m) & S_IFMT) == S_IFDIR)
#define S_ISCHR(m)	(((m) & S_IFMT) == S_IFCHR)
#define S_ISBLK(m)	(((m) & S_IFMT) == S_IFBLK)
#define S_ISPIPE(m)	(((m) & S_IFMT) == S_IFPIPE)

#define S_ISDEV(m)	(((m) & S_IFMT) & S_IFCHR)

#endif
