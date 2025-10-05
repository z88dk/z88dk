
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfscanf_unlocked

EXTERN asm_vfscanf_unlocked

_vfscanf_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_vfscanf_unlocked
