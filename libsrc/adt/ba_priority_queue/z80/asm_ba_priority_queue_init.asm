
; ===============================================================
; Mar 2014
; ===============================================================
; 
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))
;
; Initialize a byte array priority queue structure at address p
; and set the queue's initial data and capacity members as
; well as the compare function.
; 
; priority_queue.size = 0
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_init

EXTERN asm_b_array_init

asm_ba_priority_queue_init:

   ; enter : hl = p
   ;         de = data
   ;         bc = capacity in bytes
   ;         ix = int (*compar)(const void *, const void *)
   ;
   ; exit  : hl = priority_queue *
   ;         carry reset
   ;
   ; uses  : af

   push de
   
   push ix
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de
   
   call asm_b_array_init
   
   dec hl
   dec hl
   
   ret
