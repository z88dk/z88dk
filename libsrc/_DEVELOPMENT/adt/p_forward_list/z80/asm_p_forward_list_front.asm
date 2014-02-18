
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_front(p_forward_list_t *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

XLIB asm_p_forward_list_front
XDEF asm_p_forward_list_alt_front, asm_p_list_front
XDEF asm_p_stack_top, asm_p_queue_front

asm_p_forward_list_front:
asm_p_forward_list_alt_front:
asm_p_list_front:
asm_p_stack_top:
asm_p_queue_front:

   ; enter : hl = p_forward_list_t *list
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
