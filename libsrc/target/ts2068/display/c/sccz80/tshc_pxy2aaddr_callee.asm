; void *tshc_pxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_pxy2aaddr_callee

EXTERN asm_tshc_pxy2aaddr

tshc_pxy2aaddr_callee:

   pop hl
   ex (sp),hl

   jp asm_tshc_pxy2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_pxy2aaddr_callee
defc _tshc_pxy2aaddr_callee = tshc_pxy2aaddr_callee
ENDIF

