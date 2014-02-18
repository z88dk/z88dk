
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_back(p_list_t *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

XLIB asm_p_list_back

LIB asm_p_forward_list_front

asm_p_list_back:

   ; enter : hl = p_list_t *list
   ;
   ; exit  : hl = void *item (item at back, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl

   inc hl
   inc hl                      ; hl = & p_list_t->tail
   
   jp asm_p_forward_list_front
