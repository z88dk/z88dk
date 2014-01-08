
XLIB __forward_list_locate_item

__forward_list_locate_item:

   ; enter : hl = forward_list *list
   ;         bc = void *item
   ;
   ; exit  : de = void *lagger (item prior to prior)
   ;         hl = void *item_prev (item prior)
   ;         bc = void *item
   ;
   ;         carry set if end of list reached, item not found
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
