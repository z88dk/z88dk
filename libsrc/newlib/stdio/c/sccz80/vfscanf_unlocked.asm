
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vfscanf_unlocked

EXTERN asm_vfscanf_unlocked

vfscanf_unlocked:

   pop af
   pop bc
   pop de
   pop ix
   
   push hl
   push de
   push bc
   push af
   
   jp asm_vfscanf_unlocked
