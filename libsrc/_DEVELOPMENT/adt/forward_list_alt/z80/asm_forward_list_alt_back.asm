
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

LIB asm_forward_list_alt_front

LIB error_znc

asm_forward_list_alt_back:

   ; enter : hl = forward_list_alt *list
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
   jp asm_forward_list_alt_front
