; char *env_getenv(unsigned char handle,const char *name,char *val,unsigned int valsz,void *buf,unsigned int bufsz)

SECTION code_env

PUBLIC env_getenv

EXTERN asm_env_getenv

env_getenv:

   pop af
   pop bc
   pop hl
   exx
   pop bc
   pop de
   pop hl
   exx
   pop de
   
   push de
   exx
   push hl
   push de
   push bc
   exx
   push hl
   push bc
   push af

   exx
   jp asm_env_getenv
