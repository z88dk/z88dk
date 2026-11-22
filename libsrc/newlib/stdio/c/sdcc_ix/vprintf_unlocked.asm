
; int vprintf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vprintf_unlocked

EXTERN l0_vprintf_unlocked_callee

_vprintf_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af

   jp l0_vprintf_unlocked_callee
