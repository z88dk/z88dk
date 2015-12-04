
; int fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_write_justified_callee

EXTERN asm_fzx_write_justified

fzx_write_justified_callee:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   push af
   
   jp asm_fzx_write_justified
