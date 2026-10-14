
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_fl_node

; Free-list node for one block's spare tail.
;
; A node is six bytes stored at the first byte of the tail:
;   +0 next free node
;   +2 previous free node
;   +4 owner block
;
; Only a committed block with a tail of at least 7 bytes has a node.
; That tail is past the user bytes, so the node never sits in payload.
; A committed == 0 region (the initial hole, or the first block after it
; is freed) is not listed. malloc and largest-fit test the first block
; directly, which is where that hole lives.

__heap_fl_node:

   ; enter : hl = & block
   ;
   ; exit  : success
   ;
   ;            hl = & block
   ;            de = & node
   ;            carry reset
   ;
   ;         fail (no list node for this block)
   ;
   ;            hl = & block
   ;            carry set
   ;
   ; uses  : af, bc, de

   push hl

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next

   ld a,d
   or e
   jr z, node_none             ; terminator

   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed

   pop hl                      ; hl = & block
   push hl

   ld a,b
   or c
   jr z, node_none             ; committed == 0 is not listed

   add hl,bc                   ; hl = & tail = & node

   push hl

   ex de,hl                    ; hl = block->next, de = & node

   or a
   sbc hl,de                   ; hl = tail size

   pop de                      ; de = & node

   ld a,l
   sub 7
   ld a,h
   sbc a,0
   jr c, node_none             ; tail < 7

   pop hl                      ; hl = & block
   or a
   ret

node_none:

   pop hl
   scf
   ret
