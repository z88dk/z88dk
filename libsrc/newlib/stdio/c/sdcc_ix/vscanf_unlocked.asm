
; int vscanf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vscanf_unlocked

EXTERN l0_vscanf_unlocked_callee

_vscanf_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af

   jp l0_vscanf_unlocked_callee
