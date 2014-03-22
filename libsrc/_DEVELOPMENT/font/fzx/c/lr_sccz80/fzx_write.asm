
; int fzx_write(void *buf, uint len)

XLIB fzx_write

LIB asm_fzx_write

fzx_write:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_fzx_write
