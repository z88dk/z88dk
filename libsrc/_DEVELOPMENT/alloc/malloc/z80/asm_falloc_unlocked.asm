
XLIB asm_falloc_unlocked

LIB asm_heap_alloc_fixed_unlocked

asm_falloc_unlocked:

   ; Attempt to allocate memory from the thread's default heap
   ; at a fixed address without locking
   ;
   ; enter : bc = void *p
   ;         hl = size
   ;
   ; exit  : success
   ;
   ;            hl = void *p (zero size allocation will occur)
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errono = ENOLCK
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   ld de,(__heap)
   jp asm_heap_alloc_fixed_unlocked
