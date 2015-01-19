; void __CALLEE__ sp1_PrintAt_callee(uchar row, uchar col, uint tile)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_PrintAt_callee
PUBLIC ASMDISP_SP1_PRINTAT_CALLEE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_PrintAt_callee

   pop af
   pop bc
   pop de
   pop hl
   ld d,l
   push af

.asmentry

; Print tile and colour to given coordinate.
;
; enter :  d = row coord
;          e = col coord
;         bc = tile code
; uses  : af, de, hl

.SP1PrintAt

   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   ret

DEFC ASMDISP_SP1_PRINTAT_CALLEE = # asmentry - sp1_PrintAt_callee
