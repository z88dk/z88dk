
; long labs(long j)

SECTION code_clib
SECTION code_stdlib

PUBLIC _labs

EXTERN asm_labs

_labs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_labs
