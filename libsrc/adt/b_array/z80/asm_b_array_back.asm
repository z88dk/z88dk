
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_back(b_array_t *a)
;
; Return char stored at the end of the array.
; If the array is empty, return -1.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_back

EXTERN __array_info, error_mc

asm_b_array_back:

   ; enter : hl = array *
   ;
   ; exit  : success
   ;
   ;            de = & last char in array
   ;            hl = last char in array
   ;            carry reset
   ;
   ;         fail if array is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
   
   call __array_info
   jp z, error_mc

   ex de,hl                    ; hl = array.data
   
   dec hl
   add hl,bc                   ; hl = array.data + array.size - 1b
   
   ld e,(hl)
   ld d,0
   
   ex de,hl
   ret
