
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_fl_unlink

EXTERN __heap_fl_anchor, __heap_fl_node

; Remove this block's spare tail from the free list.
;
; The node already stores next, prev, and owner. Splice from those
; words after checking that they still name this block. A committed
; == 0 hole has no node. A stale tail whose owner word does not match,
; or whose neighbour does not point back, is left untouched.

__heap_fl_unlink:

   ; enter : hl = & block
   ;         __heap_fl_anchor = & first_block->prev
   ;
   ; exit  : hl, bc, de unchanged
   ;         carry reset
   ;
   ; uses  : af

   push ix
   push bc
   push de
   push hl

   call __heap_fl_node
   jr c, unlink_out

   push de
   pop ix                      ; ix = node

   ld a,(ix+4)
   cp l
   jr nz, unlink_out
   ld a,(ix+5)
   cp h
   jr nz, unlink_out           ; owner word is not this block

   ld c,(ix+0)
   ld b,(ix+1)                 ; bc = next
   ld e,(ix+2)
   ld d,(ix+3)                 ; de = prev

   ld a,d
   or e
   jr z, unlink_head

   push ix
   pop hl                      ; hl = node

   ld a,(de)
   cp l
   jr nz, unlink_out
   inc de
   ld a,(de)
   dec de
   cp h
   jr nz, unlink_out           ; prev->next is not this node

   ld a,c
   ld (de),a
   inc de
   ld a,b
   ld (de),a
   dec de                      ; prev->next = next
   jr unlink_next_prev

unlink_head:

   ; prev is 0, so this node must be the list head.
   push ix
   pop de                      ; de = node
   ld hl,(__heap_fl_anchor)

   ld a,(hl)
   cp e
   jr nz, unlink_out
   inc hl
   ld a,(hl)
   dec hl
   cp d
   jr nz, unlink_out

   ld a,b
   or c
   jr z, unlink_sentinel

   ld (hl),c
   inc hl
   ld (hl),b                   ; head = next
   ld de,0                     ; next->prev = 0
   jr unlink_next_prev

unlink_sentinel:

   ld e,l
   ld d,h
   ld (hl),e
   inc hl
   ld (hl),d                   ; head = & head
   jr unlink_out

unlink_next_prev:

   ; bc = next
   ; de = prev, or 0 when the removed node was the head

   ld a,b
   or c
   jr z, unlink_out

   ld hl,2
   add hl,bc                   ; hl = & next->prev
   ld (hl),e
   inc hl
   ld (hl),d

unlink_out:

   pop hl
   pop de
   pop bc
   pop ix

   or a
   ret
