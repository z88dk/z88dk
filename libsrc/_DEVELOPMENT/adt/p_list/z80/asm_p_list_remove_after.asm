
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_remove_after(p_list_t *list, void *list_item)
;
; Remove item following list_item from the list.
;
; ===============================================================

XLIB asm_p_list_remove_after

LIB asm_p_list_remove

asm_p_list_remove_after:

   ; enter : bc = p_list_t *list
   ;         hl = void *list_item
   ;
   ; exit  : bc = p_list_t *list
   ;         hl = void *item (0 if none)
   ;
   ; uses  : af, de, hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, asm_p_list_remove

   ret
