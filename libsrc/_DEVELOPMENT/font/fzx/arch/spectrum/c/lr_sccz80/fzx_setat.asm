
; int fzx_setat(uchar y, uchar x)

XLIB fzx_setat

LIB asm_fzx_setat

fzx_setat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   jp asm_fzx_setat
