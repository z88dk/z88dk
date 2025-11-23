
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_append(b_array_t *a, int c)
;
; Append char to end of array, return index of appended char.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_append, asm0_b_array_append

EXTERN error_mc

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
   ;            carry set
   ;
   ; uses  : af, de, hl

   inc hl
   inc hl                      ; hl = & array.size

asm0_b_array_append:

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.size
   inc hl                      ; hl = & array.capacity

   ld a,(hl)
   inc hl
   
   cp e
   jr nz, room_available       ; if size != capacity
   
   ld a,(hl)
   
   cp d
   jp z, error_mc              ; if size == capacity

room_available:

   ; bc = int c
   ; hl = & array.capacity + 1b
   ; de = array.size

   inc de                      ; size++
   
   dec hl
   dec hl                      ; hl = & array.size + 1b

   ld (hl),d
   dec hl
   ld (hl),e                   ; array.size++
   dec hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = array.data
   
   dec de                      ; de = idx of char to append
   add hl,de                   ; hl = & array.data[idx]

   ld (hl),c                   ; append char
   
   ex de,hl                    ; de = & array.data[idx], hl = idx
   ret
