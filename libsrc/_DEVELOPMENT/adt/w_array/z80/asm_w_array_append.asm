
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_append(w_array_t *a, void *item)
;
; Append word to end of array, return index of appended word.
;
; ===============================================================

SECTION seg_code_w_array

PUBLIC asm_w_array_append
PUBLIC asm1_w_array_append

EXTERN asm_b_array_append_block, error_mc

asm_w_array_append:

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
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   push bc                     ; save item
   
   ld de,2
   call asm_b_array_append_block
   
   pop bc                      ; bc = item
   jp c, error_mc              ; if append error

asm1_w_array_append:

   ld (hl),c                   ; append item to end
   inc hl
   ld (hl),b
   dec hl
   
   ex de,hl                    ; de = & array.data[idx], hl = idx in bytes
   
   srl h
   rr l
   
   ret
