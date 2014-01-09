
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_FRONT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *list_front(list *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

asm_list_front:

   ; enter : hl = list *list
   ;
   ; exit  : hl = void *item (item at front, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl
