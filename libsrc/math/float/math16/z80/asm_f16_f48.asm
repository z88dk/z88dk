;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, June 2020
;
;-------------------------------------------------------------------------
;  asm_f32_f48 - z80, z180, z80n unpacked format conversion code
;-------------------------------------------------------------------------
;
; convert math48 double to IEEE-754 float
;
; enter : AC' = math48 double
;
; exit  : DEHL = IEEE-754 float
;         (exx set is swapped)
;
; uses  : af, bc, de, hl, bc', de', hl'
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN error_lznc

PUBLIC asm_f32_f48
PUBLIC asm_f48_f32

.asm_f32_f48
   exx

   ld a,l
   sub 2
   jp C,error_lznc

   sla b
   rra
   rr b

   ld e,b
   ld h,c
   ld l,d
   ld d,a
   ret


;-------------------------------------------------------------------------
;  asm_f48_f32 - z80, z180, z80n unpacked format conversion code
;-------------------------------------------------------------------------
;
; convert IEEE-754 float to math48 float
;
; enter : DEHL = IEEE-754 float
;
; exit  : AC' = math48 float
;         (exx set is swapped)
;
; uses  : f, bc, de, hl, bc', de', hl'
;
;-------------------------------------------------------------------------

.asm_f48_f32
   ex de,hl
   ld a,d
   or e
   or h
   or l
   jr Z, zero48

   add hl,hl
   rr l
   inc h
   inc h

.zero48
   ld c,d
   ld d,e
   ld b,l
   ld l,h
   
   ld e,0
   ld h,e
   exx

   ret

