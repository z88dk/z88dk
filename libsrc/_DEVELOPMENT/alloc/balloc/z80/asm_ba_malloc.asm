
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_malloc(forward_list *q)
;
; Allocate a block of memory from the front of the queue.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_ba_malloc

LIB asm_forward_list_remove_after, error_enomem_zc

asm_ba_malloc:

   ; enter : hl = forward_list *q
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

   call asm_forward_list_remove_after
   
   ccf
   ret nc
   
   jp error_enomem_zc          ; if queue is empty
