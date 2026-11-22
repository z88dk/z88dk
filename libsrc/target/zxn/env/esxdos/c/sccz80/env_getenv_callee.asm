; char *env_getenv(unsigned char handle,const char *name,char *val,unsigned int valsz,void *buf,unsigned int bufsz)

SECTION code_env

PUBLIC env_getenv_callee

EXTERN asm_env_getenv

env_getenv_callee:

   pop af
   pop bc
   pop hl
   exx
   pop bc
   pop de
   pop hl
   exx
   pop de
   exx
   push af

   jp asm_env_getenv
