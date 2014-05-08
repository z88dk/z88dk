
; int fzx_char_metrics(struct fzx_cmetric *m, uchar c)

PUBLIC _fzx_char_metrics

_fzx_char_metrics:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld a,l
   
   INCLUDE "font/fzx/z80/asm_fzx_char_metrics.asm"
