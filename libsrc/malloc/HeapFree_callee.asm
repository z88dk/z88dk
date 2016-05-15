; void __CALLEE__ HeapFree_callee(void *heap, void *addr)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapFree_callee
PUBLIC _HeapFree_callee
PUBLIC ASMDISP_HEAPFREE_CALLEE

.HeapFree_callee
._HeapFree_callee

   pop bc
   pop hl
   pop de
   push bc

.asmentry

; Return memory block to indicated heap.  Available
; blocks must be kept sorted in increasing order by
; start address so that adjacent blocks can be merged.
;
; Not allowed to use IX,IY,EXX so a bit constrained.
;
; enter : de = & heap pointer
;         hl = block address (+2)
; uses  : af, bc, de, hl

.MAHeapFree

   ld a,h
   or l
   ret z

   inc de
   inc de

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

   ; hl = & lagger's next pointer
   ; bc = address following block to free
   ; stack = & block to free
   
   ld a,(hl)
   inc hl
   push hl                   ; save & lagger->next + 1b
   ld h,(hl)
   ld l,a                    ; hl = & next block

   or h                      ; if there is no next block...
   jr z, placeatend
   
   sbc hl,bc                 ; next block - address following block to free
   jr z, mergeontop
   jr nc, insertbefore
   
   adc hl,bc
   inc hl                    ; hl = & next block->next
   pop de                    ; junk lagger
   
   jp loop

.insertbefore

   add hl,bc
   
.placeatend

   ld c,l
   ld b,h
   pop hl
   
   ; bc = & next block
   ; hl = & lagger->next + 1b
   ; stack = & block to free

   jp checkformergebelow
   
.mergeontop

   ; bc = & next block
   ; stack = & block to free, & lagger->next + 1b
   
   ld l,c
   ld h,b
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = size of next block
   inc de
   inc de                    ; reclaim two bytes for next block's size parameter
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)                 ; bc = & next block after merged blocks
   
   pop hl
   ex (sp),hl                ; hl = & block to free, stack = & lagger->next + 1b
   ld a,(hl)                 ; add next block's size to merged block
   add a,e
   ld (hl),a
   inc hl
   ld a,(hl)
   adc a,d
   ld (hl),a
   dec hl
   ex (sp),hl
   
.checkformergebelow

   ; bc = & next block after free
   ; hl = & lagger->next + 1b
   ; stack = & block to free
   
   dec hl
   ld e,l
   ld d,h                    ; de = & lagger->next
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                    ; hl = size of lagger block

   add hl,de                 ; hl = byte past end of lagger block
   ex de,hl
   ex (sp),hl
   ex de,hl
   
   ; bc = & next block after free
   ; hl = byte past end of lagger block
   ; de = & block to free
   ; stack = & lagger->next
   
   sbc hl,de                 ; carry must be clear here
   pop hl
   jr z, mergebelow
   
.nomergebelow

   ; bc = & next block after free
   ; de = & block to free
   ; hl = & lagger->next
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc de
   inc de
   ex de,hl
   ld (hl),c
   inc hl
   ld (hl),b
   ret
   
.mergebelow
 
   ; bc = & next block after free
   ; de = & block to free
   ; hl = & lagger->next
   
   ld (hl),c
   inc hl
   ld (hl),b                 ; write new next pointer for merged block
   dec hl

   ld a,(de)
   ld c,a
   inc de
   ld a,(de)
   ld b,a
   inc bc
   inc bc                    ; bc = size of block to merge + 2 for size parameter
   dec hl
   dec hl
   ld a,(hl)
   add a,c
   ld (hl),a
   inc hl
   ld a,(hl)
   adc a,b
   ld (hl),a
   ret

DEFC ASMDISP_HEAPFREE_CALLEE = # asmentry - HeapFree_callee
