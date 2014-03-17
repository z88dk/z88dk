
; ===============================================================
; Mar 2014
; ===============================================================
; 
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))
;
; Initialize a word array priority queue structure at address p
; and set the queue's initial data and capacity members as
; well as the compare function.
; 
; priority_queue.size = 0
;
; ===============================================================

XLIB asm_wa_priority_queue_init

LIB asm_ba_priority_queue_init, error_einval_zc

asm_wa_priority_queue_init:

   ; enter : hl = p
   ;         de = data
   ;         bc = capacity in words
   ;         ix = int (*compar)(const void *, const void *)
   ;
   ; exit  : success
   ;
   ;            hl = priority_queue *
   ;            carry reset
   ;
   ;         fail if capacity too large
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc

   sla c
   rl b
   jp nc, asm_ba_priority_queue_init
   
   jp error_einval_zc
