
XLIB asm_aligned_alloc

LIB asm_heap_alloc_aligned

asm_aligned_alloc:

   ; Attempt to allocate memory at an address that is aligned to a power of 2
   ; from the thread's default heap
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
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses   : af, bc, de, hl

   ld de,(__heap)
   jp asm_heap_alloc_aligned
