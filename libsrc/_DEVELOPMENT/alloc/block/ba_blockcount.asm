
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_blockcount(int queue)
;
; Return number of free blocks in queue.  O(n).
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB ba_blockcount
XDEF asm_ba_blockcount

ba_blockcount:
asm_ba_blockcount:

   ; enter : hl = queue
   ;
   ; exit  : hl = number of available blocks
   ;         bc = number of available blocks (also)
   ;
   ; uses  : af, de, hl
   
   add hl,hl
   ld de,(__qtbl)              ; current queue table
   add hl,de                   ; hl = q
   
   ld bc,0

count_loop:

   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ld a,d
   or e
   jr z, end_q

   inc bc
   ex de,hl
   
   jp loop

end_q:

   ld l,c
   ld h,b
   ret
