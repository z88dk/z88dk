
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_append(w_array_t *a, void *item)
;
; Append word to end of array, return index of appended word.
;
; ===============================================================

XLIB asm_w_array_append
XDEF asm_w_array_push_back

LIB asm_b_array_append_block, error_enomem_mc

asm_w_array_append:
asm_w_array_push_back:

   ; enter : hl = array *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of appended word
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, de, hl
   
   push bc                     ; save item
   
   ld de,2
   call asm_b_array_append_block
   
   pop bc                      ; bc = item
   jp c, error_enomem_mc       ; if append error
   
   ld (hl),c                   ; append item to end
   inc hl
   ld (hl),b
   dec hl
   
   ex de,hl                    ; de = & array.data[idx], hl = idx in bytes
   
   srl h
   rr l
   
   ret
