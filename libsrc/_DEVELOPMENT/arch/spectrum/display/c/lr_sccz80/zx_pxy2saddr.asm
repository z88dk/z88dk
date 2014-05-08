
; void *zx_pxy2saddr(uchar x, uchar y)

PUBLIC zx_pxy2saddr

EXTERN asm_zx_pxy2saddr

zx_pxy2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp asm_zx_pxy2saddr
