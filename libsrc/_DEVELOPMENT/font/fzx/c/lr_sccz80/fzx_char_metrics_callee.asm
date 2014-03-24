
; int fzx_char_metrics(struct fzx_cmetric *m, uchar c)

XDEF fzx_char_metrics

fzx_char_metrics:

   pop af
   pop hl
   pop de
   push af
   
   ld a,l
   
   INCLUDE "font/fzx/z80/asm_fzx_char_metrics.asm"
