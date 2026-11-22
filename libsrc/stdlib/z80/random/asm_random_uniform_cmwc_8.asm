
; =============================================================
; Jun 2012, May 2015 Patrik Rak
; =============================================================
; modified by aralbrec
; * removed self-modifying code
; * seed passed in as parameter
; =============================================================
; Generates an 8-bit random number from an 75-bit seed
; CMWC generator passes all diehard tests.
; http://www.worldofspectrum.org/forums/discussion/39632/cmwc-random-number-generator-for-z80
; =============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_random_uniform_cmwc_8

asm_random_uniform_cmwc_8:

   ; enter : hl = seed * (75-bits, 10 bytes)
   ;
   ; exit  : a = random number [0,255]
   ;         seed updated
   ;
   ; uses  : af, bc, de, hl

   ld   a,(hl)                 ; i = ( i & 7 ) + 1
   and  7
   inc  a
   ld   (hl),a

   inc  hl                     ; hl = &cy

   ld   b,h                    ; bc = &q[i]
   add  a,l
   ld   c,a
   jr   nc,ASMPC+3
   inc  b

   ld   a,(bc)                 ; y = q[i]
   ld   d,a
   ld   e,a
   ld   a,(hl)                 ; da = 256 * y + cy

   sub  e                      ; da = 255 * y + cy
   jr   nc,ASMPC+3
   dec  d
   sub  e                      ; da = 254 * y + cy
   jr   nc,ASMPC+3
   dec  d
   sub  e                      ; da = 253 * y + cy
   jr   nc,ASMPC+3
   dec  d

   ld   (hl),d                 ; cy = da >> 8, x = da & 255
   cpl                         ; x = (b-1) - x = -x - 1 = ~x + 1 - 1 = ~x
   ld   (bc),a                 ; q[i] = x

   ret
