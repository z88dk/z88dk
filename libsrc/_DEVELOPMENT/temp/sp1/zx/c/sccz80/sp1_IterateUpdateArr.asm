; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateArr

EXTERN asm_sp1_IterateUpdateArr

sp1_IterateUpdateArr:

   push ix	; save IX to BC'
   exx
   pop bc
   exx

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
;   jp asm_sp1_IterateUpdateArr
   exx
   push bc	; save old IX
   exx
   call asm_sp1_IterateUpdateArr
   pop ix	; restore it
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_IterateUpdateArr
defc _sp1_IterateUpdateArr = sp1_IterateUpdateArr
ENDIF

