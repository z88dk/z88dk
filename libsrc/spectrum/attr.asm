; uint attr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB attr

LIB attr_callee
XREF ASMDISP_ATTR_CALLEE

.attr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld h,l
   ld l,e
   jp attr_callee + ASMDISP_ATTR_CALLEE
