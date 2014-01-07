
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_alt_push_back(forward_list_alt *list, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Add item to the end of the list.
;
; ===============================================================

XLIB asm_forward_list_alt_push_back

LIB asm_forward_list_alt_insert_after

asm_forward_list_alt_push_back:

   ; enter : bc = forward_list_alt *list
   ;         de = void *item
   ;
   ; exit  : bc = forward_list_alt *list
   ;         hl = void *item
   ;
   ; uses  : af, de, hl
   
   inc bc
   inc bc
   
   ld a,(bc)
   ld l,a
   inc bc
   ld a,(bc)
   ld h,a                      ; hl = list->tail
   
   dec bc
   dec bc
   dec bc                      ; bc = list
   
   jp asm_forward_list_alt_insert_after
