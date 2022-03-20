; uint __CALLEE__ sp1_AddColSpr_callee(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_AddColSpr_callee

EXTERN asm_sp1_AddColSpr

sp1_AddColSpr_callee:

   pop af
   pop hl
   ld h,l
   pop bc
   pop de
   ld l,e
   pop de

   push ix	; save IX in BC'
   exx
   pop bc
   exx

   pop ix
   push af

;   jp asm_sp1_AddColSpr
   exx
   push bc	; save old IX
   exx

   call asm_sp1_AddColSpr

   pop ix	; restore it
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_AddColSpr_callee
defc _sp1_AddColSpr_callee = sp1_AddColSpr_callee
ENDIF

