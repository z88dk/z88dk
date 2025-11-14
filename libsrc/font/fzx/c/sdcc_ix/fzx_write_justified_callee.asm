
; int fzx_write_justified_callee(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_write_justified_callee, l0_fzx_write_justified_callee

EXTERN asm_fzx_write_justified

_fzx_write_justified_callee:

   pop hl
   exx
   pop bc
   exx
   pop de
   pop bc
   ex (sp),hl

l0_fzx_write_justified_callee:
   
   exx
   push bc
   exx
   ex (sp),ix
   
   call asm_fzx_write_justified
   
   pop ix
   ret
