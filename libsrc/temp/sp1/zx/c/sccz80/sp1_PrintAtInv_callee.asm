; void __CALLEE__ sp1_PrintAtInv_callee(uchar row, uchar col, uchar colour, uint tile)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PrintAtInv_callee

EXTERN asm_sp1_PrintAtInv

sp1_PrintAtInv_callee:

   pop af
   pop bc
   pop hl
   pop de
   ld d,l
   pop hl
   push af
   ld a,d
   ld d,l

;   jp asm_sp1_PrintAtInv
   push ix
   call asm_sp1_PrintAtInv
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_PrintAtInv_callee
defc _sp1_PrintAtInv_callee = sp1_PrintAtInv_callee
ENDIF

