; char *env_getenv(unsigned char handle,const char *name,char *val,unsigned int valsz,void *buf,unsigned int bufsz)

SECTION code_env

PUBLIC _env_getenv_callee
PUBLIC l0_env_getenv_callee

EXTERN asm_env_getenv

_env_getenv_callee:

   pop af
   dec sp
   pop de
   ld e,d
   exx
   pop hl
   pop de
   pop bc
   exx
   pop hl
   pop bc
   exx
   push af
   
l0_env_getenv_callee:

   push ix
   push iy
   
   call asm_env_getenv
   
   pop iy
   pop ix
   ret
