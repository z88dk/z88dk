; CALLER linkage for function pointers

SECTION code_clib
PUBLIC l_qsort
PUBLIC _l_qsort
EXTERN asm_l_qsort

IF __CPU_INTEL__ || __CPU_GBZ80__
  EXTERN l_setiy_8080
ELSE
  EXTERN l_setiy
ENDIF

.l_qsort
._l_qsort

   pop de
   pop hl

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_setiy_8080
ELSE
   call l_setiy
ENDIF

   pop hl
   pop bc
   push bc
   push hl
   push hl
   push de
   
   jp asm_l_qsort
