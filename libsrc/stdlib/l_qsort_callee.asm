; void __CALLEE__ l_qsort_callee(void *base, unsigned int size, void *cmp)
; 01.2007 aralbrec

PUBLIC l_qsort_callee
PUBLIC _l_qsort_callee
PUBLIC ASMDISP_L_QSORT_CALLEE
EXTERN Lqsort, l_jpiy

.l_qsort_callee
._l_qsort_callee

   pop de
   pop iy
   pop hl
   pop bc
   push de
   
.centry

   ld ix,compare
   jp Lqsort

.compare

   push hl
   push de
   push bc
   call l_jpiy
   ld a,l
   pop bc
   pop de
   pop hl
   ret

DEFC ASMDISP_L_QSORT_CALLEE = # centry - l_qsort_callee
