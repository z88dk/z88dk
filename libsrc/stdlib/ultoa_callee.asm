; char __CALLEE__ *ultoa_callee(char *s, unsigned long num)
; convert unsigned long to string and store in s
; 04.2007 aralbrec

XLIB ultoa_callee

LIB ltoa_callee
XREF ASMDISP2_LTOA_CALLEE

.ultoa_callee

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   push bc
   jp ltoa_callee + ASMDISP2_LTOA_CALLEE
