SECTION code_clib
SECTION code_adt_b_vector

PUBLIC __vector_make_room_best_effort
PUBLIC __vector_make_room_best_effort_extra

EXTERN error_zc
EXTERN __vector_make_room_extra, __array_make_room_best_effort, l_inc_sp

__vector_make_room_best_effort:

   exx
   ld de,0
   exx

__vector_make_room_best_effort_extra:

   ; Make room for n bytes at index idx (overwrite not insert).
   ; If idx > vector.size, zero the resulting hole.
   ; If the vector cannot hold all n bytes, make room for as
   ; many as possible.
   ;
   ; enter : de = & vector.size
   ;         hl = n
   ;         bc = idx
   ;         de'= extra
   ;
   ; exit  : de'= extra
   ;
   ;         success
   ;
   ;            hl = & vector.data[idx]
   ;            bc = n_new
   ;             a = 0 if realloc performed
   ;               =-1 if n_new < n
   ;            carry reset
   ;            
   ;         fail if idx > array.capacity and vector could not grow
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save & vector.size
   push bc                     ; save idx
   
   call __vector_make_room_extra
   jp nc, l_inc_sp - 4         ; if success pop two items and return

   pop bc                      ; bc = idx
   pop hl                      ; hl = & vector.size
   
   call __array_make_room_best_effort
   ret nc
   
   jp error_zc
