
; SP1PrintAtInv
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1PrintAtInv
LIB SP1GetUpdateStruct, SP1PrintAt
XREF SP1V_UPDATELISTT

; Print tile and colour to given coordinate and invalidate
; the tile so that it is redrawn in the next update.
;
; enter : d = row coord
;         e = col coord
;         b = attr
;         c = tile
; uses  : af, bc, de, hl

.SP1PrintAtInv

   call SP1GetUpdateStruct

   ld a,(hl)
   xor $80
   jp p, SP1PrintAt+3               ; if already marked for invalidation just do PrintAt
   ld (hl),a                        ; mark struct_sp1_update as invalidated

   ld e,l
   ld d,h                           ; de = & struct sp1_update
   inc hl
   ld (hl),b                        ; write colour
   inc hl
   ld (hl),c                        ; write tile
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
   ld (SP1UPDATELISTT),de           ; this new struct sp1_update is now the tail in invalidated list

   ret

