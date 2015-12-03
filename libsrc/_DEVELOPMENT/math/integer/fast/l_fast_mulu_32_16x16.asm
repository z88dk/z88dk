
SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_32_16x16

EXTERN l_fast_mulu_24_16x8, l0_fast_mulu_24_16x8, l1_fast_mulu_24_16x8

l_fast_mulu_32_16x16:

   ; unsigned multiplication of two 16-bit
   ; multiplicands into a 32-bit product
   ;
   ; enter : de = 16-bit multiplicand
   ;         hl = 16-bit multiplicand
   ;
   ; exit  : dehl = 32-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ; try to reduce the multiplication

   inc d
   dec d
   jp z, l1_fast_mulu_24_16x8

   inc h
   dec h
   jp z, l0_fast_mulu_24_16x8

   ; two full size multiplicands

   ; de = 16-bit multiplicand DE
   ; hl = 16-bit multiplicand HL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $04

   ld b,d                      ; b = D
   push hl                     ; save HL

   call l_fast_mulu_24_16x8         ; ahl = HL * E

ELSE

   push hl
   push de
   
   call l_fast_mulu_24_16x8
   
   pop bc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ex (sp),hl                  ; save LSW(HL * E)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $04

   ld e,b                      ; e = D
   ld b,a                      ; b = MSB(HL * E)
   
   call l_fast_mulu_24_16x8         ; ahl = HL * D

ELSE

   ld e,b
   push af
   
   call l_fast_mulu_24_16x8
   
   pop bc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ld c,b
   ld b,0                      ; bc = MSW(HL * E)
   
   ld d,l
   ld e,b                      ; bc = LSW(HL * D << 8)
   
   ld l,h
   ld h,a                      ; hl = MSW(HL * D << 8)

   add hl,bc
   ex de,hl                    ; de = MSW(result)
   
   pop bc                      ; bc = LSW(HL * E)
   add hl,bc                   ; hl = LSW(result)
   
   ret nc
   
   inc de
   
   or a
   ret

; loop code
;
; loop_12:
;
;   add hl,hl
;   rla
;   rl c
;   
;   jr nc, loop_13
;   
;   add hl,de
;   adc a,b
