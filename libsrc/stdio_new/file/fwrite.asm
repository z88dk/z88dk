; CALLER linkage for function pointers
; 06.2008 aralbrec

XLIB fwrite

LIB fwrite_callee
XREF ASMDISP_FWRITE_CALLEE

.fwrite

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push hl
   push af
   
   jp fwrite_callee + ASMDISP_FWRITE_CALLEE
