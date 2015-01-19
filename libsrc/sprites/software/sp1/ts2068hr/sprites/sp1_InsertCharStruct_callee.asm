
; void __CALLEE__ sp1_InsertCharStruct_callee(struct sp1_update *u, struct sp1_cs *cs)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_InsertCharStruct_callee
PUBLIC ASMDISP_SP1_INSERTCHARSTRUCT_CALLEE
EXTERN SP1AddSprChar

.sp1_InsertCharStruct_callee

   pop hl
   pop de
   ex (sp),hl
   ex de,hl

.asmentry

   ; hl = struct sp1_cs *
   ; de = struct sp1_update *

   inc hl
   inc hl
   ld (hl),d                   ; store sp1_update into sp1_cs.update
   inc hl
   ld (hl),e
   inc hl
   ld a,(hl)                   ; a = plane
   inc hl                      ; hl = & sp1_cs.type
   
   bit 7,(hl)                  ; is it occluding type?
   ex de,hl
   jr z, notoccluding
   inc (hl)                    ; increase # occluding sprites in update struct

.notoccluding

   inc de
   ld c,e
   ld b,d                      ; bc = & sp1_cs.ss_draw
   inc hl
   inc hl
   inc hl                      ; hl = & sp1_update.slist
   jp SP1AddSprChar

DEFC ASMDISP_SP1_INSERTCHARSTRUCT_CALLEE = # asmentry - sp1_InsertCharStruct_callee
