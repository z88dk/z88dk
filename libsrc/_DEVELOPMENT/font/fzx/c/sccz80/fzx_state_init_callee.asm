
; void fzx_state_init(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window)

SECTION code_font_fzx

PUBLIC fzx_state_init_callee

fzx_state_init_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "font/fzx/z80/asm_fzx_state_init.asm"
