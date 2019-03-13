; uint zx_saddr2px(void *pixeladdr, uchar mask)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_saddr2px
PUBLIC _zx_saddr2px

EXTERN zx_saddr2px_callee
EXTERN ASMDISP_ZX_SADDR2PX_CALLEE

.zx_saddr2px
._zx_saddr2px

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld a,e
   jp zx_saddr2px_callee + ASMDISP_ZX_SADDR2PX_CALLEE

