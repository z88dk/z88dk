
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; char *strnchr(const char *s, size_t n, int c)
;
; Return ptr to first occurrence of c in string s.
; Does not examine more than n chars.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strnchr

EXTERN error_zc

asm_strnchr:

   ; enter : hl = char *s
   ;          e = char c
   ;         bc = size_t n
   ;
   ; exit  : 
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr to char c
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, e, hl

   ld a,b                      ; if n == 0 not found
   or c
   jp Z,error_zc

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc
   inc b
   inc c

loop:
   ld a,(hl+)
   cp e
   jr Z,match

   and a                        ;Isn't current char NUL?
   jp Z,error_zc

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

   jp error_zc

ELSE

   ld a,e

loop:
   ld e,(hl)                   ; current char in s
   cpi
   jr Z,match                  ; found char
   jp po,error_zc              ; n exceeded

   inc e                       ; is current char NUL?
   dec e
   jr NZ,loop

   jp error_zc

ENDIF

match:
   dec hl
   ret
