; uchar sp1_ScreenAttr(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_ScreenAttr

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_ScreenAttr:

; Return colour at background coord given.
;
; enter : d = row coord
;         e = col coord
; exit  : hl = attr
; uses  : af, de, hl

   call asm_sp1_GetUpdateStruct

   inc hl
   ld l,(hl)
   ld h,0

   ret
