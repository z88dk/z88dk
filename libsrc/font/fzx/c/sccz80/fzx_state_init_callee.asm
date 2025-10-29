
; void fzx_state_init(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_state_init_callee

EXTERN asm_fzx_state_init

fzx_state_init_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_fzx_state_init
