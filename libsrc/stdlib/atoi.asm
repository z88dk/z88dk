;/*
; *	int atoi (char *)
; *
; *	Convert ascii string to integer...
; *
; *	equivalent to stroul(ptr,NULL,10)
; *
; *	But this should be shorter...
; *
; *	Almost k&r but not quite..
; *
; *	djm 5/1/2000
; *
; * -----
; * $Id: atoi.asm,v 1.10 2016-03-06 22:03:07 dom Exp $
; *
; */

SECTION code_clib
PUBLIC atoi
PUBLIC _atoi
EXTERN l_neg, stdio_atou, asm_isspace

; FASTCALL

; enter : hl = char*
; exit  : hl = int result
;         de = & next char to interpret in char*

.atoi
._atoi

   ld a,(hl)                 ; eat whitespace
   inc hl

   call asm_isspace
   jr z, atoi

   ; ate up one too many chars, see if it's a sign
   
   ex de,hl
   
   cp '+'
   jp z, stdio_atou
   
   dec de
   cp '-'
   jp nz, stdio_atou
   
   inc de                    ; this is a negative number
   call stdio_atou           ; do atou but come back here to negate result
   jp l_neg                  ; hl = -hl
