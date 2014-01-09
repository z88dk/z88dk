
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_pop_back(list *list)
;
; Pop item from the back of the list.
;
; ===============================================================

XLIB asm_list_pop_back

LIB asm_list_remove

asm_list_pop_back:

   ; enter : hl = list *list
   ;
   ; exit  : bc = list *list
   ;         hl = void *item (0 if none)
   ;
   ; uses  : af, bc, de, hl
   
   ld c,l
   ld b,h
   
   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, asm_list_remove
   
   ret
