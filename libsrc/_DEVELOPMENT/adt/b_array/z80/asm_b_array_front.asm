
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_front(b_array_t *a)
;
; Return char stored at front of array.
;
; ===============================================================

XLIB asm_b_array_front

LIB __array_info, error_einval_mc

   inc hl
   inc hl

asm_b_array_front:

   ; enter : hl = array *
   ;
   ; exit  : de = array.data
   ;         bc = array.size
   ;
   ;         success
   ;
   ;            hl = char at front of array
   ;            carry reset
   ;
   ;         fail if array is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   call __array_info
   jp z, error_einval_mc       ; if array is empty
   
   ; de = array.data
   ; bc = array.size

   ld a,(de)
   
   ld l,a
   ld h,0                      ; hl = char at front of array
   
   ret
