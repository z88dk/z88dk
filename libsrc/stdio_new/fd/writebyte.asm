; CALLER linkage for function pointers

XLIB writebyte

LIB writebyte_callee
XREF ASMDISP_WRITEBYTE_CALLEE

.writebyte

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   ld b,c
   jp writebyte_callee + ASMDISP_WRITEBYTE_CALLEE
