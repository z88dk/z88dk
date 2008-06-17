#ifndef _STDIO_H
#define _STDIO_H

#include <sys/types.h>

///////////////////
/// DATA STRUCTURES
///////////////////

struct _stdio_file {

   uchar  byte0;               // +0  195
   void  *svc_func;            // +1  i/o service function
   uchar  flags;               // +3  0000 0IOU (I = open for input, O = open for output, U = unget char avail)
   uchar  ungetc;              // +4  available unget char

};

typedef struct _stdio_file FILE;

#undef NULL
#define NULL 0

#undef EOF
#define EOF (-1)

extern FILE *stdin;
extern FILE *stdout;
extern FILE *stderr;

extern int errno;

///////////////////
/// FILE OPERATIONS
///////////////////

///////////////////////////
/// DESCRIPTORS AND STREAMS
///////////////////////////

extern int  __LIB__ __FASTCALL__  fileno(FILE *stream);

//////////////////////////////
/// FORMATTED OUTPUT FUNCTIONS
//////////////////////////////

extern int  __LIB__               printf(char *format, ...);
extern int  __LIB__               fprintf(FILE *stream, char *format, ...);
extern int  __LIB__               sprintf(char *s, char *format, ...);
extern int  __LIB__               snprintf(char *s, uint size, char *format, ...);
extern int  __LIB__               asprintf(char **s, char *format, ...);

extern int  __LIB__               vprintf(char *format, void *arg);
extern int  __LIB__               vfprintf(FILE *stream, char *format, void *arg);
extern int  __LIB__               vsprintf(char *s, char *format, void *arg);
extern int  __LIB__               vsnprintf(char *s, uint size, char *format, void *arg);
extern int  __LIB__               vasprintf(char **s, char *format, void *arg);

extern int  __LIB__ __CALLEE__    vprintf_callee(char *format, void *arg);
extern int  __LIB__ __CALLEE__    vfprintf_callee(FILE *stream, char *format, void *arg);
extern int  __LIB__ __CALLEE__    vsprintf_callee(char *s, char *format, void *arg);
extern int  __LIB__ __CALLEE__    vsnprintf_callee(char *s, uint size, char *format, void *arg);
extern int  __LIB__ __CALLEE__    vasprintf_callee(char **s, char *format, void *arg);

// make callee linkage the default

#define vprintf(a,b)              vprintf_callee(a,b)
#define vfprintf(a,b,c)           vfprintf_callee(a,b,c)
#define vsprintf(a,b,c)           vsprintf_callee(a,b,c)
#define vsnprintf(a,b,c,d)        vsnprintf_callee(a,b,c,d)
#define vasprintf(a,b,c)          vasprintf_callee(a,b,c)

/////////////////////////////
/// FORMATTED INPUT FUNCTIONS
/////////////////////////////

extern int  __LIB__               scanf(char *format, ...);
extern int  __LIB__               fscanf(FILE *stream, char *format, ...);
extern int  __LIB__               sscanf(char *s, char *format, ...);

extern int  __LIB__               vscanf(char *format, void *arg);
extern int  __LIB__               vfscanf(FILE *stream, char *format, void *arg);
extern int  __LIB__               vsscanf(char *s, char *format, void *arg);

extern int  __LIB__ __CALLEE__    vscanf_callee(char *format, void *arg);
extern int  __LIB__ __CALLEE__    vfscanf_callee(FILE *stream, char *format, void *arg);
extern int  __LIB__ __CALLEE__    vsscanf_callee(char *s, char *format, void *arg);

// make callee linkage the default

#define vscanf(a,b)               vscanf_callee(a,b)
#define vfscanf(a,b,c)            vfscanf_callee(a,b,c)
#define vsscanf(a,b,c)            vsscanf_callee(a,b,c)

///////////////////////////
/// CHARACTER I/O FUNCTIONS
///////////////////////////

extern int  __LIB__ __FASTCALL__  fgetc(FILE *stream);
extern char __LIB__              *fgets(char *s, uint n, FILE *stream);
extern int  __LIB__               fputc(int c, FILE *stream);
extern int  __LIB__               fputs(char *s, FILE *stream);
extern int  __LIB__               getchar(void);
extern char __LIB__ __FASTCALL__ *gets(char *s);
extern int  __LIB__ __FASTCALL__  putchar(int c);
extern int  __LIB__ __FASTCALL__  puts(char *s);
extern int  __LIB__               ungetc(int c, FILE *stream);

#define getc fgetc
#define putc fputc

extern char __LIB__ __CALLEE__   *fgets_callee(char *s, uint n, FILE *stream);
extern int  __LIB__ __CALLEE__    fputc_callee(int c, FILE *stream);
extern int  __LIB__ __CALLEE__    fputs_callee(char *s, FILE *stream);
extern int  __LIB__ __CALLEE__    putc_callee(int c, FILE *stream);
extern int  __LIB__ __CALLEE__    ungetc_callee(int c, FILE *stream);

// make callee linkage the default

#define fgets(a,b,c)              fgets_callee(a,b,c)
#define fputc(a,b)                fputc_callee(a,b)
#define fputs(a,b)                fputs_callee(a,b)
#define putc(a,b)                 putc_callee(a,b)
#define ungetc(a,b)               ungetc_callee(a,b)

/////////////////////////////////////
/// DIRECT INPUT AND OUTPUT FUNCTIONS
/////////////////////////////////////

//////////////////////////////
/// FILE POSITIONING FUNCTIONS
//////////////////////////////

///////////////////
/// ERROR FUNCTIONS
///////////////////

#endif

