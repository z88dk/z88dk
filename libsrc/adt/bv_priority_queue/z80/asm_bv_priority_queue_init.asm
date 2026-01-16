
; ===============================================================
; Mar 2014
; ===============================================================
; 
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))
;
; Initialize a byte vector priority queue structure at address p
; and allocate an array of capacity bytes to begin with.  The
; vector's array will not be allowed to grow beyond max_size bytes.
; 
; priority_queue.size = 0
;
; Returns p on success or 0 on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_init

EXTERN asm_b_vector_init

asm_bv_priority_queue_init:

   ; enter : de = p
   ;         bc = capacity in bytes
   ;         hl = max_size
   ;         ix = int (*compar)(const void *, const void *)
   ;
   ; exit  : success
   ;
   ;            hl = priority_queue *
   ;            carry reset
   ;
   ;         fail if max_size < capacity
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if unsuccessful realloc
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   ex de,hl
   
   push de
   
   push ix
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de
   
   ex de,hl
   
   call asm_b_vector_init
   ret c
   
   dec hl
   dec hl
   
   ret
