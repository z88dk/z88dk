
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *HeapCalloc(void *heap, size_t nmemb, size_t size)
;
; Allocate nmemb*size bytes from the heap and initialize
; that memory to 0.
;
; Returns 0 if nmemb*size == 0 without indicating error.
;
; ===============================================================

XLIB HeapCalloc_callee
XDEF asm_HeapCalloc

LIB asm_HeapAlloc, asm_memset, l_mulu_16_16x16, error_enomem_zc

HeapCalloc_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

asm_HeapCalloc:

   ; enter : hl = nmemb
   ;         de = size
   ;         bc = & heap (ptr to region)
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated memory
   ;
   ;         fail
   ;
   ;           carry set, enomem
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl
   
   push bc                     ; save heap
   call l_mulu_16_16x16        ; hl = hl * de = allocation size
   pop de                      ; de = heap
   jp c, error_enomem_zc       ; on overflow
   
   push hl                     ; save size
   call asm_HeapAlloc          ; hl = & allocated memory
   pop bc                      ; bc = size
   ret c                       ; if allocation failed
   
   ld e,0
   jp asm_memset               ; zero allocated bytes
