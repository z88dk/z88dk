
SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC __wa_pq_setsize

EXTERN __ba_pq_setsize, error_zc

__wa_pq_setsize:

   ; set the queue size as long as it remains <= queue.capacity
   ;
   ; enter : hl = queue *
   ;         de = n = desired size in words
   ;
   ; exit  : success
   ;
   ;            de = n*2 = size in bytes
   ;            bc = queue.data
   ;            ix = queue.compar
   ;            carry reset
   ;
   ;         fail if queue capacity too small
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix
   
   sla e
   rl d
   jp nc, __ba_pq_setsize
   
   jp error_zc
