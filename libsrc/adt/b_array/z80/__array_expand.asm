SECTION code_clib
SECTION code_adt_b_array

PUBLIC __array_expand
PUBLIC __0_array_expand, __1_array_expand

EXTERN l_ltu_bc_hl

__array_expand:

   ; Attempt to expand the committed portion of the array to n bytes.
   ;
   ; If the current committed size, array.size, is smaller than n
   ; and array.capacity >= n, then array.size is set equal to n.
   ;
   ; enter : hl = & array.size
   ;         de = n
   ;
   ; exit  : hl = & array.size + 1b
   ;         de = n
   ;         bc = old array.size
   ;
   ;         success
   ;
   ;             a = 0 if success and n <= array.size
   ;               = 1 if success and n > array.size
   ;             carry reset
   ;
   ;         fail if n > array.capacity
   ;
   ;             carry set
   ;
   ; uses  : af, bc, hl

   ld c,(hl)
   inc hl                      ; hl = & array.size + 1b
   ld b,(hl)                   ; bc = array.size

   ex de,hl

__0_array_expand:

   ; hl = n
   ; de = & array.size + 1b
   ; bc = array.size

   call l_ltu_bc_hl
   jr c, size_exceeded         ; if hl > bc, n > array.size

size_sufficient:

   ; n <= array.size

   ; hl = n
   ; de = & array.size + 1b
   ; bc = array.size

   ex de,hl

   xor a
   ret

size_exceeded:
__1_array_expand:

   ; n > array.size
   
   ; hl = n
   ; de = & array.size + 1b
   ; bc = array.size

   ex de,hl
   
   ; hl = & array.size + 1b
   ; de = n
   ; bc = array.size
   
   push hl                     ; save & array.size + 1b
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = array.capacity
   
   or a
   sbc hl,de                   ; hl = array.capacity - n
   
   pop hl                      ; hl = & array.size + 1b
   
   ; hl = & array.size + 1b
   ; de = n
   ; bc = array.size
   
   ret c                       ; if array.capacity < n, fail
   
   ; n <= array.capacity
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; array.size = n
   inc hl
   
   ld a,1
   ret
