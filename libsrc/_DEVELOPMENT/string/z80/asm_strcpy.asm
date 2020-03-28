
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strcpy(char * restrict s1, const char * restrict s2)
;
; Copy string s2 to s1, return s1.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strcpy

asm_strcpy:
   
   ; enter : hl = char *s2 = src
   ;         de = char *s1 = dst
   ;
   ; exit  : hl = char *s1 = dst
   ;         de = ptr to terminating NUL in s1
   ;
   ; uses  : af, bc, de, hl

   push de
IF !__CPU_INTEL__ && !__CPU_GBZ80__
   xor a
ENDIF

loop:
IF __CPU_INTEL__ | __CPU_GBZ80__
   ld a,(hl)
   ld (de),a
   inc hl
   inc de
   and a
ELSE
   cp (hl)
   ldi
ENDIF
   jr nz, loop
   
   pop hl
   dec de
   ret
