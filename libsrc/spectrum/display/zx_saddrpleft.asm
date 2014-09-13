; uchar *zx_saddrpleft(void *pixeladdr, uchar *mask)
; CALLER linkage for function pointers

XLIB zx_saddrpleft

LIB zx_saddrpleft_callee
XREF ASMDISP_ZX_SADDRPLEFT_CALLEE

.zx_saddrpleft

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp zx_saddrpleft_callee + ASMDISP_ZX_SADDRPLEFT_CALLEE
