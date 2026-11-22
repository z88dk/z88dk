
; void fzx_state_init_callee(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_state_init_callee

EXTERN asm_fzx_state_init

_fzx_state_init_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

   jp asm_fzx_state_init
