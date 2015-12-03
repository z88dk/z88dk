
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t p_forward_list_size(p_forward_list_t *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_size

asm_p_forward_list_size:

   ; enter : hl = p_forward_list_t *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
   
   ld de,$ffff

loop:

   inc de
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jr nz, loop

   ex de,hl
   ret
