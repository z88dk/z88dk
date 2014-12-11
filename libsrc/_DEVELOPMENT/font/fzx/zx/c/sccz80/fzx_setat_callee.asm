
; int fzx_setat(uchar y, uchar x)

SECTION code_font_fzx

PUBLIC fzx_setat_callee

fzx_setat_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld h,e
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_setat.asm"
