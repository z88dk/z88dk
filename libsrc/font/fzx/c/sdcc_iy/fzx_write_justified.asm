
; int fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_write_justified

EXTERN asm_fzx_write_justified

_fzx_write_justified:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push hl
   push af
   
   jp asm_fzx_write_justified
