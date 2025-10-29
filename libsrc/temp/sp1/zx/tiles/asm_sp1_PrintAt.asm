; void sp1_PrintAt(uchar row, uchar col, uchar colour, uint tile)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_PrintAt

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_PrintAt:

; Print tile and colour to given coordinate.
;
; enter :  d = row coord
;          e = col coord
;         bc = tile code
;          a = attr
; uses  : af, de, hl, af'

   ex af,af
   call asm_sp1_GetUpdateStruct
   ex af,af
   inc hl
   ld (hl),a
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   ret

