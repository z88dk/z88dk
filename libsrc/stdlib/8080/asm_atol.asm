; long __FASTCALL__ atol(char *s)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC asm_atol
EXTERN l_long_neg, asm_isspace
EXTERN l_long_mult

; FASTCALL

; enter : hl = char*
; exit  : dehl = long result
;         bc = & next char to interpret in char*

.asm_atol

   ld a,(hl)                 ; eat whitespace
   inc hl

   call asm_isspace
   jr z, asm_atol

   ; ate up one too many chars, see if it's a sign

   cp '+'
   jr z, signdone
   dec hl
   cp '-'
   jr nz, signdone
   inc hl                    ; this is a negative number
   call signdone             ; do atol but come back here to negate result
   jp l_long_neg             ; dehl = -dehl

.signdone

   ld b,h
   ld c,l
   ld de,0
   ld l,e
   ld h,d

   ; bc = char *
   ; dehl = result

   dec bc

.loop

   inc bc
   ld a,(bc)

   sub '0'                   ; inlined isdigit
   ret c
   cp 10
   ret nc

   push bc
   push af			;Save value
   ; dehl *= 10
   push de
   push hl
   ld   hl,10
   ld   de,0
   call l_long_mult

   ; dehl + value
   pop af		;Value
   pop bc		;str pointer
   add a,l
   ld l,a
   jp nc, loop
   inc h
   jp nz, loop
   inc de

   jp loop
