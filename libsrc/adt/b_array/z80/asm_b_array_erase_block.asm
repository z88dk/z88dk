
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_erase_block(b_array_t *a, size_t idx, size_t n)
;
; Remove bytes at indices [idx, idx+n) from the array by copying
; data backward and adjusting array.size.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_erase_block
PUBLIC asm0_b_array_erase_block

EXTERN error_mc, l_neg_hl, asm_memcpy

asm_b_array_erase_block:

   ; enter : hl = array *
   ;         bc = idx
   ;         de = n
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx = index of first byte following erased
   ;            carry reset
   ;
   ;         fail if block at least partly extends outside array.data
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl

asm0_b_array_erase_block:

   ld a,(hl)
   inc hl
   
   push bc                     ; save idx
   push hl                     ; save & array.size + 1b
   push de                     ; save n
   
   ld h,(hl)
   ld l,a
   
   ex de,hl                    ; de = array.size, hl = n
   
   add hl,bc                   ; hl = idx + n
   jp c, error_mc - 3          ; if (idx + n) > 64k

   sbc hl,de                   ; hl = idx + n - array.size
   jr z, range_ok              ; if (idx + n) == array.size
   jp nc, error_mc - 3         ; if (idx + n) > array.size

range_ok:

   call l_neg_hl               ; hl = array.size - (idx + n)

   ; de = array.size
   ; hl = num bytes to copy
   ; stack = idx, & array.size + 1b, n

   pop bc                      ; bc = n
   ex de,hl                    ; hl = array.size
   
   or a
   sbc hl,bc                   ; hl = array.size - n = new_size

   ; bc = n
   ; hl = new_size
   ; de = num bytes to copy
   ; stack = idx, & array.size + 1b
   
   ex de,hl                    ; de = new_size
   ex (sp),hl                  ; hl = & array.size + 1b
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; array.size = new_size

   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = array.data

   ; bc = n
   ; de = array.data
   ; stack = idx, num bytes to copy

   pop af
   pop hl
   push hl
   push af
   
   ; bc = n
   ; de = array.data
   ; hl = idx
   ; stack = idx, num bytes to copy
   
   add hl,de                   ; hl = idx + array.data

   ld e,l
   ld d,h                      ; de = & array.data[idx]
   
   add hl,bc                   ; hl = & array.data[idx+n]

   pop bc                      ; bc = num bytes to copy

   call asm_memcpy
   
   pop de                      ; de = idx
   
   ex de,hl
   ret
