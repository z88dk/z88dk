
; int fzx_setat(uchar y, uchar x)

SECTION code_font_fzx

PUBLIC fzx_setat

EXTERN asm_fzx_setat

fzx_setat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   jp asm_fzx_setat
