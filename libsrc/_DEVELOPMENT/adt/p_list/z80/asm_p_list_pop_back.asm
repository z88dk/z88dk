
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_pop_back(p_list_t *list)
;
; Pop item from the back of the list.
;
; ===============================================================

XLIB asm_p_list_pop_back

LIB asm_p_list_remove

asm_p_list_pop_back:

   ; enter : hl = p_list_t *list
   ;
   ; exit  : bc = p_list_t *list
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
   jp nz, asm_p_list_remove
   
   ret
