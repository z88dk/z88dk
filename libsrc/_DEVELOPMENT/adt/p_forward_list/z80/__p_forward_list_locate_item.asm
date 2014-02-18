
XLIB __p_forward_list_locate_item

__p_forward_list_locate_item:

   ; enter : hl = forward_list_t *list
   ;         bc = void *item
   ;
   ; exit  : bc = void *item
   ;
   ;         if item found
   ;
   ;            de = void *item_prev_prev (item before hl)
   ;            hl = void *item_prev (item before bc)
   ;            carry reset
   ;
   ;         if item not found
   ;
   ;            de = void *item_last_prev (item before last)
   ;            hl = void *item_last (last item in list)
   ;            carry set
   ;
   ; notes : if list is empty
   ;
   ;            de = forward_list_t *list
   ;            hl = forward_list_t *list
   ;            carry set
   ;
   ;         if list has one item that matches bc
   ;
   ;            de = forward_list_t *list
   ;            hl = forward_list_t *list
   ;            carry reset
   ;
   ;         if list has one item that does not match bc
   ;
   ;            de = forward_list_t *list
   ;            hl = void *item_last (the only item in the list)
   ;            carry set
   ; 
   ; uses  : af, de, hl

   ld e,l
   ld d,h

loop:

   ; de = void *lagger
   ; hl = void *current
   
   ld a,(hl)
   inc hl
   
   or (hl)
   jr z, list_end

   cp c
   
   ld a,(hl)
   dec hl
   
   jr nz, not_found
   
   cp b
   ret z                       ; item found
   
not_found:

   ld e,l
   ld d,h                      ; de = new lagger
   
   ld l,(hl)
   ld h,a                      ; hl = new current
   
   jp loop

list_end:

   dec hl
   
   ; de = void *lagger
   ; hl = void *item_back
   
   scf
   ret
