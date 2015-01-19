
; sp1_RemoveUpdateStruct
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_RemoveUpdateStruct

; FASTCALL

; Removes the character cell represented by the struct_sp1_update
; passed in so that the sprite engine will not draw the cell.
; Sprites will not be entered into the internal representation of
; the cell but tiles can continue to be printed to it.
;
; enter : hl = & struct sp1_update
; uses  : af, de, hl

.sp1_RemoveUpdateStruct

   ld (hl),$c1           ; invalidated & removed, # occluding sprites + 1 = 1
   inc hl
   inc hl
   inc hl
   inc hl                ; hl = sprite list

   ld a,(hl)
   ld (hl),0             ; mark no sprites in this update struct
   inc hl
   ld l,(hl)             ; al = & struct sp1_cs of first sprite in this update char

   or a                  ; if no sprites, done
   ret z

   ld h,a                ; hl = & struct sp1_cs.attr_mask
   
.loop

   ld de,-4
   add hl,de             ; hl = & struct sp1_cs.update
   ld (hl),0             ; this sprite char belongs to no update structs

   ld de,18
   add hl,de             ; hl = & struct sp1_cs.next_in_upd
   ld a,(hl)
   or a
   ret z
   inc hl
   ld l,(hl)
   ld h,a                ; hl = & next struct sp1_cs.attr_mask

   jp loop
