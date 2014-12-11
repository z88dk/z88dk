
; int fzx_char_metrics(struct fzx_cmetric *m, uchar c)

SECTION code_font_fzx

PUBLIC _fzx_char_metrics

_fzx_char_metrics:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld a,l
   
   push ix
   
   call asm_fzx_char_metrics
   
   pop ix
   ret
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_char_metrics.asm"
