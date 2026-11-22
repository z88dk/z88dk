
; two-pass 32/16 unsigned divide.  Same register contract as
; l_fast_divu_32_32x16 / l_divu_32_32x16.  No unroll.

SECTION code_clib
SECTION code_math

PUBLIC l_small_divu_32_32x16, l0_small_divu_32_32x16

EXTERN error_divide_by_zero_mc


l_small_divu_32_32x16:

   ; unsigned division of 32-bit number by 16-bit number
   ;
   ; enter : dehl = 32-bit dividend
   ;           bc = 16-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;            dehl'= 16-bit remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,b
   or c
   jr z, divide_zero

l0_small_divu_32_32x16:

   ; skip divide by zero check

   push hl                     ; nLSW
   ld hl,de                    ; HL = nMSW
   ld de,hl                    ; rem candidate = MSW
   or a
   sbc hl,bc
   jr c, msw_small             ; MSW < D: quot MSW = 0, rem = MSW
   ld hl,de
   ld de,0
   call d16_pass
   jr have_msw
msw_small:
   ld hl,0                     ; DE = rem = nMSW
have_msw:
   ex (sp),hl                  ; HL = nLSW, (sp) = quot MSW
   call d16_pass               ; HL = quot LSW, DE = rem
   pop bc                      ; quot MSW
   push de                     ; rem
   ld de,bc                    ; dehl = quotient
   exx
   pop hl
   ld de,0                     ; dehl' = remainder
   exx
   or a
   ret

divide_zero:

   exx
   ld de,$ffff
   jp error_divide_by_zero_mc

; HL = dividend half in / quot half out, DE = rem, BC = divisor, A destroyed.
d16_pass:
   ld a,16
d16_loop:
   add hl,hl                   ; Q <<= 1, CF = dividend bit
IF __CPU_RABBIT__
   rl de
ELSE
   rl e
   rl d
ENDIF
   jr c, d16_force
   ex de,hl
   sbc hl,bc                   ; C is 0 (no rem overflow)
   jr c, d16_restore
   ex de,hl
   inc hl
d16_next:
   dec a
   jr nz, d16_loop
   ret
d16_restore:
   add hl,bc
   ex de,hl
   jr d16_next
d16_force:
   ex de,hl
   or a
   sbc hl,bc                   ; wrap of R17-D, no borrow-in
   ex de,hl
   inc hl
   jr d16_next
