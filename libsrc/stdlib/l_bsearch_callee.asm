; void __CALLEE__ *l_bsearch_callee(void *key, void *base, unsigned int n, void *cmp)
; 01.2007 aralbrec

SECTION code_clib
PUBLIC l_bsearch_callee
PUBLIC _l_bsearch_callee
PUBLIC asm_l_bsearch

IF __CPU_INTEL__ || __CPU_GBZ80__
  EXTERN Lbsearch, l_jpiy_8080, l_setix_8080, l_setiy_8080
ELSE
  EXTERN Lbsearch, l_jpiy, l_setix, l_setiy
ENDIF

.l_bsearch_callee
._l_bsearch_callee

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
   push af

.asm_l_bsearch

   push hl
   ld hl,compare

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_setix_8080
ELSE
   call l_setix
ENDIF

   pop hl
   jp Lbsearch

.compare

   push de
   push bc
   push hl

IF __CPU_INTEL__ || __CPU_GBZ80__
   call l_jpiy_8080
ELSE
   call l_jpiy
ENDIF

   ld a,l
   pop hl
   pop bc
   pop de
   ret

