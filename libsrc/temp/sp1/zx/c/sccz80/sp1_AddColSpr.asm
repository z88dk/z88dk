; uint sp1_AddColSpr(struct sp1_ss *s, uchar type, int graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_AddColSpr

EXTERN asm_sp1_AddColSpr

sp1_AddColSpr:

   push ix	; save IX in BC'
   exx
   pop bc
   exx

   pop af
   pop hl
   ld h,l
   pop bc
   pop de
   ld l,e
   pop de
   pop ix
   push hl
   push hl
   push de
   push bc
   push hl
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
PUBLIC _sp1_AddColSpr
defc _sp1_AddColSpr = sp1_AddColSpr
ENDIF

