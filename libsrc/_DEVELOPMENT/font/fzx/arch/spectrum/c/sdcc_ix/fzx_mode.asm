
; int fzx_mode(int mode)

XDEF _fzx_mode

_fzx_mode:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "font/fzx/arch/spectrum/z80/asm_fzx_mode.asm"
