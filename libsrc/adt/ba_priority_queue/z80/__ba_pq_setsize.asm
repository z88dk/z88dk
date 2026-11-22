SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC __ba_pq_setsize

EXTERN l_ltu_bc_hl, error_zc

__ba_pq_setsize:

   ; set the queue size as long as it remains <= queue.capacity
   ;
   ; enter : hl = queue *
   ;         de = n = desired size in bytes
   ;
   ; exit  : success
   ;
   ;            de = n
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

   push hl                     ; save queue *

   ld bc,7
   add hl,bc                   ; hl = & queue.capacity + 1b
   
   ld b,(hl)
   dec hl
   ld c,(hl)                   ; bc = queue.capacity
   
   ex de,hl                    ; hl = n
   
   call l_ltu_bc_hl
   jp c, error_zc - 1          ; if hl > bc, n > queue.capacity
   
   ex de,hl
   
   ; hl = & queue.capacity
   ; de = n
   ; stack = queue *
   
   dec hl
   ld (hl),d
   dec hl
   ld (hl),e                   ; queue.size = n
   
   pop hl                      ; hl = queue *
   
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   
   push bc
   pop ix                      ; ix = queue.compar
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = queue.data
   
   or a
   ret
