
; void *zx_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pxy2saddr_callee

EXTERN asm_zx_pxy2saddr

zx_pxy2saddr_callee:

   pop hl
   pop de
   ex (sp),hl

   ld h,e
   jp asm_zx_pxy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_pxy2saddr_callee
defc _zx_pxy2saddr_callee = zx_pxy2saddr_callee
ENDIF

