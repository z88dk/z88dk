
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfscanf_unlocked

EXTERN l0_vfscanf_unlocked_callee

_vfscanf_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_vfscanf_unlocked_callee
