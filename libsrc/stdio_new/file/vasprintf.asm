; wrapper for function pointers

XLIB vasprintf

LIB vasprintf_callee
XREF ASMDISP_VASPRINTF_CALLEE

.vasprintf

   pop hl
   pop bc
   pop de
   exx
   pop hl
   ld de,0
   push hl
   exx
   push de
   push bc
   push hl
   
   jp vasprintf_callee + ASMDISP_VASPRINTF_CALLEE
