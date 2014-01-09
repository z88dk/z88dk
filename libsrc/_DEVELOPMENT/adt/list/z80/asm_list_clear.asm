
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_LIST_INIT

; ===============================================================
; Jan 2014
; ===============================================================
; 
; void list_clear(list *list)
;
; Clear list to empty.
;
; ===============================================================

asm_list_clear:

   ; enter : hl = list *
   ;
   ; exit  : de = list *
   ;
   ; uses  : af, de, hl
