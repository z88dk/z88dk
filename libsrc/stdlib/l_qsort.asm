; CALLER linkage for function pointers

XLIB l_qsort
LIB l_qsort_callee
XREF ASMDISP_L_QSORT_CALLEE

.l_qsort

   pop de
   pop iy
   pop hl
   pop bc
   push bc
   push hl
   push hl
   push de
   
   jp l_qsort_callee + ASMDISP_L_QSORT_CALLEE
