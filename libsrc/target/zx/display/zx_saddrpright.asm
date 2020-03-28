; uchar *zx_saddrpright(void *pixeladdr, uchar *mask)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_saddrpright
PUBLIC _zx_saddrpright

EXTERN zx_saddrpright_callee
EXTERN ASMDISP_ZX_SADDRPRIGHT_CALLEE

.zx_saddrpright
._zx_saddrpright

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp zx_saddrpright_callee + ASMDISP_ZX_SADDRPRIGHT_CALLEE
