
XLIB asm_galloc

LIB asm_heap_galloc

asm_galloc:

   ; Galloc on the thread's default heap
   ;
   ; enter : hl = void *p
   ;         bc = int resize (signed)
   ;
   ; exit  : success
   ;
   ;            de = old allocation size
   ;            bc = new allocation size
   ;            hl = void *p_new
   ;            carry reset
   ;
   ;         fail on requested size out of range
   ;
   ;            de = old allocation size
   ;            hl = 0
   ;            carry set, errno = ERANGE
   ;
   ;         fail on insufficient memory
   ;
   ;            de = old allocation size
   ;            bc = desired allocation size
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
   jp asm_heap_galloc
