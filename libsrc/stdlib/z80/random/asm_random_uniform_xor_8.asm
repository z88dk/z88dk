
; ===============================================================
; Jan 2011 Patrik Rak
; ===============================================================
;
; Generates an 8-bit random number from a 32-bit seed.
; Marsaglia xor generator.
; http://www.worldofspectrum.org/forums/showpost.php?p=583693&postcount=3
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_random_uniform_xor_8

asm_random_uniform_xor_8:

   ; enter : dehl = seed (0 is invalid input)
   ;
   ; exit  :    a = random number
   ;         dehl = updated seed
   ;
   ; uses  : af, de, hl

   push de
   
   ld a,e
   add a,a
   add a,a
   add a,a
   xor e
   ld e,a
   ld a,h
   add a,a
   xor h
   ld d,a
   rra
   xor d
   xor e
   ld d,l
   ld e,a
   
   pop hl
   ret

;; Patrik's original code
;;
;;rnd     ld  hl,0xA280   ; xz -> yw
;;        ld  de,0xC0DE   ; yw -> zt
;;        ld  (rnd+1),de  ; x = y, z = w
;;        ld  a,e         ; w = w ^ ( w << 3 )
;;        add a,a
;;        add a,a
;;        add a,a
;;        xor e
;;        ld  e,a
;;        ld  a,h         ; t = x ^ (x << 1)
;;        add a,a
;;        xor h
;;        ld  d,a
;;        rra             ; t = t ^ (t >> 1) ^ w
;;        xor d
;;        xor e
;;        ld  h,l         ; y = z
;;        ld  l,a         ; w = t
;;        ld  (rnd+4),hl
;;        ret
