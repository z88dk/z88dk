
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)
;
; Attempt to allocate size bytes from the heap at fixed
; address p.  The allocation will fail if the heap does
; not contain enough free memory at address p.
;
; Returns p on success or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_alloc_fixed_unlocked

EXTERN l_ltu_de_hl, __heap_place_block, __heap_allocate_block, error_enomem_zc

asm_heap_alloc_fixed_unlocked:

   ; Attempt to allocate memory from a heap at a fixed
   ; address without locking
   ;
   ; enter : bc = void *p
   ;         de = void *heap
   ;         hl = size
   ;
   ; exit  : success
   ;
   ;            hl = void *p (zero size allocation will occur)
   ;            carry reset
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save size

   ld hl,6                     ; sizeof(mutex)
   add hl,de
   
   ex de,hl                    ; de = & block_first
   
   ld hl,-6                    ; sizeof(heap header)
   add hl,bc                   ; hl = & block_p
   
   ex de,hl
   
   ; de = & block_p
   ; hl = & block = first block in the heap
   ; stack = size

locate_loop:

   ; locate block that block_p belongs to

   ld c,l
   ld b,h

   ; bc = & block_belong
   ; de = & block_p
   ; hl = & block
   ; stack = size

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->next
   
   or h
   jr z, end_loop              ; if end of heap reached

   call l_ltu_de_hl
   jr nc, locate_loop          ; if block_p >= block

end_loop:

   ; bc = & block
   ; de = & block_p
   ; stack = size

   pop hl
   push bc
   
   ld bc,6                     ; sizeof(heap header)
   add hl,bc
   jp c, error_enomem_zc - 1   ; if request size too big

   ld c,l
   ld b,h                      ; bc = gross request size

   pop hl
   
   ; hl = & block
   ; de = & block_p
   ; bc = gross request size
   
   ; determine if block_p will fit into block's space
   
   call __heap_place_block
   jp nc, __heap_allocate_block  ; if allocation will be successful

   jp error_enomem_zc
