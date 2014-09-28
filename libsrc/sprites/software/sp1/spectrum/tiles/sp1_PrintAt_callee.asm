; void __CALLEE__ sp1_PrintAt_callee(uchar row, uchar col, uchar colour, uint tile)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_PrintAt_callee
XDEF ASMDISP_SP1_PRINTAT_CALLEE

LIB sp1_GetUpdateStruct_callee
XREF ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_PrintAt_callee

   pop af
   pop bc
   pop hl
   pop de
   ld d,l
   pop hl
   push af
   ld a,d
   ld d,l

.asmentry

; Print tile and colour to given coordinate.
;
; enter :  d = row coord
;          e = col coord
;         bc = tile code
;          a = attr
; uses  : af, de, hl, af'

.SP1PrintAt

   ex af,af
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   ex af,af
   inc hl
   ld (hl),a
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   ret

DEFC ASMDISP_SP1_PRINTAT_CALLEE = # asmentry - sp1_PrintAt_callee

