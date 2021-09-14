
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_lock_release

EXTERN asm_mtx_unlock

__heap_lock_release:

   ; Release the heap's lock
   ;
   ; enter : hl = void *heap
   ;
   ; exit  : none
   ;
   ; uses  : hl
   
   push af
   push bc
   push de
   
   call asm_mtx_unlock
   
   pop de
   pop bc
   pop af
   
   ret

IF !__CPU_GBZ80__

PUBLIC __heap_lock_release_0

__heap_lock_release_0:

   ; Release the heap's lock, alternate method
   ;
   ; enter : stack = ret, void *heap
   ;
   ; exit  : none
   ;
   ; uses  : none

   ex (sp),hl                  ; hl = void *heap
   call __heap_lock_release
   
   pop hl
   ret

ENDIF
