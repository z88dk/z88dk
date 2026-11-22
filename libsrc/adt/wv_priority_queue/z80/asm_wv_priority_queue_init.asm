
; ===============================================================
; Mar 2014
; ===============================================================
; 
; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))
;
; Initialize a word vector priority queue structure at address p
; and allocate an array of capacity words to begin with.  The
; vector's array will not be allowed to grow beyond max_size words.
; 
; priority_queue.size = 0
;
; Returns p on success or 0 on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC asm_wv_priority_queue_init

EXTERN asm_bv_priority_queue_init, error_zc

asm_wv_priority_queue_init:

   ; enter : de = p
   ;         bc = capacity in words
   ;         hl = max_size in words
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

   add hl,hl
   jp c, error_zc
   
   sla c
   rl b
   jp nc, asm_bv_priority_queue_init
   
   jp error_zc
