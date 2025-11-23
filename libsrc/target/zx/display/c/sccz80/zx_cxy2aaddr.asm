
; void *zx_cxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cxy2aaddr

EXTERN asm_zx_cxy2aaddr

zx_cxy2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp asm_zx_cxy2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_cxy2aaddr
defc _zx_cxy2aaddr = zx_cxy2aaddr
ENDIF

