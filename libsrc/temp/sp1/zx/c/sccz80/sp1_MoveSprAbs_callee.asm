; void __CALLEE__ sp1_MoveSprAbs_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_MoveSprAbs_callee

EXTERN asm_sp1_MoveSprAbs

sp1_MoveSprAbs_callee:

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
   push af

;   jp asm_sp1_MoveSprAbs
   exx
   push bc	; save old IX
   exx

   call asm_sp1_MoveSprAbs

   pop ix	; restore it
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_MoveSprAbs_callee
defc _sp1_MoveSprAbs_callee = sp1_MoveSprAbs_callee
ENDIF

