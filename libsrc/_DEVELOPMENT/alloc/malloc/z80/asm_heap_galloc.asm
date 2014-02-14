
XLIB asm_heap_galloc

LIB asm_heap_galloc_unlocked
LIB __heap_lock_acquire, __heap_lock_release_0, error_enolck_zc

asm_heap_galloc:

   ; Attempt to adjust the size of the allocation by a signed quantity
   ; This is a thin layer on top of realloc used by library functions
   ;
   ; enter : de = void *heap
   ;         hl = void *p
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

   call __heap_lock_acquire
   jp c, error_enolck_zc
   
   push de                       ; save void *heap
   call asm_heap_galloc_unlocked

   jp __heap_lock_release_0
