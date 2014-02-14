
XLIB __heap_lock_acquire

LIB asm_mtx_lock

__heap_lock_acquire:

   ; Acquire the heap's lock
   ;
   ; enter : de = void *heap
   ;
   ; exit  : carry reset on success
   ;         carry set on fail
   ;
   ; uses  : af
   
   push bc
   push de
   push hl
   
   ex de,hl
   call asm_mtx_lock
   
   pop hl
   pop de
   pop bc
   
   ret
