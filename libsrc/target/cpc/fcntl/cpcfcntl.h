/*
 * Internal library header file for CPC fcntl routines
 *
 * Routines donated by **_warp6_** <kbaccam@free.fr>
 *
 * $Id: cpcfcntl.h,v 1.1 2003-09-12 16:30:43 dom Exp $
 */

#ifndef __FCNTL_CPCFCNTL_H__
#define __FCNTL_CPCFCNTL_H__

#include <sys/types.h>

typedef struct {
	u8_t	in_used;
	u8_t	out_used;
	char	in_buf[2048];
	char	out_buf[2048];
} cpc_fd;

extern cpc_fd cpcfile;

extern int __LIB__ cpc_openin(char *name, int namelen,char *buf);
extern int __LIB__ cpc_openout(char *name, int namelen,char *buf);
extern int __LIB__ cpc_closein();
extern int __LIB__ cpc_closeout();

#endif /* __FCNTL_CPCFCNTL_H__ */
