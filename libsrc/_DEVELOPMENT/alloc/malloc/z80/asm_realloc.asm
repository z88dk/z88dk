
XLIB asm_realloc

LIB asm_heap_realloc

asm_realloc:

   ; Realloc using the thread's default heap
   ;
   ; enter : hl = void *p (existing pointer to memory)
   ;         bc = uint size (realloc size)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_new
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
   jp asm_heap_realloc
