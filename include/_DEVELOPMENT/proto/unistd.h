include(__link__.m4)

#ifndef __UNISTD_H__
#define __UNISTD_H__

#ifndef NULL
#define NULL                   ((void*)(0))
#endif

#ifndef SEEK_SET
#define SEEK_SET               0
#endif

#ifndef SEEK_CUR
#define SEEK_CUR               1
#endif

#ifndef SEEK_END
#define SEEK_END               2
#endif

#define STDIN_FILENO           0
#define STDOUT_FILENO          1
#define STDERR_FILENO          2

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned int           size_t;
#endif

#ifndef _SSIZE_T
#define _SSIZE_T
typedef unsigned int           ssize_t;
#endif

#ifndef _OFF_T
#define _OFF_T
typedef long                   off_t;
#endif

#ifndef _INTPTR_T
#define _INTPTR_T
typedef int                    intptr_t;
#endif

__DPROTO(,,int,,close,int fd)
__DPROTO(,,int,,dup,int fd)
__DPROTO(,,int,,dup2,int fd,int fd2)
__DPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,_exit,int status)
__DPROTO(,,off_t,,lseek,int fd,off_t offset,int whence)
__DPROTO(,,ssize_t,,read,int fd,void *buf,size_t nbyte)
__DPROTO(,,ssize_t,,write,int fd,const void *buf,size_t nbyte)

#endif
