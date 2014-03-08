
; void *zx_saddrpright(void *saddr, uint bitmask)

XLIB zx_saddrpright

LIB asm_zx_saddrpright

zx_saddrpright:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_zx_saddrpright
