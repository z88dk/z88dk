
XLIB asm_posix_memalign

LIB asm_heap_alloc_aligned, asm0_posix_memalign_unlocked

asm_posix_memalign:

   ; Aligned allocation with allocated address written to memptr
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
   call asm_heap_alloc_aligned
   
   jp asm0_posix_memalign_unlocked
