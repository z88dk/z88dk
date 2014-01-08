
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_front(forward_list *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

XLIB asm_forward_list_front
XDEF asm_forward_list_alt_front, asm_list_front

asm_forward_list_front:
asm_forward_list_alt_front:
asm_list_front:

   ; enter : hl = forward_list *list
   ;
   ; exit  : hl = void *item (item at front, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   ret
