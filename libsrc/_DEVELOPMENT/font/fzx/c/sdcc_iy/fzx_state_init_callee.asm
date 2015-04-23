
; void fzx_state_init_callee(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window)

SECTION code_font_fzx

PUBLIC _fzx_state_init_callee

_fzx_state_init_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

   INCLUDE "font/fzx/z80/asm_fzx_state_init.asm"
