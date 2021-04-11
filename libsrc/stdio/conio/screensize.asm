; CALLER linkage for function pointers

SECTION code_clib
PUBLIC screensize
PUBLIC _screensize
EXTERN asm_screensize

.screensize
._screensize

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   jp asm_screensize
