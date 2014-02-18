
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_back(p_forward_list_alt_t *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

XLIB asm_p_forward_list_alt_back
XDEF asm_p_queue_back

LIB asm_p_forward_list_alt_front

LIB error_znc

asm_p_forward_list_alt_back:
asm_p_queue_back:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : hl = void *item (item at back, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl

   ld a,(hl)
   inc hl
   or (hl)
   jp z, error_znc   

   inc hl
   jp asm_p_forward_list_alt_front
