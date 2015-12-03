
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_append(w_array_t *a, void *item)
;
; Append word to end of array, return index of appended word.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_append, asm0_w_array_append

EXTERN asm_b_array_append_block, error_mc

asm_w_array_append:

   ; enter : hl = array *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of appended word
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

asm0_w_array_append:

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.size (bytes)
   inc hl                      ; hl = & array.capacity (bytes)
   
   ld a,(hl)
   inc hl
   
   cp e
   jr nz, room_available       ; if size != capacity
   
   ld a,(hl)
   
   cp d
   jp z, error_mc              ; if size == capacity

room_available:

   ; bc = item
   ; hl = & array.capacity + 1b
   ; de = array.size (bytes)
   
   inc de
   inc de                      ; size += 2
   
   dec hl
   dec hl                      ; hl = & array.size + 1b
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; array.size += 2
   dec hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = array.data
   
   dec de
   add hl,de
   
   ld (hl),b
   dec hl                      ; hl = & array.data[idx]
   ld (hl),c                   ; append item
   
   dec de                      ; de = idx of appended item in bytes
   
   ex de,hl                    ; hl = idx in bytes, de = & array.data[idx]
   
   srl h
   rr l                        ; hl = idx in words
   
   ret
