

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_alt_back(forward_list_alt *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

XLIB asm_forward_list_alt_back
XDEF asm_list_back

LIB asm_forward_list_alt_front

asm_forward_list_alt_back:
asm_list_back:

   ; enter : hl = forward_list_alt *list
   ;
   ; exit  : hl = void *item (item at back, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl

   inc hl
   inc hl
   
   jp asm_forward_list_alt_front
