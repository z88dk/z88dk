
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_alt_pop_back(forward_list_alt *list)
;
; Pop the item from the back of the list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_alt_pop_back

LIB asm_forward_list_alt_remove_after

asm_forward_list_alt_pop_back:

   ; enter : hl = forward_list_alt *list
   ;
   ; exit  : bc = forward_list_alt *list
   ;         hl = void *item (item popped, 0 if none)
   ;         carry reset if list is empty
   ;
   ; uses  : af, de, hl

   ld e,l
   ld d,h
   
   ld c,l
   ld b,h
   
loop:
   
   ; de = void *lagger
   ; hl = void *current
   
   ld a,(hl)
   inc hl
   or (hl)
   jr z, list_end

   ld a,(hl)
   dec hl
   
   ld e,l
   ld d,h                      ; de = new lagger
   
   ld l,(hl)
   ld h,a                      ; hl = new current
   
   jp loop

list_end:

   ; de = void *lagger

   ex de,hl
   jp asm_forward_list_alt_remove_after
