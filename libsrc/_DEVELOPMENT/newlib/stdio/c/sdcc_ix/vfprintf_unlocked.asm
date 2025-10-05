
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfprintf_unlocked

EXTERN l0_vfprintf_unlocked_callee

_vfprintf_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_vfprintf_unlocked_callee
