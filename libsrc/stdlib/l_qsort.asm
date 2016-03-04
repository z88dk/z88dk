; CALLER linkage for function pointers

PUBLIC l_qsort
PUBLIC _l_qsort
EXTERN l_qsort_callee
EXTERN ASMDISP_L_QSORT_CALLEE

.l_qsort
._l_qsort

   pop de
   pop iy
   pop hl
   pop bc
   push bc
   push hl
   push hl
   push de
   
   jp l_qsort_callee + ASMDISP_L_QSORT_CALLEE
