
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_destroy(void *heap)
;
; Destroy the mutex associated with the heap.
;
; ===============================================================

PUBLIC asm_heap_destroy

EXTERN asm_mtx_destroy

asm_heap_destroy:

   jp asm_mtx_destroy

;defc asm_heap_destroy = asm_mtx_destroy

   ; Destroys the mutex associated with the heap
   ;
   ; enter : hl = void *heap
   ;
   ; uses  : af, bc, de, hl
