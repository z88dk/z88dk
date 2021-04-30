; void in_MouseAMXInit(uchar xvector, uchar yvector)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseAMXInit
PUBLIC _in_MouseAMXInit

EXTERN asm_in_MouseAMXInit

.in_MouseAMXInit
._in_MouseAMXInit

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   ld b,e
   jp asm_in_MouseAMXInit
