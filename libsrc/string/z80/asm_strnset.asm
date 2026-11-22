
; ===============================================================
; Jan 2015 / Dec 2021 feilipu
; ===============================================================
; 
; char *strnset(char *s, int c, size_t n)
;
; Write at most n chars c into s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strnset

asm_strnset:

   ; enter : hl = char *s
   ;          e = int c
   ;         bc = size_t n
   ;
   ; exit  : hl = char *s
   ;         bc = remaining n
   ;
   ; uses  : af, bc
   
   ld a,b
   or c
   ret Z

   push hl

IF __CPU_INTEL__ || __CPU_GBZ80__

loop:
   xor a
   cp (hl)
   jr Z,exit

   ld (hl),e
   inc hl

   dec bc
   ld a,b
   or c
   jr NZ,loop

ELSE
   xor a
loop:
   cp (hl)
   jr Z,exit

   ld (hl),e

   cpi                         ; hl++, bc--
   jp PE,loop

ENDIF

exit:
   pop hl
   ret
