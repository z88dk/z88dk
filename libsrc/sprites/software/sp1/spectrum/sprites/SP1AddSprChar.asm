
PUBLIC SP1AddSprChar

; /////////////////////////////////////////////////////////////////////////////////

; Adds a sprite char to the linked list of sprites in a
; struct sp1_update at the correct position dependant on plane.
;
; enter :  a = plane
;         hl = & struct update.slist
;         bc = & sp1_cs.attr_mask of sprite char being added
; uses  : f, bc, de, hl
;
; 98n - 26 + 197 = 98n + 171 (n = # sprites in char; n=3: 465, n=1: 130)

.SP1AddSprChar

   ; hl = prev sprite's & sp1_cs.next_in_upd (pending point to add current sprite after)

   ld d,(hl)
   inc hl
   inc d
   dec d
   jr z, donesearch1         ; if no next sprite, we add this sprite to end of list

   ld e,(hl)
   dec de
   dec de
   ex de,hl                  ; hl = the next sprite's & sp1_cs.plane, de = prev sprite's & sp1_cs.next_in_upd + 1b
   cp (hl)
   jr nc, donesearch0        ; if plane >= this sprite's plane, place before it
   ld de,16
   add hl,de                 ; hl = the next sprite's & sp1_cs.next_in_upd
   
   jp SP1AddSprChar

.donesearch1                 ; no next sprite
 
   ld (hl),c                 ; hl = & prev sprite's sp1_cs.next_in_upd + 1b
   dec hl
   ld (hl),b                 ; write new sprite char into next ptr
   ex de,hl                  ; de = & prev sprite's sp1_cs.next_in_upd
   ld hl,14
   add hl,bc                 ; hl = & sp1_cs.next_in_upd of spr char to add
   ld (hl),0                 ; no sprite chars follow this one in list
   inc hl
   inc hl
   ld (hl),d                 ; write prev sprite into prev spr ptr
   inc hl
   ld (hl),e

   ret

.donesearch0                 ; there is a next sprite

   inc hl
   inc hl
   ex de,hl                  ; hl = & prev sprite's sp1_cs.next_in_upd + 1b, de = next sprite's & sp1_cs.attr_mask
   ld (hl),c
   dec hl
   ld (hl),b                 ; prev sprite's next ptr points at new sprite char
   push hl                   ; stack = prev sprite's & sp1_cs.next_in_upd
   ld hl,14
   add hl,bc                 ; hl = new sprite's & sp1_cs.next_in_upd
   ld (hl),d 
   inc hl
   ld (hl),e                 ; new sprite's next ptr points at next sprite
   inc hl                    ; hl = new sprite's & sp1_cs.prev_in_upd
   pop bc                    ; bc = prev sprite's & sp1_cs.next_in_upd
   ld (hl),b  
   inc hl
   ld (hl),c                 ; new sprite's prev ptr points at prev sprite
   dec hl
   dec hl
   dec hl
   ex de,hl                  ; de = new sprite's & sp1_cs.next_in_upd
   ld bc,16
   add hl,bc                 ; hl = next sprite's & sp1_cs.prev_in_upd
   ld (hl),d
   inc hl
   ld (hl),e                 ; next sprite's prev ptr points at new sprite

   ret
