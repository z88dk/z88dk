
XLIB asm_malloc

LIB asm_heap_alloc

asm_malloc:

   ; Allocate memory from the thread's default heap
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
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl
   
   ld de,(__heap)
   jp asm_heap_alloc
