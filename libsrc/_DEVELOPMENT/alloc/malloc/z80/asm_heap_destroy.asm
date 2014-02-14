
XLIB asm_heap_destroy

LIB asm_mtx_destroy

asm_heap_destroy:

   ; Destroys the mutex associated with the heap
   ;
   ; enter : hl = void *heap
   ;
   ; uses  : af, bc, de, hl
   
   jp asm_mtx_destroy
