
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

XLIB zx_pxy2aaddr

LIB asm_zx_pxy2aaddr

zx_pxy2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp asm_zx_pxy2aaddr
