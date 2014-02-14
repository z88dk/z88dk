
XLIB asm_free_unlocked

LIB asm_heap_free_unlocked

asm_free_unlocked:

   ; Return the memory block to the heap for reuse without locking
   ;
   ; enter : hl = void *p
   ;
   ; exit  : carry reset
   ;
   ; uses  : af, de, hl

   jp asm_heap_free_unlocked
