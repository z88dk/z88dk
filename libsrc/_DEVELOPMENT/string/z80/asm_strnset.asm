
; ===============================================================
; Jan 2015
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
   xor a

loop:

   cp (hl)
   jp Z, exit

   ld (hl),e

IF __CPU_INTEL__ || __CPU_GBZ80__
   EXTERN __z80asm__cpi
   call __z80asm__cpi
   ld a,b
   or c 
   ld a,0
   jp NZ,loop
ELSE
   cpi                         ; hl++, bc--
   jp PE, loop
ENDIF

exit:

   pop hl
   ret
