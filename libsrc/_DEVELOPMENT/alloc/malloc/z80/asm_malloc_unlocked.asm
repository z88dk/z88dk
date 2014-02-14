
XLIB asm_malloc_unlocked

LIB asm_heap_alloc_unlocked

asm_malloc_unlocked:

   ; Allocate memory from the thread's default heap without locking
   ;
   ; enter : hl = size
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

   ld de,(__heap)
   jp asm_heap_alloc_unlocked
