
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_init(void *heap, size_t size)
;
; Initialize a heap of size bytes.
; An unchecked condition is that size > 14 bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_init

EXTERN mtx_plain

EXTERN asm_mtx_init, error_enolck_zc, l_setmem_hl

asm_heap_init:

   ; initialize the heap to empty
   ; area reserved for the heap must be at least 14 bytes
   ;
   ; enter : hl = void *heap
   ;         bc = number of available bytes >= 14
   ;
   ; exit  : success
   ;
   ;            hl = void *heap
   ;            carry reset
   ;
   ;         fail if mutex init fails
   ;
   ;            hl = 0
   ;            de = void *heap
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl

   ld e,l
   ld d,h                      ; de = void *heap
   
   push hl                     ; save void *heap
   push bc                     ; save num bytes
   
   ld c,mtx_plain
   call asm_mtx_init
   
   jp c, error_enolck_zc - 2   ; if mutex init failed

   ld hl,6                     ; sizeof(mutex)
   add hl,de
   
   ex de,hl                    ; de = start of heap proper

   pop bc                      ; bc = num bytes
   add hl,bc                   ; hl = & byte past heap
   
   xor a
   
   dec hl
   ld (hl),a
   dec hl
   ld (hl),a                   ; write end of heap marker
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; block_first->next = & heap_end
   inc hl
   
   call l_setmem_hl - 8        ; zero out four bytes
   
   pop hl                      ; hl = void *heap
   ret
