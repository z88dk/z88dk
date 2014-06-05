
PUBLIC asm0_zx_scroll

EXTERN asm_zx_scroll

asm0_zx_scroll:

   ; alternate entry point to asm_zx_scroll that does
   ; not alter the exx set
   ;
   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;
   ; uses  : af, bc, de, hl
   
   exx
   push bc
   push de
   push hl
   exx
   
   call asm_zx_scroll
   
   exx
   pop hl
   pop de
   pop bc
   exx
   
   ret
