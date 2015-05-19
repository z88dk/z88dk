
; =============================================================
; Jun 2012, May 2015 Patrik Rak
;
; modified by aralbrec
; * removed self-modifying code
; * seed passed in as parameter
; =============================================================
; 
; Generates an 8-bit random number from an 75-bit seed
; CMWC generator passes all diehard tests.
; http://www.worldofspectrum.org/forums/discussion/39632/cmwc-random-number-generator-for-z80
; 
; =============================================================

SECTION code_stdlib

PUBLIC asm_random_uniform_cmwc_8

asm_random_uniform_cmwc_8:

   ; enter : hl = seed * (75-bits, 10 bytes)
   ;
   ; exit  : a = random number [0,255]
   ;         seed updated
   ;
   ; uses  : af, bc, de, hl

   ld a,(hl)
   and 7                       ; a = rnd_i & 7

   inc (hl)                    ; rnd_i++
   inc hl                      ; hl = & rnd_cy

   inc a
   ld b,h
   add a,l
   ld c,a
   jr nc, no_inc
   inc b                       ; bc = & q[i]

no_inc:                        

   ld a,(bc)                   ; a = q[i] = y
   ld e,a
   ld d,a
   ld a,(hl)                   ; a = rnd_cy
   
   ; bc = & q[i]
   ; hl = & rnd_cy
   ; da = 256 * y + c
   ;  e = y

   sub e
   jr nc, skip0
   dec d                       ; da = 255 * y + c

skip0:

   sub e
   jr nc, skip1
   dec d                       ; da = 254 * y + c

skip1:

   sub e
   jr nc, skip2
   dec d                       ; da = 253 * y + c = t

skip2:

   ; bc = & q[i]
   ; hl = & rnd_cy
   ; da = t = 253 * y + c

   ld (hl),d                   ; c = t >> 8
   cpl                         ; x = (b-1) - x = -x - 1 = ~x + 1 - 1 = ~x

   ld (bc),a                   ; q[i] = x
   ret
