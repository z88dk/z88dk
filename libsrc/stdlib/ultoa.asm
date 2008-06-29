; CALLER linkage for function pointers

XLIB ultoa

LIB ultoa_callee
XREF ASMDISP_ULTOA_CALLEE

.ultoa

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push de
   push hl
   push hl
   push bc
   push af

   jp ultoa_callee + ASMDISP_ULTOA_CALLEE
