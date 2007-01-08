; CALLER linkage for function pointers

XLIB strchr
LIB strchr_callee
XREF ASMDISP_STRCHR_CALLEE

.strchr

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchr_callee + ASMDISP_STRCHR_CALLEE

