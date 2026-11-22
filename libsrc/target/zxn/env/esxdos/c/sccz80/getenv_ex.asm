; char *getenv_ex(const char *filename, const char *name)

SECTION code_env

PUBLIC getenv_ex

EXTERN asm_getenv_ex

getenv_ex:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_getenv_ex
