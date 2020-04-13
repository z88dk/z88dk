
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pxy2aaddr_callee

EXTERN asm_zx_pxy2aaddr

zx_pxy2aaddr_callee:

   pop hl
   pop de
   ex (sp),hl

   ld h,e   
   jp asm_zx_pxy2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_pxy2aaddr_callee
defc _zx_pxy2aaddr_callee = zx_pxy2aaddr_callee
ENDIF

