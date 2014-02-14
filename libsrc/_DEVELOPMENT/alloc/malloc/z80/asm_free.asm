
XLIB asm_free

LIB asm_heap_free

asm_free:

   ; Return the memory block to the thread's default heap
   ;
   ; enter : hl = void *p
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            de = void *p
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, de, hl

   ld de,(__heap)
   jp asm_heap_free
