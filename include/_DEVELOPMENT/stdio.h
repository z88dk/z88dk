
#ifndef _STDIO_H
#define _STDIO_H

#include <stdint.h>

// DATA STRUCTURES

#ifndef _STDDEF_H

   typedef unsigned int size_t;
   #define NULL ((void*)(0))

#endif

typedef unsigned long fpos_t;
typedef struct { unsigned char file[17];} FILE;

extern FILE *_stdio_file_stdin;
extern FILE *_stdio_file_stdout;
extern FILE *_stdio_file_stderr; 

#define stdin   (_stdio_file_stdin)
#define stdout  (_stdio_file_stdout)
#define stderr  (_stdio_file_stderr)

#define _IOFBF          0
#define _IOLBF          1
#define _IONBF          2
#define BUFSIZ          1      // this clib uses an alternative to buffering

#define EOF            -1

#ifndef FOPEN_MAX
#define FOPEN_MAX       8
#endif

#define FILENAME_MAX  256

#define L_tmpnam        8
#define TMP_MAX       256

#define SEEK_SET        0
#define SEEK_CUR        1
#define SEEK_END        2

#ifdef __SDCC

// SDCC

extern FILE   *_fmemopen_(void **bufp, size_t *sizep, char *mode);
extern int     asprintf(char **ptr, char *format, ...);
extern void    clearerr(FILE *stream);
extern int     fclose(FILE *stream);
extern int     feof(FILE *stream);
extern int     ferror(FILE *stream);
extern int     fflush(FILE *stream);
extern int     fgetc(FILE *stream);
extern int     fgetpos(FILE *stream, fpos_t *pos);
extern char   *fgets(char *s, int n, FILE *stream);
extern void    flockfile(FILE *stream);
extern FILE   *fmemopen(void *buf, size_t size, char *mode);
extern FILE   *fopen(const char *filename, const char *mode);
extern int     fprintf(FILE *stream, char *format, ...);
extern int     fputc(int c, FILE *stream);
extern int     fputs(char *s, FILE *stream);
extern size_t  fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern FILE   *freopen(char *filename, char *mode, FILE *stream);
extern int     fscanf(FILE *stream, char *format, ...);
extern int     fseek(FILE *stream, long offset, int whence);
extern int     fsetpos(FILE *stream, fpos_t *pos);
extern uint32_t  ftell(FILE *stream);
extern int     ftrylockfile(FILE *stream);
extern void    funlockfile(FILE *stream);
extern size_t  fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern int     getc(FILE *stream);
extern int     getchar(void);
extern int     getdelim(char **lineptr, size_t *n, int delim, FILE *stream);
extern int     getline(char **lineptr, size_t *n, FILE *stream);
extern char    gets(char *s);
extern int     obstack_printf(struct obstack *ob, char *format, ...);
extern int     obstack_vprintf(struct obstack *ob, char *format, void *arg);
extern FILE   *open_memstream(char **bufp, size_t *sizep);
extern void    perror(char *s);
extern int     printf(char *format, ...);
extern int     putc(int c, FILE *stream);
extern int     putchar(int c);
extern int     puts(char *s);
extern void    rewind(FILE *stream);
extern int     scanf(char *format, ...);
extern int     snprintf(char *s, size_t n, char *format, ...);
extern int     sprintf(char *s, char *format, ...);
extern int     sscanf(char *s, char *format, ...);
extern int     ungetc(int c, FILE *stream);
extern int     vasprintf(char **ptr, char *format, void *arg);
extern int     vfprintf(FILE *stream, char *format, void *arg);
extern int     vfscanf(FILE *stream, char *format, void *arg);
extern int     vprintf(char *format, void *arg);
extern int     vscanf(char *format, void *arg);
extern int     vsnprintf(char *s, size_t n, char *format, void *arg);
extern int     vsprintf(char *s, char *format, void *arg);
extern int     vsscanf(char *s, char *format, void *arg);

extern void    clearerr_unlocked(FILE *stream);
extern int     fclose_unlocked(FILE *stream);
extern int     feof_unlocked(FILE *stream);
extern int     ferror_unlocked(FILE *stream);
extern int     fflush_unlocked(FILE *stream);
extern int     fgetc_unlocked(FILE *stream);
extern int     fgetpos_unlocked(FILE *stream, fpos_t *pos);
extern char   *fgets_unlocked(char *s, int n, FILE *stream);
extern FILE   *fopen_unlocked(const char *filename, const char *mode);
extern int     fprintf_unlocked(FILE *stream, char *format, ...);
extern int     fputc_unlocked(int c, FILE *stream);
extern int     fputs_unlocked(char *s, FILE *stream);
extern size_t  fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern FILE   *freopen_unlocked(char *filename, char *mode, FILE *stream);
extern int     fscanf_unlocked(FILE *stream, char *format, ...);
extern int     fseek_unlocked(FILE *stream, long offset, int whence);
extern int     fsetpos_unlocked(FILE *stream, fpos_t *pos);
extern uint32_t  ftell_unlocked(FILE *stream);
extern size_t  fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern int     getc_unlocked(FILE *stream);
extern int     getchar_unlocked(void);
extern int     getdelim_unlocked(char **lineptr, size_t *n, int delim, FILE *stream);
extern int     getline_unlocked(char **lineptr, size_t *n, FILE *stream);
extern char    gets_unlocked(char *s);
extern int     printf_unlocked(char *format, ...);
extern int     putc_unlocked(int c, FILE *stream);
extern int     putchar_unlocked(int c);
extern int     puts_unlocked(char *s);
extern void    rewind_unlocked(FILE *stream);
extern int     scanf_unlocked(char *format, ...);
extern int     ungetc_unlocked(int c, FILE *stream);
extern int     vfprintf_unlocked(FILE *stream, char *format, void *arg);
extern int     vfscanf_unlocked(FILE *stream, char *format, void *arg);
extern int     vprintf_unlocked(char *format, void *arg);
extern int     vscanf_unlocked(char *format, void *arg);

#else

// SCCZ80

extern FILE   __LIB__              *_fmemopen_(void **bufp, size_t *sizep, char *mode);
extern int    __LIB__               asprintf(char **ptr, char *format, ...);
extern void   __LIB__ __FASTCALL__  clearerr(FILE *stream);
extern int    __LIB__ __FASTCALL__  fclose(FILE *stream);
extern int    __LIB__ __FASTCALL__  feof(FILE *stream);
extern int    __LIB__ __FASTCALL__  ferror(FILE *stream);
extern int    __LIB__ __FASTCALL__  fflush(FILE *stream);
extern int    __LIB__ __FASTCALL__  fgetc(FILE *stream);
extern int    __LIB__               fgetpos(FILE *stream, fpos_t *pos);
extern char   __LIB__              *fgets(char *s, int n, FILE *stream);
extern void   __LIB__ __FASTCALL__  flockfile(FILE *stream);
extern FILE   __LIB__              *fmemopen(void *buf, size_t size, char *mode);
extern FILE   __LIB__              *fopen(const char *filename, const char *mode);
extern int    __LIB__               fprintf(FILE *stream, char *format, ...);
extern int    __LIB__               fputc(int c, FILE *stream);
extern int    __LIB__               fputs(char *s, FILE *stream);
extern size_t __LIB__               fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern FILE   __LIB__              *freopen(char *filename, char *mode, FILE *stream);
extern int    __LIB__               fscanf(FILE *stream, char *format, ...);
extern int    __LIB__               fseek(FILE *stream, long offset, int whence);
extern int    __LIB__               fsetpos(FILE *stream, fpos_t *pos);
extern uint32_t  __LIB__ __FASTCALL__  ftell(FILE *stream);
extern int    __LIB__ __FASTCALL__  ftrylockfile(FILE *stream);
extern void   __LIB__ __FASTCALL__  funlockfile(FILE *stream);
extern size_t __LIB__               fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern int    __LIB__ __FASTCALL__  getc(FILE *stream);
extern int    __LIB__               getchar(void);
extern int    __LIB__               getdelim(char **lineptr, size_t *n, int delim, FILE *stream);
extern int    __LIB__               getline(char **lineptr, size_t *n, FILE *stream);
extern char   __LIB__ __FASTCALL__  gets(char *s);
extern int    __LIB__               obstack_printf(struct obstack *ob, char *format, ...);
extern int    __LIB__               obstack_vprintf(struct obstack *ob, char *format, void *arg);
extern FILE   __LIB__              *open_memstream(char **bufp, size_t *sizep);
extern void   __LIB__ __FASTCALL__  perror(char *s);
extern int    __LIB__               printf(char *format, ...);
extern int    __LIB__               putc(int c, FILE *stream);
extern int    __LIB__ __FASTCALL__  putchar(int c);
extern int    __LIB__ __FASTCALL__  puts(char *s);
extern void   __LIB__ __FASTCALL__  rewind(FILE *stream);
extern int    __LIB__               scanf(char *format, ...);
extern int    __LIB__               snprintf(char *s, size_t n, char *format, ...);
extern int    __LIB__               sprintf(char *s, char *format, ...);
extern int    __LIB__               sscanf(char *s, char *format, ...);
extern int    __LIB__               ungetc(int c, FILE *stream);
extern int    __LIB__               vasprintf(char **ptr, char *format, void *arg);
extern int    __LIB__               vfprintf(FILE *stream, char *format, void *arg);
extern int    __LIB__               vfscanf(FILE *stream, char *format, void *arg);
extern int    __LIB__               vprintf(char *format, void *arg);
extern int    __LIB__               vscanf(char *format, void *arg);
extern int    __LIB__               vsnprintf(char *s, size_t n, char *format, void *arg);
extern int    __LIB__               vsprintf(char *s, char *format, void *arg);
extern int    __LIB__               vsscanf(char *s, char *format, void *arg);

extern void   __LIB__ __FASTCALL__  clearerr_unlocked(FILE *stream);
extern void   __LIB__ __FASTCALL__  fclose_unlocked(FILE *stream);
extern int    __LIB__ __FASTCALL__  feof_unlocked(FILE *stream);
extern int    __LIB__ __FASTCALL__  ferror_unlocked(FILE *stream);
extern int    __LIB__ __FASTCALL__  fflush_unlocked(FILE *stream);
extern int    __LIB__ __FASTCALL__  fgetc_unlocked(FILE *stream);
extern int    __LIB__               fgetpos_unlocked(FILE *stream, fpos_t *pos);
extern char   __LIB__              *fgets_unlocked(char *s, int n, FILE *stream);
extern FILE   __LIB__              *fopen_unlocked(const char *filename, const char *mode);
extern int    __LIB__               fprintf_unlocked(FILE *stream, char *format, ...);
extern int    __LIB__               fputc_unlocked(int c, FILE *stream);
extern int    __LIB__               fputs_unlocked(char *s, FILE *stream);
extern size_t __LIB__               fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern FILE   __LIB__              *freopen_unlocked(char *filename, char *mode, FILE *stream);
extern int    __LIB__               fscanf_unlocked(FILE *stream, char *format, ...);
extern int    __LIB__               fseek_unlocked(FILE *stream, long offset, int whence);
extern int    __LIB__               fsetpos_unlocked(FILE *stream, fpos_t *pos);
extern uint32_t  __LIB__ __FASTCALL__  ftell_unlocked(FILE *stream);
extern size_t __LIB__               fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern int    __LIB__ __FASTCALL__  getc_unlocked(FILE *stream);
extern int    __LIB__               getchar_unlocked(void);
extern int    __LIB__               getdelim_unlocked(char **lineptr, size_t *n, int delim, FILE *stream);
extern int    __LIB__               getline_unlocked(char **lineptr, size_t *n, FILE *stream);
extern char   __LIB__ __FASTCALL__  gets_unlocked(char *s);
extern int    __LIB__               printf_unlocked(char *format, ...);
extern int    __LIB__               putc_unlocked(int c, FILE *stream);
extern int    __LIB__ __FASTCALL__  putchar_unlocked(int c);
extern int    __LIB__ __FASTCALL__  puts_unlocked(char *s);
extern void   __LIB__ __FASTCALL__  rewind_unlocked(FILE *stream);
extern int    __LIB__               scanf_unlocked(char *format, ...);
extern int    __LIB__               ungetc_unlocked(int c, FILE *stream);
extern int    __LIB__               vfprintf_unlocked(FILE *stream, char *format, void *arg);
extern int    __LIB__               vfscanf_unlocked(FILE *stream, char *format, void *arg);
extern int    __LIB__               vprintf_unlocked(char *format, void *arg);
extern int    __LIB__               vscanf_unlocked(char *format, void *arg);

// SCCZ80 CALLEE LINKAGE

extern FILE   __LIB__ __CALLEE__   *_fmemopen__callee(void **bufp, size_t *sizep, char *mode);
extern int    __LIB__ __CALLEE__    fgetpos_callee(FILE *stream, fpos_t *pos);
extern char   __LIB__ __CALLEE__   *fgets_callee(char *s, int n, FILE *stream);
extern FILE   __LIB__ __CALLEE__   *fmemopen_callee(void *buf, size_t size, char *mode);
extern FILE   __LIB__ __CALLEE__   *fopen_callee(const char *filename, const char *mode);
extern int    __LIB__ __CALLEE__    fputc_callee(int c, FILE *stream);
extern int    __LIB__ __CALLEE__    fputs_callee(char *s, FILE *stream);
extern size_t __LIB__ __CALLEE__    fread_callee(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern FILE   __LIB__ __CALLEE__   *freopen_callee(char *filename, char *mode, FILE *stream);
extern int    __LIB__ __CALLEE__    fseek_callee(FILE *stream, long offset, int whence);
extern int    __LIB__ __CALLEE__    fsetpos_callee(FILE *stream, fpos_t *pos);
extern size_t __LIB__ __CALLEE__    fwrite_callee(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern int    __LIB__ __CALLEE__    getdelim_callee(char **lineptr, size_t *n, int delim, FILE *stream);
extern int    __LIB__ __CALLEE__    getline_callee(char **lineptr, size_t *n, FILE *stream);
extern int    __LIB__ __CALLEE__    obstack_vprintf_callee(struct obstack *ob, char *format, void *arg);
extern FILE   __LIB__ __CALLEE__   *open_memstream_callee(char **bufp, size_t *sizep);
extern int    __LIB__ __CALLEE__    putc_callee(int c, FILE *stream);
extern int    __LIB__ __CALLEE__    ungetc_callee(int c, FILE *stream);
extern int    __LIB__ __CALLEE__    vasprintf_callee(char **ptr, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vfprintf_callee(FILE *stream, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vfscanf_callee(FILE *stream, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vprintf_callee(char *format, void *arg);
extern int    __LIB__ __CALLEE__    vscanf_callee(char *format, void *arg);
extern int    __LIB__ __CALLEE__    vsnprintf_callee(char *s, size_t n, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vsprintf_callee(char *s, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vsscanf_callee(char *s, char *format, void *arg);

extern int    __LIB__ __CALLEE__    fgetpos_unlocked_callee(FILE *stream, fpos_t *pos);
extern char   __LIB__ __CALLEE__   *fgets_unlocked_callee(char *s, int n, FILE *stream);
extern FILE   __LIB__ __CALLEE__   *fopen_unlocked_callee(const char *filename, const char *mode);
extern int    __LIB__ __CALLEE__    fputc_unlocked_callee(int c, FILE *stream);
extern int    __LIB__ __CALLEE__    fputs_unlocked_callee(char *s, FILE *stream);
extern size_t __LIB__ __CALLEE__    fread_unlocked_callee(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern FILE   __LIB__ __CALLEE__   *freopen_unlocked_callee(char *filename, char *mode, FILE *stream);
extern int    __LIB__ __CALLEE__    fseek_unlocked_callee(FILE *stream, long offset, int whence);
extern int    __LIB__ __CALLEE__    fsetpos_unlocked_callee(FILE *stream, fpos_t *pos);
extern size_t __LIB__ __CALLEE__    fwrite_unlocked_callee(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern size_t __LIB__ __CALLEE__    getdelim_unlocked_callee(char **lineptr, size_t *n, int delim, FILE *stream);
extern size_t __LIB__ __CALLEE__    getline_unlocked_callee(char **lineptr, size_t *n, FILE *stream);
extern int    __LIB__ __CALLEE__    putc_unlocked_callee(int c, FILE *stream);
extern int    __LIB__ __CALLEE__    ungetc_unlocked_callee(int c, FILE *stream);
extern int    __LIB__ __CALLEE__    vfprintf_unlocked_callee(FILE *stream, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vfscanf_unlocked_callee(FILE *stream, char *format, void *arg);
extern int    __LIB__ __CALLEE__    vprintf_unlocked_callee(char *format, void *arg);
extern int    __LIB__ __CALLEE__    vscanf_unlocked_callee(char *format, void *arg);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define _fmemopen_(a,b,c)           _fmemopen__callee(a,b,c)
#define fgetpos(a,b)                fgetpos_callee(a,b)
#define fgets(a,b,c)                fgets_callee(a,b,c)
#define fmemopen(a,b,c)             fmemopen_callee(a,b,c)
#define fopen(a,b)                  fopen_callee(a,b)
#define fputc(a,b)                  fputc_callee(a,b)
#define fputs(a,b)                  fputs_callee(a,b)
#define fread(a,b,c,d)              fread_callee(a,b,c,d)
#define freopen(a,b,c)              freopen_callee(a,b,c)
#define fseek(a,b,c)                fseek_callee(a,b,c)
#define fsetpos(a,b)                fsetpos_callee(a,b)
#define fwrite(a,b,c,d)             fwrite_callee(a,b,c,d)
#define getdelim(a,b,c,d)           getdelim_callee(a,b,c,d)
#define getline(a,b,c)              getline_callee(a,b,c)
#define obstack_vprintf(a,b,c)      obstack_vprintf_callee(a,b,c)
#define open_memstream(a,b)         open_memstream_callee(a,b)
#define putc(a,b)                   putc_callee(a,b)
#define ungetc(a,b)                 ungetc_callee(a,b)
#define vasprintf(a,b,c)            vasprintf_callee(a,b,c)
#define vfprintf(a,b,c)             vfprintf_callee(a,b,c)
#define vfscanf(a,b,c)              vfscanf_callee(a,b,c)
#define vprintf(a,b)                vprintf_callee(a,b)
#define vscanf(a,b)                 vscanf_callee(a,b)
#define vsnprintf(a,b,c,d)          vsnprintf_callee(a,b,c,d)
#define vsprintf(a,b,c)             vsprintf_callee(a,b,c)
#define vsscanf(a,b,c)              vsscanf_callee(a,b,c)

#define fgetpos_unlocked(a,b)       fgetpos_unlocked_callee(a,b)
#define fgets_unlocked(a,b,c)       fgets_unlocked_callee(a,b,c)
#define fopen_unlocked(a,b)         fopen_unlocked_callee(a,b)
#define fputc_unlocked(a,b)         fputc_unlocked_callee(a,b)
#define fputs_unlocked(a,b)         fputs_unlocked_callee(a,b)
#define fread_unlocked(a,b,c,d)     fread_unlocked_callee(a,b,c,d)
#define freopen_unlocked(a,b,c)     freopen_unlocked_callee(a,b,c)
#define fseek_unlocked(a,b,c)       fseek_unlocked_callee(a,b,c)
#define fsetpos_unlocked(a,b)       fsetpos_unlocked_callee(a,b)
#define fwrite_unlocked(a,b,c,d)    fwrite_unlocked_callee(a,b,c,d)
#define getdelim_unlocked(a,b,c,d)  getdelim_unlocked_callee(a,b,c,d)
#define getline_unlocked(a,b,c)     getline_unlocked_callee(a,b,c)
#define putc_unlocked(a,b)          putc_unlocked_callee(a,b)
#define ungetc_unlocked(a,b)        ungetc_unlocked_callee(a,b)
#define vfprintf_unlocked(a,b,c)    vfprintf_unlocked_callee(a,b,c)
#define vfscanf_unlocked(a,b,c)     vfscanf_unlocked_callee(a,b,c)
#define vprintf_unlocked(a,b)       vprintf_unlocked_callee(a,b)
#define vscanf_unlocked(a,b)        vscanf_unlocked_callee(a,b)

#endif

#endif
