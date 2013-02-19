/*
 * Headerfile for password related stuff
 *
 * $Id: pwd.h,v 1.1 2013-02-19 13:03:19 stefano Exp $
 */

#ifndef __PWD_H__
#define	__PWD_H__

#include <sys/types.h>

//#define	_PATH_PASSWD		"/etc/passwd"
#define	_PASSWORD_LEN		128	/* max length, not counting NULL */

struct passwd {
	char	*pw_name;		/* user name */
	char	*pw_passwd;		/* encrypted password */
	int		pw_uid;			/* user uid */
	int		pw_gid;			/* user gid */
	char	*pw_comment;	/* comment */
	char	*pw_gecos;		/* Honeywell login info */
	char	*pw_dir;		/* home directory */
	char	*pw_shell;		/* default shell */
};


//struct passwd	*getpwnam (const char * pwname);
//struct passwd	*getpwuid (int pwuid);


#endif /* __PWD_H__ */
