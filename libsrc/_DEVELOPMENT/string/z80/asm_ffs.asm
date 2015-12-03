
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int ffs(int i)
;
; Return bit position of least significant bit set.  Bit
; positions are numbered 1-16 with 0 returned if no bits
; are set.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_ffs
PUBLIC asm0_ffs, asm1_ffs, asm2_ffs

asm_ffs:

   ; enter : hl = int
   ;
   ; exit  : hl = bit pos or 0 if no set bits
   ;         carry set if set bit present
   ;
   ; uses  : af, hl
   
   ld a,l
   or a
   jr nz, bits_1_8
   
   ld a,h
   or a
   ret z

asm1_ffs:
bits_9_16:

   ld hl,9

asm2_ffs:
loop:

   rra
   ret c
   
   inc l
   jr loop

asm0_ffs:
bits_1_8:

   ld hl,1
   jr loop
