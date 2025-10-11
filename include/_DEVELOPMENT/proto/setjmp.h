include(__link__.m4)

#ifndef __SETJMP_H__
#define __SETJMP_H__

#define setjmp(env)         l_setjmp(&(env))
#define longjmp(env, val)   l_longjmp(&(env), val)


typedef struct
{

   void *ix;
   void *iy;
   void *sp;
   void *pc;

} jmp_buf;



// must not use callee or fastcall linkage

__OPROTO(,,int,,l_setjmp,jmp_buf *env)
__SPROTO(,,void,,l_longjmp,jmp_buf *env,int val)

#endif
