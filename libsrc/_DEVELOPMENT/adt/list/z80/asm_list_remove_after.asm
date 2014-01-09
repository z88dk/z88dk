
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_remove_after(list *list, void *list_item)
;
; Remove item following list_item from the list.
;
; ===============================================================

XLIB list_remove_after

LIB list_remove

list_remove_after:

   ; enter : bc = list *list
   ;         hl = void *list_item
   ;
   ; exit  : bc = list *list
   ;         hl = void *item (0 if none)
   ;
   ; uses  : af, de, hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, list_remove

   ret
