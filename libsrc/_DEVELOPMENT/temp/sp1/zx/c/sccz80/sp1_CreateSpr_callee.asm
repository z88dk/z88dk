; struct sp1_ss __CALLEE__ *sp1_CreateSpr_callee(void *drawf, uchar type, uchar height, int graphic, uchar plane)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_CreateSpr_callee

EXTERN asm_sp1_CreateSpr

sp1_CreateSpr_callee:

;   pop ix	; save ret addr
   exx
   pop bc
   exx

   pop bc
   pop hl
   pop de
   ld a,e
   pop de
   ld b,e
   pop de

;   push ix	; restore ret addr
   exx
   push bc
   exx

;   jp asm_sp1_CreateSpr
   push ix
   call asm_sp1_CreateSpr
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_CreateSpr_callee
defc _sp1_CreateSpr_callee = sp1_CreateSpr_callee
ENDIF

