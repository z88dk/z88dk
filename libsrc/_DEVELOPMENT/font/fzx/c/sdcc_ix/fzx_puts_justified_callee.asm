
; int fzx_puts_justified_callee(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_puts_justified_callee, l0_fzx_puts_justified_callee

_fzx_puts_justified_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

l0_fzx_puts_justified_callee:

   push de
   ex (sp),ix
   
   call asm_fzx_puts_justified
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_puts_justified.asm"
