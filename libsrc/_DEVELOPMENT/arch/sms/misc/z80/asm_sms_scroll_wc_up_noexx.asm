SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_scroll_wc_up_noexx

EXTERN asm_sms_scroll_wc_up

asm_sms_scroll_wc_up_noexx:

   ; alternate entry point to asm_sms_scroll_up_wc that does
   ; not alter the exx set
   ;
   ; enter :  e = number of rows to scroll upward by
   ;         hl = background character
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl
   
   exx
   push bc
   exx
   
   call asm_sms_scroll_wc_up
   
   exx
   pop bc
   exx

   ret
