; char *getenv_ex(const char *filename, const char *name)

SECTION code_env

PUBLIC _getenv_ex_callee
PUBLIC l0_getenv_ex_callee

EXTERN asm_getenv_ex

_getenv_ex_callee:

   pop hl
   pop de
   ex (sp),hl

l0_getenv_ex_callee:

   push iy
   
   call asm_getenv_ex
   
   pop iy
   ret
