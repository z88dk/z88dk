; uint __CALLEE__ sp1_ScreenStr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_ScreenStr_callee
PUBLIC ASMDISP_SP1_SCREENSTR_CALLEE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_ScreenStr_callee

   pop hl
   pop de
   ex (sp),hl
   ld d,l

.asmentry

; Return tile at background coord given.
;
; enter : d = row coord
;         e = col coord
; exit  : hl = tile
; uses  : af, de, hl

.SP1ScreenStr

   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl

   ret

DEFC ASMDISP_SP1_SCREENSTR_CALLEE = # asmentry - sp1_ScreenStr_callee
