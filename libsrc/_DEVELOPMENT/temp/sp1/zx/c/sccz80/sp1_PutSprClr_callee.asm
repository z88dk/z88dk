; void __CALLEE__ sp1_PutSprClr_callee(uchar **sprdest, struct sp1_ap *src, uchar n)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PutSprClr_callee

EXTERN asm_sp1_PutSprClr

sp1_PutSprClr_callee:

   pop hl
   pop bc
   ld b,c
   pop de
   ex (sp),hl

   jp asm_sp1_PutSprClr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_PutSprClr_callee
defc _sp1_PutSprClr_callee = sp1_PutSprClr_callee
ENDIF

