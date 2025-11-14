; void *tshr_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cxy2saddr_callee

EXTERN asm_zx_cxy2saddr

tshr_cxy2saddr_callee:

   pop hl
   ex (sp),hl

   jp asm_zx_cxy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_cxy2saddr_callee
defc _tshr_cxy2saddr_callee = tshr_cxy2saddr_callee
ENDIF

