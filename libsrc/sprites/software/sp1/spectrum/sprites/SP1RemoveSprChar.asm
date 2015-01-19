
PUBLIC SP1RemoveSprChar

; /////////////////////////////////////////////////////////////////////////////////

; Remove a sprite char from the linked list of sprites
; it occupies in a struct sp1_update
;
; enter : hl = & struct sp1_cs.attr_mask
; exit  : de = & struct sp1_cs.prev_in_upd + 1
; uses  : f, bc, de, hl
;
; 179 cycles worst case

.SP1RemoveSprChar

   ld de,14
   add hl,de                 ; hl = & struct sp1_cs.next_in_upd
   
   ld b,(hl)                 ; check if there's any sprite char after this one in list
   inc b
   inc hl                    ; hl = & struct sp1_cs.next_in_upd + 1
   djnz nextexists
   
   ; no sprite char after this one in list so removing from end of list
   
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & left link's sp1_cs.next_in_upd
   ex de,hl                  ; de = & struct sp1_cs.prev_in_upd + 1
   ld (hl),0                 ; mark no next sprite, removing this one from list
   
   ret

.nextexists

   ; there is a sprite char after this one in update list, so removing from middle of list

   ld c,(hl)                 ; bc = & right link's struct sp1_cs.attr_mask
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & left link's struct sp1_cs.next_in_upd

   ex de,hl                  ; de = & struct sp1_cs.prev_in_upd + 1b
   push hl                   ; stack & left link's struct sp1_cs.next_in_upd

   ld (hl),b
   inc hl
   ld (hl),c                 ; previous sprite's next ptr = & right link's struct sp1_cs.attr_mask

   ld hl,16
   add hl,bc                 ; hl = & right link's struct sp1_cs.prev_in_update
   pop bc                    ; bc = & left link's struct sp1_cs.next_in_upd

   ld (hl),b
   inc hl
   ld (hl),c                 ; next sprite's prev ptr = & left link's struct sp1_cs.next_in_upd

   ret
