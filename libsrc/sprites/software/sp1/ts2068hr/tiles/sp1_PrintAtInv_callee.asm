; void __CALLEE__ sp1_PrintAtInv_callee(uchar row, uchar col, uint tile)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_PrintAtInv_callee
PUBLIC ASMDISP_SP1_PRINTATINV_CALLEE

EXTERN sp1_GetUpdateStruct_callee, sp1_PrintAt_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, ASMDISP_SP1_PRINTAT_CALLEE
EXTERN SP1V_UPDATELISTT

.sp1_PrintAtInv_callee

   pop af
   pop bc
   pop de
   pop hl
   ld d,l
   push af

.asmentry

; Print tile and colour to given coordinate and invalidate
; the tile so that it is redrawn in the next update.
;
; enter :  d = row coord
;          e = col coord
;         bc = tile code
; uses  : af, bc, de, hl

.SP1PrintAtInv

   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

   ld a,(hl)
   xor $80
   jp p, sp1_PrintAt_callee + ASMDISP_SP1_PRINTAT_CALLEE + 3  ; if already marked for invalidation just do PrintAt
   ld (hl),a                        ; mark struct_sp1_update as invalidated

   ld e,l
   ld d,h                           ; de = & struct sp1_update
   inc hl
   ld (hl),c                        ; write tile
   inc hl
   ld (hl),b
   inc hl
   inc hl
   inc hl
   ld (hl),0                        ; mark no struct sp1_update following in invalidated list

   ld hl,(SP1V_UPDATELISTT)         ; current last sp1_update in invalidated list
   ld bc,5
   add hl,bc
   ld (hl),d                        ; store this new sp1_update into current tail
   inc hl
   ld (hl),e
   ld (SP1V_UPDATELISTT),de         ; this new struct sp1_update is now the tail in invalidated list

   ret

DEFC ASMDISP_SP1_PRINTATINV_CALLEE = # asmentry - sp1_PrintAtInv_callee
