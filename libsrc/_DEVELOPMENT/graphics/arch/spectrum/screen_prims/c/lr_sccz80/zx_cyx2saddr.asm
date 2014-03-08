
; void *zx_cyx2saddr(uchar row, uchar col)

XLIB zx_cyx2saddr

LIB asm_zx_cyx2saddr

zx_cyx2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   jp asm_zx_cyx2saddr
