
; void *zx_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

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

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_pxy2saddr
defc _zx_pxy2saddr = zx_pxy2saddr
ENDIF

