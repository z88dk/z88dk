; void sp1_PrintAtInv(uchar row, uchar col, uchar colour, uint tile)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_PrintAtInv

EXTERN asm_sp1_GetUpdateStruct, asm_sp1_PrintAt

asm_sp1_PrintAtInv:

; Print tile and colour to given coordinate and invalidate
; the tile so that it is redrawn in the next update.
;
; enter :  d = row coord
;          e = col coord
;         bc = tile code
;          a = attr
; uses  : af, bc, de, hl, af'

   ex af,af
   call asm_sp1_GetUpdateStruct

   ld a,(hl)
   xor $80
   jp p, asm_sp1_PrintAt + 4        ; if already marked for invalidation just do PrintAt
   ld (hl),a                        ; mark struct_sp1_update as invalidated

   ex af,af
   ld e,l
   ld d,h                           ; de = & struct sp1_update
   inc hl
   ld (hl),a                        ; write colour
   inc hl
   ld (hl),c                        ; write tile
   inc hl
   ld (hl),b
   inc hl
   inc hl
   inc hl
   ld (hl),0                        ; mark no struct sp1_update following in invalidated list

   ld hl,(SP1V_UPDATELISTT)         ; current last sp1_update in invalidated list
   ld bc,6
   add hl,bc
   ld (hl),d                        ; store this new sp1_update into current tail
   inc hl
   ld (hl),e
   ld (SP1V_UPDATELISTT),de         ; this new struct sp1_update is now the tail in invalidated list

   ret
