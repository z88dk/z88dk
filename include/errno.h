/*
 *  errno.h
 *
 *	$Id: errno.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef __ERRNO_H__
#define __ERRNO_H__

#include <sys/compiler.h>

extern int errno;

typedef int error_t;

#define EOK  0
#define EACCES  1
#define EBADF  2
#define EBDFD  3
#define EDOM  4
#define EFBIG  5
#define EINVAL  6
#define EMFILE  7
#define ENFILE  8
#define ENOLCK  9
#define ENOMEM  10
#define ENOTSUP  11
#define EOVERFLOW  12
#define ANGE  13
#define ESTAT  14
#define EAGAIN  15
#define EWOULDBLOCK  15


#endif
