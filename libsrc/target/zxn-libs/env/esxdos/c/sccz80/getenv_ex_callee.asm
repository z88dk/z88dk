; char *getenv_ex(const char *filename, const char *name)

SECTION code_env

PUBLIC getenv_ex_callee

EXTERN asm_getenv_ex

getenv_ex_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_getenv_ex
