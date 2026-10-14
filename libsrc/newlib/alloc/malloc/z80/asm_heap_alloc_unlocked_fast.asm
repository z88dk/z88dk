
; ===============================================================
; October 2026
; ===============================================================
; 
; void *heap_alloc_unlocked(void *heap, size_t size)
;
; Allocate size bytes from the heap, returning ptr to the
; allocated memory or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_alloc_unlocked_fast

EXTERN __heap_allocate_block, __heap_fl_anchor, __heap_fl_prepare, __heap_fl_fit
EXTERN error_enomem_zc

asm_heap_alloc_unlocked_fast:

   ; Allocate memory from a heap without locking
   ;
   ; enter : de = void *heap
   ;         hl = size
   ;
   ; exit  : success
   ;
   ;            hl = address of allocated memory, 0 if size == 0
   ;            carry reset
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   ld a,h
   or l
   ret z                       ; return 0 if size == 0

   ld bc,6                     ; sizeof(heap header)
   add hl,bc                   ; add space for header to request
   jp c, error_enomem_zc

   ld c,l
   ld b,h                      ; bc = gross request size

   push bc
   call __heap_fl_prepare
   pop bc

   ; hl = & first block. Always test it. A committed == 0 hole lives
   ; here and is deliberately absent from the free list.

   call __heap_fl_fit
   jp nc, __heap_allocate_block

   push bc

   ld hl,(__heap_fl_anchor)
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl                      ; de = head, hl = & head

free_walk:

   ld a,d
   or e
   jr z, free_scan

   ld a,e
   cp l
   jr nz, free_node
   ld a,d
   cp h
   jr z, free_scan             ; empty sentinel

free_node:

   push hl                     ; save & head
   push de                     ; save & node

   ld hl,4
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                    ; hl = owner block

   pop de
   pop af                      ; discard & head, keep de = & node

   pop bc                      ; bc = gross request
   push bc
   push de

   call __heap_fl_fit

   jr c, free_next

   pop af                      ; discard & node. de is & block_new.
   pop bc                      ; gross request, already in bc
   jp __heap_allocate_block

free_next:

   pop de                      ; & node

   ld l,e
   ld h,d
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = node->next

   ld hl,(__heap_fl_anchor)
   jr free_walk

free_scan:

   pop bc

   ld hl,(__heap_fl_anchor)
   dec hl
   dec hl
   dec hl
   dec hl                      ; hl = & first block

block_loop:

   ; Address-chain walk. Used when the free list does not name a
   ; large enough region (a static committed == 0 wilderness, or
   ; the heap really is full). __heap_fl_fit is the same test the
   ; free-list walk uses.

   push hl                     ; save & block
   push bc                     ; save gross request size

   call __heap_fl_fit
   jr nc, found_memory

   pop bc                      ; gross request size
   pop hl                      ; & block

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next

   ld a,d
   or e
   ld l,e
   ld h,d                      ; hl = & next block
   jp nz, block_loop

   push hl
   push hl
   jp error_enomem_zc - 2      ; two discards, same as the old walk

found_memory:

   ; de = & block_new
   ; bc = gross request size
   ; stack = gross request size, & block

   pop bc
   pop hl
   jp __heap_allocate_block
