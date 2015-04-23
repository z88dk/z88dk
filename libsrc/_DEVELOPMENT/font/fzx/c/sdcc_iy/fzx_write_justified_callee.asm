
; int fzx_write_justified_callee(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_write_justified_callee

_fzx_write_justified_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "font/fzx/z80/asm_fzx_write_justified.asm"
