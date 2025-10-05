
; void *zx_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cxy2saddr

EXTERN asm_zx_cxy2saddr

zx_cxy2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   ld h,e
   jp asm_zx_cxy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_cxy2saddr
defc _zx_cxy2saddr = zx_cxy2saddr
ENDIF

