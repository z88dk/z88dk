
XLIB asm_memalign_unlocked

LIB asm_heap_alloc_aligned_unlocked

asm_memalign_unlocked:

   ; Attempt to allocate memory at an address that is aligned to a power of 2
   ; from the thread's default heap without locking
   ;
   ; enter : hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_aligned could be zero if size == 0
   ;            carry reset
   ;
   ;         fail on alignment = $10000
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail on memory not found
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses   : af, bc, de, hl

   ld de,(__heap)
   jp asm_heap_alloc_aligned_unlocked
