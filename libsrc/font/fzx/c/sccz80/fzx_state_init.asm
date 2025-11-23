
; void fzx_state_init(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_state_init

EXTERN asm_fzx_state_init

fzx_state_init:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_fzx_state_init
