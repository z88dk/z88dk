
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_alloc(unsigned int queue)
;
; Allocate a block of memory from the front of the queue.
;
; ===============================================================

XLIB asm_ba_alloc

LIB asm_forward_list_remove_after, error_enomem_zc

asm_ba_alloc:

   ; enter : hl = unsigned int queue
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated block
   ;
   ;         fail
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl

   add hl,hl
   ld de,(__qbtl)
   add hl,de                   ; forward_list *q

   call asm_forward_list_remove_after
   
   ccf
   ret nc
   
   jp error_enomem_zc          ; if queue is empty
