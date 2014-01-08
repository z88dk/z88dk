
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t forward_list_size(forward_list *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_size
XDEF asm_ba_blockcount, asm_forward_list_alt_size, asm_list_size

asm_forward_list_size:
asm_forward_list_alt_size:
asm_ba_blockcount:
asm_list_size:

   ; enter : hl = forward_list *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
   
   ld de,$ffff

loop:

   inc de
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, loop

   ex de,hl
   ret
