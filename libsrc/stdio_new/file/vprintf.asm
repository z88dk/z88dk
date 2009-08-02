; wrapper for function pointers

XLIB vprintf

LIB vfprintf_callee
XREF ASMDISP_VFPRINTF_CALLEE, _stdout

.vprintf

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   ld ix,(_stdout)
   jp vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
