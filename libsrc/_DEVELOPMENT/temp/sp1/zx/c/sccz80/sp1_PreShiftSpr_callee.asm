; void __CALLEE__ *sp1_PreShiftSpr_callee(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PreShiftSpr_callee

EXTERN asm_sp1_PreShiftSpr

sp1_PreShiftSpr_callee:

   push ix	; save IX to BC'
   exx
   pop bc
   exx

   pop af
   pop bc
   pop iy
   pop de
   pop hl
   ld b,l
   pop hl
   pop ix
   push af
   ld a,ixl
   ld h,a
   ld a,c

;   jp asm_sp1_PreShiftSpr
   exx
   push bc	; save old IX
   exx
   call asm_sp1_PreShiftSpr
   pop ix	; restore it
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_PreShiftSpr_callee
defc _sp1_PreShiftSpr_callee = sp1_PreShiftSpr_callee
ENDIF

