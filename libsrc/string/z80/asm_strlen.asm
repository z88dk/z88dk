
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strlen(const char *s)
;
; Return length of string s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strlen

asm_strlen:

   ; enter: hl = char *s
   ;
   ; exit : hl = length
   ;        bc = -(length + 1)
   ;         a = 0
   ;        z flag set if 0 length
   ;        carry reset
   ;
   ; uses : af, bc, hl

   xor a
   ld c,a
   ld b,a

IF __CPU_INTEL__ || __CPU_GBZ80__
loop:
   ld a,(hl)
   inc hl
   dec bc
   and a
   jr Z,matched
   ld a,b
   or c
   jr NZ,loop
matched:
   push af
   ld a,$ff
   sub c
   ld  l,a
   ld  a,$ff
   sbc b
   ld  h,a
   pop af
   ld  a,0

ELSE
   cpir
   ld hl,$ffff
   sbc hl,bc
ENDIF

   ret
