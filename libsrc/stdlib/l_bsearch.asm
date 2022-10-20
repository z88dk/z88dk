; CALLER linkage for function pointers

SECTION code_clib
PUBLIC l_bsearch
PUBLIC _l_bsearch
EXTERN asm_l_bsearch

IF __CPU_INTEL__ || __CPU_GBZ80__
  EXTERN l_setiy_8080
ELSE
  EXTERN l_setiy
ENDIF

.l_bsearch
._l_bsearch

   pop af
   pop hl

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_setiy_8080
ELSE
   call l_setiy
ENDIF

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push hl
   push af
   
   jp asm_l_bsearch
