; void __CALLEE__ sp1_SetPrintPos_callee(struct sp1_pss *ps, uchar row, uchar col)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_SetPrintPos_callee
PUBLIC ASMDISP_SP1_SETPRINTPOS_CALLEE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_SetPrintPos_callee

   pop af
   pop de
   pop hl
   ld d,l
   pop hl
   push af

.asmentry

; e = col
; d = row
; hl = struct sp1_pss *ps

   ld c,(hl)
   inc hl
   ld b,(hl)                 ; bc = & bounds rectangle
   inc hl
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl

   push hl                   ; stack & sp1_pss.pos
   ld a,(bc)
   add a,d
   ld d,a
   inc bc
   ld a,(bc)
   add a,e
   ld e,a
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   pop de
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d
   ret


DEFC ASMDISP_SP1_SETPRINTPOS_CALLEE = # asmentry - sp1_SetPrintPos_callee
