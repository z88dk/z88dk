; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_MoveSprAbs

EXTERN asm_sp1_MoveSprAbs

sp1_MoveSprAbs:

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

;   jp asm_sp1_MoveSprAbs
   exx
   push bc	; save old IX, IY
   push de
   exx

   call asm_sp1_MoveSprAbs

   pop iy	; restore them
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_MoveSprAbs
defc _sp1_MoveSprAbs = sp1_MoveSprAbs
ENDIF

