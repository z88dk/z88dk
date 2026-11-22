
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_fl_link

EXTERN __heap_fl_anchor, __heap_fl_node, l_ltu_de_hl

; Insert this block's spare tail into the address-ordered free list.
; A block that has no list node is left unchanged.

__heap_fl_link:

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
   jr c, link_out

   ; hl = & block
   ; de = & node

   push de
   pop ix                      ; ix = & node

   ld (ix+4),l
   ld (ix+5),h                 ; node->owner = & block

   ld d,h
   ld e,l                      ; de = owner

   ld hl,(__heap_fl_anchor)
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = head

   ld a,b
   or c
   jr z, link_empty

   dec hl                      ; hl = & head word
   ld a,c
   cp l
   jr nz, link_walk_init
   ld a,b
   cp h
   jr nz, link_walk_init

link_empty:

   ld bc,0                     ; next = 0
   ld de,0                     ; prev = 0
   jr link_write

link_walk_init:

   ld hl,0
   push hl                     ; prev = 0

link_walk:

   ; bc = current node
   ; de = owner to insert
   ; ix = new node
   ; stack = prev node

   push de

   ld l,c
   ld h,b
   ld de,4
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = current owner

   pop hl                      ; hl = our owner
   ex de,hl                    ; de = our owner, hl = current owner

   call l_ltu_de_hl            ; carry if our owner is below current
   jr c, link_before

   pop hl                      ; discard prev
   push bc                     ; prev = current

   ld l,c
   ld h,b
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = current->next

   ld a,b
   or c
   jr nz, link_walk

   ; append. bc = 0. stack = prev.

link_before:

   pop de                      ; de = prev, bc = next

link_write:

   ; ix = new node
   ; de = prev, or 0
   ; bc = next, or 0

   ld (ix+0),c
   ld (ix+1),b
   ld (ix+2),e
   ld (ix+3),d

   ld a,d
   or e
   jr z, link_set_head

   push ix
   ex (sp),hl                  ; hl = new node
   ex de,hl                    ; hl = prev, de = new node
   ld (hl),e
   inc hl
   ld (hl),d
   pop hl
   jr link_set_next

link_set_head:

   push ix
   pop de                      ; de = new node
   ld hl,(__heap_fl_anchor)
   ld (hl),e
   inc hl
   ld (hl),d

link_set_next:

   ld a,b
   or c
   jr z, link_out

   ld hl,2
   add hl,bc                   ; hl = & next->prev
   push ix
   pop de
   ld (hl),e
   inc hl
   ld (hl),d

link_out:

   pop hl
   pop de
   pop bc
   pop ix

   or a
   ret
