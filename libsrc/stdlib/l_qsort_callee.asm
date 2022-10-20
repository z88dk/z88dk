; void __CALLEE__ l_qsort_callee(void *base, unsigned int size, void *cmp)
; 01.2007 aralbrec

SECTION code_clib
PUBLIC l_qsort_callee
PUBLIC _l_qsort_callee
PUBLIC asm_l_qsort

IF __CPU_INTEL__ || __CPU_GBZ80__
  EXTERN Lqsort, l_jpiy_8080, l_setix_8080, l_setiy_8080
ELSE
  EXTERN Lqsort, l_jpiy, l_setix, l_setiy
ENDIF


.l_qsort_callee
._l_qsort_callee

   pop de
   pop hl

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_setiy_8080
ELSE
   call l_setiy
ENDIF

   pop hl
   pop bc
   push de
   
.asm_l_qsort

   push hl
   ld hl,compare

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_setix_8080
ELSE
   call l_setix
ENDIF

   pop hl
   jp Lqsort

.compare

   push hl
   push de
   push bc

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_jpiy_8080
ELSE
   call l_jpiy
ENDIF

   ld a,l
   pop bc
   pop de
   pop hl
   ret

