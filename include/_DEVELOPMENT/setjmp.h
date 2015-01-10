
#ifndef _SETJMP_H
#define _SETJMP_H

#define setjmp(env)         l_setjmp(&(env))
#define longjmp(env, val)   l_longjmp(&(env), val)

#ifdef __SDCC

// SDCC

typedef struct
{

   void *ix;
   void *sp;
   void *pc;

} jmp_buf;

extern int          l_setjmp(jmp_buf *env);
extern void         l_longjmp(jmp_buf *env, int val);

#else

// SCCZ80
// must not use callee or fastcall linkage

typedef struct
{

   void *sp;
   void *pc;

} jmp_buf;

extern int  __LIB__ l_setjmp(jmp_buf *env);
extern void __LIB__ l_longjmp(jmp_buf *env, int val);

#endif

#endif
