; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_MoveSprRel

EXTERN asm_sp1_MoveSprRel

sp1_MoveSprRel:

   push ix	; save IX to BC'
   exx
   pop bc
   exx

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl
   pop iy
   pop ix
   push hl
   push hl
   push hl
   push hl
   push de
   push bc
   push de
   push af
   
;   jp asm_sp1_MoveSprRel
   exx
   push bc	; save old IX
   exx
   call asm_sp1_MoveSprRel
   pop ix	; restore it
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_MoveSprRel
defc _sp1_MoveSprRel = sp1_MoveSprRel
ENDIF

