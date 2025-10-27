; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateSpr

EXTERN asm_sp1_IterateUpdateSpr

sp1_IterateUpdateSpr:

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
   
;   jp asm_sp1_IterateUpdateSpr
   exx
   push bc	; save old IX
   exx
   call asm_sp1_IterateUpdateSpr
   pop ix	; restore it
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_IterateUpdateSpr
defc _sp1_IterateUpdateSpr = sp1_IterateUpdateSpr
ENDIF

