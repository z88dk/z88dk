
; int fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_write_justified

EXTERN l0_fzx_write_justified_callee

_fzx_write_justified:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push bc
   push af

   jp l0_fzx_write_justified_callee
