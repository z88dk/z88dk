
XLIB asm_posix_memalign_unlocked
XDEF asm0_posix_memalign_unlocked

LIB asm_heap_alloc_aligned_unlocked

asm_posix_memalign_unlocked:

   ; Aligned allocation with allocated address written to memptr without locking
   ;
   ; enter : de = void **memptr
   ;         hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : *memptr = ptr to allocated memory (zero on error)
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = ENOMEM, EINVAL or ENOLCK
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save memptr
   
   ld de,(__heap)
   call asm_heap_alloc_aligned_unlocked
   
asm0_posix_memalign_unlocked:

   pop de
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; *memptr = allocation address
   
   ld hl,0
   ret nc                      ; if no error
   
   ld hl,(_errno)              ; otherwise error is stored in errno
   ret                         ; (this is safe in z88dk)
