
; int fzx_char_metrics(struct fzx_cmetric *m, uchar c)

XDEF fzx_char_metrics

fzx_char_metrics:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,l
   
   push ix
   
   call asm_fzx_char_metrics
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fzx_char_metrics.asm"
