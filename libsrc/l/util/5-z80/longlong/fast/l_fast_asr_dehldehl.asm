
SECTION code_clib
SECTION code_l

PUBLIC l_fast_asr_dehldehl

EXTERN l_asr_dehl
EXTERN error_llznc, error_llmnc

l_fast_asr_dehldehl:

   ; arithmetic shift right 64-bit number
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl >> a
   ;
   ; uses  : af, b, de, hl, de', hl'

   or a
   ret z

   cp 64
   jr nc, shift_infinite
   
   sub 32
   jr c, shift_64

   ; shift at least 32 bits
   
   exx
   
   call l_asr_dehl
   ld a,d
   
   exx
   
   add a,a
   sbc a,a
   
   ld d,a
   ld e,a
   ld h,a
   ld l,a
   
   exx
   ret

shift_64:

   add a,32

loop:

   sub 8
   jr c, fine_shift
   
   ld b,a
   
   exx
   
   ld a,l
   ld l,h
   ld h,e
   ld e,d
   
   exx
   
   ld l,h
   ld h,e
   ld e,d
   ld d,a
   
   exx
   
   ld a,d
   add a,a
   sbc a,a
   ld d,a
   
   exx
   
   ld a,b
   jr loop

fine_shift:

   add a,8
   ret z
   
   ld b,a
   ld a,e
   
shift_loop:
 
   exx
   
   sra d
   rr e
   rr h
   rr l
   
   exx
   
   rr d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret

shift_infinite:

   exx
   bit 7,d
   exx
   
   jp z, error_llznc
   jp error_llmnc
