
; void  __FASTCALL__ sp1_RemoveCharStruct(struct sp1_cs *cs)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_RemoveCharStruct
EXTERN SP1RemoveSprChar

; remove an independent char struct that may be
; inserted into a struct_sp1_update's draw list
;
; enter : hl = struct sp1_cs *
; uses  : af, bc, de, hl

.sp1_RemoveCharStruct

   inc hl
   inc hl
   
   ld a,(hl)
   or a
   ret z                       ; not in any struct update draw list
   
   ld d,a
   ld (hl),0                   ; not part of this draw list anymore
   inc hl
   ld e,(hl)                   ; de = struct update *
   inc hl
   inc hl                      ; hl = & sp1_cs.type
   
   bit 7,(hl)
   ex de,hl
   jr z, notoccluding
   dec (hl)                    ; reduce occluding count in struct update

.notoccluding

   inc de                      ; de = & sp1_cs.ss_draw
   ld hl,15
   add hl,de                   ; hl = & sp1_cs.prev_in_upd + 1b
   ex de,hl
   jp SP1RemoveSprChar
