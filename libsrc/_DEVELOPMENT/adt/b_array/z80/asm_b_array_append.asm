
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_append(b_array_t *a, int c)
;
; Append char to end of array, return index of appended char.
;
; ===============================================================

PUBLIC asm_b_array_append

EXTERN asm_b_array_append_block, error_enomem_mc

asm_b_array_append:

   ; enter : hl = array *
   ;         bc = int c
   ;
   ; exit  : bc = int c
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, de, hl
   
   push bc                     ; save char
   
   ld de,1
   call asm_b_array_append_block
   
   pop bc                      ; bc = char
   jp c, error_enomem_mc       ; if append error
   
   ld (hl),c                   ; append char to end
   
   ex de,hl                    ; de = & array.data[idx], hl = idx
   ret
