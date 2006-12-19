; HeapFree
; 12.2006 aralbrec

XLIB MAHeapFree

; Return memory block to indicated heap.  Available
; blocks must be kept sorted in increasing order by
; start address so that adjacent blocks can be merged.
;
; enter : de = & heap pointer
;         hl = block address (+2)
; uses  : af, bc, de, hl

.MAHeapFree

   ld a,h
   or l
   ret z

   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   push hl
   add hl,bc
   inc hl
   inc hl
   ld c,l
   ld b,h
   ex de,hl
   
   ; hl = & lagger's next pointer
   ; bc = address following block to free
   ; stack = & block to free

.loop

   ld a,(hl)
   inc hl
   push hl                   ; save & lagger's next + 1b
   ld h,(hl)
   ld l,a                    ; hl = & next block
   
   or h
   jr z, placeatend          ; if no next block, add block to end

   sbc hl,bc                 ; next block address - address following block to free
   jr z, mergeblocks
   jr nc, insertblock
   
   adc hl,bc
   inc hl                    ; hl = & block->next
   pop de                    ; junk lagger
   jp loop

.mergeblocks

   ; bc = & next block (hl-bc=0 remember)
   ; stack = & block to free, & lagger's next + 1b

   ld l,c
   ld h,b
   ld c,(hl)
   inc hl
   ld b,(hl)                 ; bc = size of next block
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = next block->next
   
   pop hl
   ex (sp),hl                ; hl = & block to free
   
   inc hl
   inc hl
   inc hl
   ld (hl),d
   dec hl
   ld (hl),e                 ; block to free->next = next block->next
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                 ; de = size of block to free
   ex de,hl
   add hl,bc                 ; compute size of merged block
   inc hl
   inc hl
   ex de,hl
   ld (hl),e                 ; store size of merged block
   inc hl
   ld (hl),d
   dec hl
   
   pop de
   ex de,hl                  ; hl = & lagger's next + 1b, de = & block to free
   ld (hl),d
   dec hl
   ld (hl),e                 ; lagger->next = & block to free
   ret

.insertblock

   add hl,bc
   pop de
   pop bc
   ex de,hl
   
   ; de = & next block
   ; hl = & lagger's next + 1b
   ; bc = & block to free
   
   ld (hl),b
   dec hl
   ld (hl),c                 ; lagger->next = block being freed
   ld l,c
   ld h,b
   inc hl
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d                 ; freed block->next = next block
   ret

.placeatend

   ; stack = & block to free, & lagger's next + 1b

   pop hl
   pop de
   ld (hl),d
   dec hl
   ld (hl),e                 ; lagger->next = block to free
   inc de
   inc de
   xor a
   ld (de),a
   inc de
   ld (de),a                 ; block to free->next = 0
   ret
