
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t ba_blockcount(forward_list *q)
;
; Return number of free blocks in the queue.  O(n).
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_ba_blockcount

LIB asm_forward_list_size

asm_ba_blockcount:

   ; enter : hl = forward_list *q
   ;
   ; exit  : hl = number of available blocks
   ;
   ; uses  : af, de, hl
   
   jp asm_forward_list_size
