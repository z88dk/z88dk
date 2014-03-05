
XLIB __vector_resize
XDEF __vector_resize_extra, __0_vector_resize_extra

LIB __vector_reserve_extra, error_znc

__vector_resize:

   ld de,0

__vector_resize_extra:

   ; Adjust the vector's size by growing the vector's
   ; size indicator, vector.size, as necessary.  Vector.size
   ; is only altered if the size grows; if the new size
   ; grows beyond the vector's current capacity, a realloc
   ; will be attempted to get more memory.
   ;
   ; enter : bc = new_size
   ;         de = extra
   ;         hl = & vector.size + 1b
   ;
   ; exit  : bc = new_size
   ;         de = & vector.size + 1b
   ;
   ;         success if new_size <= vector.size
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         success if new_size > vector.size and no realloc was performed
   ;
   ;            hl = -1
   ;            vector.size = new_size
   ;            carry reset
   ;
   ;         success if new_size > vector.size and realloc was performed
   ;
   ;            hl = -2
   ;            vector.size = new_size
   ;            vector.capacity = new_size + extra
   ;            carry reset
   ;
   ;         fail if vector cannot be grown
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, de, hl

   push de                     ; save extra
   
   dec hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.size
   
   ex de,hl                    ; hl = vector.size

   ; bc = new_size
   ; de = & vector.size + 1b
   ; hl = vector.size
   ; stack = extra

   or a
   sbc hl,bc                   ; hl = vector.size - new_size
   jp nc, error_znc - 1        ; if vector.size >= new_size, indicate success

   ; vector size increasing, may need to grow capacity
   
   ex de,hl                    ; hl = & vector.size + 1b
   pop de                      ; de = extra

__0_vector_resize_extra:

   ; bc = new_size
   ; de = extra
   ; hl = & vector.size + 1b
   
   call __vector_reserve_extra
   
   dec de
   dec de                      ; de = & vector.size + 1b
   
   ; bc = new_size
   ; de = & vector.size + 1b
   ; hl, carry flag = error status
   
   ret c                       ; if vector reserve failed
   
   ex de,hl                    ; hl = & vector.size + 1b
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; vector.size = new_size
   inc hl
   
   ex de,hl                    ; de = & vector.size + 1b
   
   dec hl                      ; hl = -1 if no realloc, -2 if realloc
   ret
