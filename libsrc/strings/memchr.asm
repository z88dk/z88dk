; CALLER linkage for function pointers

XLIB memchr
LIB memchr_callee
XREF ASMDISP_MEMCHR_CALLEE

.memchr

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memchr_callee + ASMDISP_MEMCHR_CALLEE - 1
