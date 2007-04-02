; char __CALLEE__ *utoa_callee(char *s, uint num)
; convert unsigned int to string and store in s
; 04.2007 aralbrec

XLIB utoa_callee

LIB itoa_callee
XREF ASMDISP2_ITOA_CALLEE

.utoa_callee

   pop hl
   pop de
   ex (sp),hl
   
   push hl
   jp itoa_callee + ASMDISP2_ITOA_CALLEE

