
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_FRONT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_list_front(p_list_t *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

asm_p_list_front:

   ; enter : hl = p_list_t *list
   ;
   ; exit  : hl = void *item (item at front, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl
