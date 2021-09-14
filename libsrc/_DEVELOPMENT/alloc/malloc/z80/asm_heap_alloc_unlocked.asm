
; ===============================================================
; Dec 2013
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

PUBLIC asm_heap_alloc_unlocked

EXTERN __heap_allocate_block, error_enomem_zc

asm_heap_alloc_unlocked:

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
   jp C, error_enomem_zc
   
   ld bc,hl                    ; bc = gross request size
   
   ld hl,6                     ; hl = sizeof(mutex)
   add hl,de

block_loop:

   ; bc = gross request size
   ; hl = & block to examine
   
   push hl                     ; save & block
   push bc                     ; save gross request size
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next
   
   ld a,d
   or e
   jp Z, error_enomem_zc - 2   ; if reached end of heap
   
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed
   
   dec hl
   dec hl
   dec hl
   add hl,bc                   ; hl = allocation address
   
   ex de,hl
   pop bc
   
   ; bc = gross request size
   ; de = allocation address
   ; hl = block->next
   ; stack = & block
   
   push hl                     ; save block->next
   
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,l
   sub e
   ld l,a
   ld a,h
   sub d
   ld h,a                      ; hl = free bytes in block
IF __CPU_8085__
   sub hl,bc
ELSE
   ld a,l
   sub c
   ld l,a
   ld a,h
   sub b
   ld h,a
ENDIF
ELSE
   sbc hl,de                   ; hl = free bytes in block
   sbc hl,bc
ENDIF
   
   pop hl                      ; hl = block->next
IF __CPU_INTEL__
   jp NC, found_memory         ; free bytes >= gross request size
ELSE
   jr NC, found_memory         ; free bytes >= gross request size
ENDIF
   
   pop af                      ; junk stack item
   jp block_loop

found_memory:

   ; bc = gross request size
   ; de = allocation address
   ; hl = block->next
   ; stack = & block
   
   pop hl
   jp __heap_allocate_block
