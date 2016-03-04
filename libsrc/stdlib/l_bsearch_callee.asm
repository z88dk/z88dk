; void __CALLEE__ *l_bsearch_callee(void *key, void *base, unsigned int n, void *cmp)
; 01.2007 aralbrec

PUBLIC l_bsearch_callee
PUBLIC _l_bsearch_callee
PUBLIC ASMDISP_L_BSEARCH_CALLEE
EXTERN Lbsearch, l_jpiy

.l_bsearch_callee
._l_bsearch_callee

   pop af
   pop iy
   pop hl
   pop de
   pop bc
   push af

.centry

   ld ix,compare
   jp Lbsearch

.compare

   push de
   push bc
   push hl
   call l_jpiy
   ld a,l
   pop hl
   pop bc
   pop de
   ret

DEFC ASMDISP_L_BSEARCH_CALLEE = # centry - l_bsearch_callee
