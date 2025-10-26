

SECTION code_clib
PUBLIC asm_atoi
EXTERN l_neg, l_atou, asm_isspace

; FASTCALL

; enter : hl = char*
; exit  : hl = int result
;         de = & next char to interpret in char*

asm_atoi:
   ld a,(hl)                 ; eat whitespace
   inc hl

   call asm_isspace
   jr z, asm_atoi 

   ; ate up one too many chars, see if it's a sign

   ex de,hl

   cp '+'
   jp z, l_atou

   dec de
   cp '-'
   jp nz, l_atou

   inc de                    ; this is a negative number
   call l_atou           ; do atou but come back here to negate result
   jp l_neg                  ; hl = -hl
