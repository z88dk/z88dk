
; void *zx_cyx2aaddr(uchar row, uchar col)

PUBLIC zx_cyx2aaddr

EXTERN asm_zx_cyx2aaddr

zx_cyx2aaddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   jp asm_zx_cyx2aaddr
