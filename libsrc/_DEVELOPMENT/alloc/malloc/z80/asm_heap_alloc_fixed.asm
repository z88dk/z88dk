
XLIB asm_heap_alloc_fixed

LIB asm_heap_alloc_fixed_unlocked
LIB __heap_lock_acquire, __heap_lock_release_0, error_enolck_zc

asm_heap_alloc_fixed:

   ; Attempt to allocate memory from the heap at a fixed address
   ;
   ; enter : bc = void *p
   ;         de = void *heap
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

   call __heap_lock_acquire
   jp c, error_enolck_zc
   
   push de                       ; save void *heap
   call asm_heap_alloc_fixed_unlocked

   jp __heap_lock_release_0
