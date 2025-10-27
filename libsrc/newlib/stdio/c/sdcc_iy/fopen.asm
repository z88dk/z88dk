
; FILE *fopen(const char *filename, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fopen

EXTERN asm_fopen

_fopen:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_fopen
