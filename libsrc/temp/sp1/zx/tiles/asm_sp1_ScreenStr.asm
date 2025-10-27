; uint sp1_ScreenStr(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_ScreenStr

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_ScreenStr:

; Return tile at background coord given.
;
; enter : d = row coord
;         e = col coord
; exit  : hl = tile
; uses  : af, de, hl

   call asm_sp1_GetUpdateStruct

   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl

   ret
