SECTION code_clib
SECTION code_adt_b_array

PUBLIC __array_make_room_best_effort
PUBLIC __0_array_make_room_best_effort

EXTERN __array_make_room, __0_array_make_room

__array_make_room_best_effort:

   ; Make room for n bytes at index idx (overwrite not insert)
   ; If idx > array.size, zero the resulting hole.
   ; If the array cannot hold all n bytes, make room for as
   ; many as possible.
   ;
   ; enter : de = & array.size
   ;         hl = n
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            hl = & array.data[idx]
   ;            bc = n_max
   ;             a = 0 if room for all n bytes available (bc == n)
   ;                -1 if room not available for all n bytes (bc < n)
   ;            carry reset
   ;
   ;         fail if idx > array.capacity
   ;
   ;            bc = idx
   ;            de = & array.capacity
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   call __array_make_room
   ret nc
   
   ; insufficient space in array, make best effort
   
   ex de,hl

__0_array_make_room_best_effort:

   ; hl = & array.size
   ; bc = idx
   
   inc hl
   inc hl 
   inc hl                      ; hl = & array.capacity + 1b
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = array.capacity

   ex de,hl
   
   ; hl = array.capacity
   ; de = & array.capacity
   ; bc = idx
   
   or a
   sbc hl,bc                   ; hl = new_n = array.capacity - idx
   ret c                       ; if array.capacity < idx

   call springboard            ; some items need to be on stack

   dec a                       ; a = -1
   ret

springboard:

   push hl                     ; save new_n
   push bc                     ; save idx
   
   ld l,e
   ld h,d
   
   inc hl                      ; hl = & array.capacity + 1b
   dec de                      ; de = & array.size + 1b
   
   ld a,(de)
   ldd
   ld b,a
   ld a,(de)
   ld c,a                      ; bc = old_size = array.size
   ld a,(hl)
   ld (de),a                   ; array.size = array.capacity
   
   dec hl                      ; hl = & array.size + 1b

   ; hl = & array.size + 1b
   ; bc = old_size
   ; stack = new_n, idx
   
   jp __0_array_make_room      ; fill possible hole at idx
