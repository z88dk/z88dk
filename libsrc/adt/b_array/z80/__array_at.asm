
SECTION code_clib
SECTION code_adt_b_array

PUBLIC __array_at

EXTERN l_ltu_bc_hl

__array_at:

   ; Return & array.data[idx]
   ;
   ; enter : hl = array *
   ;         bc = idx
   ;
   ; exit  : bc = idx
   ;         de = array.size
   ;
   ;         success
   ;
   ;            hl = & array.data[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = & array.data[0]
   ;            carry set
   ;
   ; uses  : af, de, hl

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.data
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = array.size
   
   call l_ltu_bc_hl
   
   ex de,hl                    ; de = array.size, hl = array.data
   
   ccf
   ret c                       ; if bc >= hl, idx >= array.size

   add hl,bc
   ret
