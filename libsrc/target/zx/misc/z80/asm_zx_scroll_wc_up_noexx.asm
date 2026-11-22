
SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_wc_up_noexx

EXTERN asm_zx_scroll_wc_up

asm_zx_scroll_wc_up_noexx:

   ; alternate entry point to asm_zx_scroll_up_wc that does
   ; not alter the exx set
   ;
   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl
   
   exx
   push bc
   push de
   push hl
   exx
   
   call asm_zx_scroll_wc_up
   
   pop hl
   pop de
   pop bc
   exx
   
   ret
