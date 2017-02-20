include(__link__.m4)

#ifndef _STDIO_H
#define _STDIO_H

#include <stdint.h>

// DATA STRUCTURES

#ifndef _SIZE_T_DEFINED
#define _SIZE_T_DEFINED
typedef unsigned int    size_t;
#endif

typedef unsigned long   fpos_t;
typedef struct { unsigned char file[13];} FILE;

#ifndef NULL
#define NULL            ((void*)(0))
#endif

#define _IOFBF          0
#define _IOLBF          1
#define _IONBF          2

#define BUFSIZ          1      // clib does not do high level buffering

#define EOF             (-1)

extern unsigned char    _MAX_FOPEN[];
#define FOPEN_MAX       ((unsigned int)_MAX_FOPEN)

#define FILENAME_MAX    128

#define L_tmpnam        8
#define TMP_MAX         16

#ifndef SEEK_SET
#define SEEK_SET        0
#endif

#ifndef SEEK_CUR
#define SEEK_CUR        1
#endif

#ifndef SEEK_END
#define SEEK_END        2
#endif

extern FILE *stdin;
extern FILE *stdout;
extern FILE *stderr;

#ifdef __CPM

extern FILE *stdrdr;
extern FILE *stdpun;
extern FILE *stdlst;

#endif

// FUNCTIONS

__DPROTO(,,FILE,*,_fmemopen_,void **bufp,size_t *sizep,char *mode)
__VPROTO(,,int,,asprintf,char **ptr,char *format,...)
__DPROTO(,,void,,clearerr,FILE *stream)
__DPROTO(,,int,,fclose,FILE *stream)
__DPROTO(,,FILE,*,fdopen,int fd,const char *mode)
__DPROTO(,,int,,feof,FILE *stream)
__DPROTO(,,int,,ferror,FILE *stream)
__DPROTO(,,int,,fflush,FILE *stream)
__DPROTO(,,int,,fgetc,FILE *stream)
__DPROTO(,,int,,fgetpos,FILE *stream,fpos_t *pos)
__DPROTO(,,char,*,fgets,char *s,int n,FILE *stream)
__DPROTO(,,int,,fileno,FILE *stream)
__DPROTO(,,void,,flockfile,FILE *stream)
__DPROTO(,,FILE,*,fmemopen,void *buf,size_t size,char *mode)
__DPROTO(,,FILE,*,fopen,const char *filename,const char *mode)
__VPROTO(,,int,,fprintf,FILE *stream,char *format,...)
__DPROTO(,,int,,fputc,int c,FILE *stream)
__DPROTO(,,int,,fputs,char *s,FILE *stream)
__DPROTO(,,size_t,,fread,void *ptr,size_t size,size_t nmemb,FILE *stream)
__DPROTO(,,FILE,*,freopen,char *filename,char *mode,FILE *stream)
__VPROTO(,,int,,fscanf,FILE *stream,char *format,...)
__DPROTO(,,int,,fseek,FILE *stream,long offset,int whence)
__DPROTO(,,int,,fsetpos,FILE *stream,fpos_t *pos)
__DPROTO(,,uint32_t,,ftell,FILE *stream)
__DPROTO(,,int,,ftrylockfile,FILE *stream)
__DPROTO(,,void,,funlockfile,FILE *stream)
__DPROTO(,,size_t,,fwrite,void *ptr,size_t size,size_t nmemb,FILE *stream)
__DPROTO(,,int,,getc,FILE *stream)
__OPROTO(,,int,,getchar,void)
__DPROTO(,,int,,getdelim,char **lineptr,size_t *n,int delim,FILE *stream)
__DPROTO(,,int,,getline,char **lineptr,size_t *n,FILE *stream)
__DPROTO(,,char,*,gets,char *s)
__VPROTO(,,int,,obstack_printf,struct obstack *ob,char *format,...)
__DPROTO(,,int,,obstack_vprintf,struct obstack *ob,char *format,void *arg)
__DPROTO(,,FILE,*,open_memstream,char **bufp,size_t *sizep)
__DPROTO(,,void,,perror,char *s)
__VPROTO(,,int,,printf,char *format,...)
__DPROTO(,,int,,putc,int c,FILE *stream)
__DPROTO(,,int,,putchar,int c)
__DPROTO(,,int,,puts,char *s)
__DPROTO(,,void,,rewind,FILE *stream)
__VPROTO(,,int,,scanf,char *format,...)
__VPROTO(,,int,,snprintf,char *s,size_t n,char *format,...)
__VPROTO(,,int,,sprintf,char *s,char *format,...)
__VPROTO(,,int,,sscanf,char *s,char *format,...)
__DPROTO(,,int,,ungetc,int c,FILE *stream)
__DPROTO(,,int,,vasprintf,char **ptr,char *format,void *arg)
__DPROTO(,,int,,vfprintf,FILE *stream,char *format,void *arg)
__DPROTO(,,int,,vfscanf,FILE *stream,char *format,void *arg)
__DPROTO(,,int,,vprintf,char *format,void *arg)
__DPROTO(,,int,,vscanf,char *format,void *arg)
__DPROTO(,,int,,vsnprintf,char *s,size_t n,char *format,void *arg)
__DPROTO(,,int,,vsprintf,char *s,char *format,void *arg)
__DPROTO(,,int,,vsscanf,char *s,char *format,void *arg)

__DPROTO(`b,c,d,e',`b,c,d,e',void,,clearerr_unlocked,FILE *stream)
__DPROTO(,,int,,fclose_unlocked,FILE *stream)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,feof_unlocked,FILE *stream)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,ferror_unlocked,FILE *stream)
__DPROTO(,,int,,fflush_unlocked,FILE *stream)
__DPROTO(,,int,,fgetc_unlocked,FILE *stream)
__DPROTO(,,int,,fgetpos_unlocked,FILE *stream,fpos_t *pos)
__DPROTO(,,char,*,fgets_unlocked,char *s,int n,FILE *stream)
__DPROTO(,,int,,fileno_unlocked,FILE *stream)
__VPROTO(,,int,,fprintf_unlocked,FILE *stream,char *format,...)
__DPROTO(,,int,,fputc_unlocked,int c,FILE *stream)
__DPROTO(,,int,,fputs_unlocked,char *s,FILE *stream)
__DPROTO(,,size_t,,fread_unlocked,void *ptr,size_t size,size_t nmemb,FILE *stream)
__DPROTO(,,FILE,*,freopen_unlocked,char *filename,char *mode,FILE *stream)
__VPROTO(,,int,,fscanf_unlocked,FILE *stream,char *format,...)
__DPROTO(,,int,,fseek_unlocked,FILE *stream,long offset,int whence)
__DPROTO(,,int,,fsetpos_unlocked,FILE *stream,fpos_t *pos)
__DPROTO(,,uint32_t,,ftell_unlocked,FILE *stream)
__DPROTO(,,size_t,,fwrite_unlocked,void *ptr,size_t size,size_t nmemb,FILE *stream)
__DPROTO(,,int,,getc_unlocked,FILE *stream)
__OPROTO(,,int,,getchar_unlocked,void)
__DPROTO(,,int,,getdelim_unlocked,char **lineptr,size_t *n,int delim,FILE *stream)
__DPROTO(,,int,,getline_unlocked,char **lineptr,size_t *n,FILE *stream)
__DPROTO(,,char,*,gets_unlocked,char *s)
__VPROTO(,,int,,printf_unlocked,char *format,...)
__DPROTO(,,int,,putc_unlocked,int c,FILE *stream)
__DPROTO(,,int,,putchar_unlocked,int c)
__DPROTO(,,int,,puts_unlocked,char *s)
__DPROTO(,,void,,rewind_unlocked,FILE *stream)
__VPROTO(,,int,,scanf_unlocked,char *format,...)
__DPROTO(,,int,,ungetc_unlocked,int c,FILE *stream)
__DPROTO(,,int,,vfprintf_unlocked,FILE *stream,char *format,void *arg)
__DPROTO(,,int,,vfscanf_unlocked,FILE *stream,char *format,void *arg)
__DPROTO(,,int,,vprintf_unlocked,char *format,void *arg)
__DPROTO(,,int,,vscanf_unlocked,char *format,void *arg)

#endif
