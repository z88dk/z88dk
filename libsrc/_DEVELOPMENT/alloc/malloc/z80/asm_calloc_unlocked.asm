
XLIB asm_calloc_unlocked

LIB asm_heap_calloc_unlocked

asm_calloc_unlocked:

   ; Allocate zero-initialized memory from the thread's default heap
   ; without locking
   ;
   ; enter : hl = uint nmemb
   ;         bc = uint size
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
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl

   ld de,(__heap)
   jp asm_heap_calloc_unlocked
