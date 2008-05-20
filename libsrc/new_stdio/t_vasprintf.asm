; wrapper for function pointers

XLIB t_vasprintf

LIB t_vasprintf_callee
XREF ASMDISP_VASPRINTF_CALLEE

.t_vasprintf

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
   
   jp t_vasprintf_callee + ASMDISP_VASPRINTF_CALLEE
