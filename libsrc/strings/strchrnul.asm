; CALLER linkage for function pointers

XLIB strchrnul
LIB strchrnul_callee
XREF ASMDISP_STRCHRNUL_CALLEE

.strchrnul

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchrnul_callee + ASMDISP_STRCHRNUL_CALLEE
