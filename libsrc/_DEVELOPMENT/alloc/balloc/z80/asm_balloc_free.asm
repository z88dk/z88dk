
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void balloc_free(void *m)
;
; Push block m onto the front of its queue for later reallocation. 
; If m == NULL, ignore as with free().
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC asm_balloc_free

EXTERN __balloc_array
EXTERN asm_p_forward_list_insert_after

asm_balloc_free:

   ; enter : hl = address of block to free
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl
   
   ld a,h
   or l
   ret z                       ; if address == 0

   ld e,l
   ld d,h                      ; de = void *item to free
   
   dec hl
   ld l,(hl)
   ld h,0                      ; hl = queue item belongs to
   
   add hl,hl
   
   ld bc,(__balloc_array)
   add hl,bc                   ; hl = p_forward_list *q
   
   jp asm_p_forward_list_insert_after
