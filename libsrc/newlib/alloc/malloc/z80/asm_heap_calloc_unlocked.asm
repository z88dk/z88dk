
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_calloc_unlocked(void *heap, size_t nmemb, size_t size)
;
; Allocate nmemb * size bytes from the heap and initialize
; that memory to 0.
;
; Returns 0 with carry set on failure.
;
; Returns 0 if nmemb * size == 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_calloc_unlocked

EXTERN l_mulu_16_16x16, asm_heap_alloc_unlocked, asm_memset, error_enomem_zc

asm_heap_calloc_unlocked:

   ; Allocate zero-initialized memory from a heap without locking
   ;
   ; enter : hl = uint nmemb
   ;         bc = uint size
   ;         de = void *heap
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

   push de                     ; save heap
   
   ld e,c
   ld d,b
   
   call l_mulu_16_16x16        ; hl = nmemb * size = request size
   jp c, error_enomem_zc - 1

   pop de                      ; de = void *heap
   push hl                     ; save request size
   
   call asm_heap_alloc_unlocked

   pop bc                      ; bc = request size
   ret c                       ; if allocation failed
   
   ; hl = void *p
   ; bc = request size
   
   ld e,0
   jp asm_memset               ; zero the allocated memory
