
XLIB asm_heap_alloc

LIB asm_heap_alloc_unlocked
LIB __heap_lock_acquire, __heap_lock_release_0, error_enolck_zc

asm_heap_alloc:

   ; Allocate memory from a heap
   ;
   ; enter : de = void *heap
   ;         hl = size
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
   
   call __heap_lock_acquire
   jp c, error_enolck_zc
   
   push de                       ; save void *heap
   call asm_heap_alloc_unlocked

   jp __heap_lock_release_0
