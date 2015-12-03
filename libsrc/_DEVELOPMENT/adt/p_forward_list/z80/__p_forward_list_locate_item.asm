SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC __p_forward_list_locate_item

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
   cp c
   
   inc hl
   jr z, match_possible

   or (hl)
   dec hl
   
   jr z, list_end

try_next:

   ld e,l
   ld d,h                      ; de = new lagger
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   jr loop

match_possible:

   ld a,(hl)
   cp b
   
   dec hl
   ret z                       ; item found

   or (hl)
   jr nz, try_next             ; if not at end of list

list_end:
   
   ld a,b
   or c
   ret z                       ; do not indicate error if searching for end
   
   ; de = void *lagger
   ; hl = void *item_back
   
   scf
   ret
