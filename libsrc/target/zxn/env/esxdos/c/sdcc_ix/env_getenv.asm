; char *env_getenv(unsigned char handle,const char *name,char *val,unsigned int valsz,void *buf,unsigned int bufsz)

SECTION code_env

PUBLIC _env_getenv

EXTERN l0_env_getenv_callee

_env_getenv:

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
   
   push bc
   push hl
   exx
   push bc
   push de
   push hl
   exx
   push de
   inc sp
   push af
   
   exx
   jp l0_env_getenv_callee
