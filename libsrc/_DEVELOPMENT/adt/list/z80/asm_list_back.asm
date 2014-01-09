
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_back(list *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

XDEF asm_list_back

LIB asm_forward_list_front

asm_list_back:

   ; enter : hl = list *list
   ;
   ; exit  : hl = void *item (item at back, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl

   inc hl
   inc hl                      ; hl = & list->tail
   
   jp asm_forward_list_front
