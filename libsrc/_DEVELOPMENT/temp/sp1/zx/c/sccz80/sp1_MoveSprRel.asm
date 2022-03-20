; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_MoveSprRel

EXTERN asm_sp1_MoveSprRel

sp1_MoveSprRel:

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl

   push ix	; save IX, IY to BC', DE'
   push iy
   exx
   pop de
   pop bc
   exx

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
   push bc	; save old IX, IY
   push de
   exx

   call asm_sp1_MoveSprRel

   pop iy	; restore them
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_MoveSprRel
defc _sp1_MoveSprRel = sp1_MoveSprRel
ENDIF

