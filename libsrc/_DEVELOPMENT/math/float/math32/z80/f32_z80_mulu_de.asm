;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;
; REPLICATION for Z80 of:
; Z180 MLT DE and Z80-ZXN MUL DE
;
; unsigned multiplication of two 8-bit
; multiplicands into a sixteen bit product
;
; enter : d = 8-bit multiplicand
;         e = 8-bit multiplicand
;
; exit  : de = 16-bit product
;         carry reset
;
; uses  : f, de
   
SECTION code_clib
SECTION code_math

PUBLIC m32_z80_mulu_de


.m32_z80_mulu_de

   inc d
   dec d
   jr Z,zero                ; multiply by 0

   inc e
   dec e
   jr Z,zero                ; multiply by 0

   push hl
   ex de,hl

   ld e,l
   ld d,0

   ; eliminate leading zero bits

   sla h
   jr C,branch_11

   sla h
   jr C,branch_12

   sla h
   jr C,branch_13

   sla h
   jr C,branch_14

   sla h
   jr C,branch_15

   sla h
   jr C,branch_16

   sla h
   jr C,branch_17

   sla h
   jr exit                ; multiply by 1
   
   ; multiplication tree

.branch_11
   add hl,hl
   jr NC,branch_12
   add hl,de

.branch_12
   add hl,hl
   jr NC,branch_13
   add hl,de

.branch_13
   add hl,hl
   jr NC,branch_14
   add hl,de

.branch_14
   add hl,hl
   jr NC,branch_15
   add hl,de

.branch_15
   add hl,hl
   jr NC,branch_16
   add hl,de

.branch_16
   add hl,hl
   jr NC,branch_17
   add hl,de

.branch_17
   add hl,hl
   jr NC,exit
   add hl,de

.exit
   ex de,hl
   pop hl
   or a
   ret

.zero
   ld de,0
   ret
