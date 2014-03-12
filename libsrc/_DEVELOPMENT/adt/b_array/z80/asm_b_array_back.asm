
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

XLIB asm_b_array_back
XDEF asm_b_vector_back

LIB __array_info, error_einval_mc

asm_b_array_back:
asm_b_vector_back:

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
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
   
   call __array_info
   jp z, error_einval_mc

   ex de,hl                    ; hl = array.data
   
   dec hl
   add hl,bc                   ; hl = array.data + array.size - 1b
   
   ld e,(hl)
   ld d,0
   
   ex de,hl
   ret
