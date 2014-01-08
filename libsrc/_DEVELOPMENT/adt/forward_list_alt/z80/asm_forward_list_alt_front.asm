
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_FRONT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_alt_front(forward_list_alt *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

asm_forward_list_alt_front:

   ; enter : hl = forward_list_alt *list
   ;
   ; exit  : hl = void *item (item at front, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl
