; uchar__CALLEE__ sp1_ScreenAttr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ScreenAttr_callee

EXTERN asm_sp1_ScreenAttr

sp1_ScreenAttr_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

;   jp asm_sp1_ScreenAttr
   push ix
   call asm_sp1_ScreenAttr
   pop ix
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_ScreenAttr_callee
defc _sp1_ScreenAttr_callee = sp1_ScreenAttr_callee
ENDIF

