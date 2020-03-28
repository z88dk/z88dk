; uchar *zx_saddrpleft(void *pixeladdr, uchar *mask)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_saddrpleft
PUBLIC _zx_saddrpleft

EXTERN zx_saddrpleft_callee
EXTERN ASMDISP_ZX_SADDRPLEFT_CALLEE

.zx_saddrpleft
._zx_saddrpleft

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp zx_saddrpleft_callee + ASMDISP_ZX_SADDRPLEFT_CALLEE
