
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t ba_blockcount(unsigned int queue)
;
; Return number of free blocks in the queue.  O(n).
;
; ===============================================================

XLIB asm_ba_blockcount

LIB asm_forward_list_size

asm_ba_blockcount:

   ; enter : hl = unsigned int queue
   ;
   ; exit  : hl = number of available blocks
   ;
   ; uses  : af, de, hl

   add hl,hl
   ld de,(__qbtl)
   add hl,de                   ; forward_list *q

   jp asm_forward_list_size
