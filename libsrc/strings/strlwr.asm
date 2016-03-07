; char __FASTCALL__ *strlwr(char *s)
; change string to lower case
; 12.2006 aralbrec

; enter: hl = char *s
; exit : hl = char *s
; uses : af

SECTION code_clib
PUBLIC strlwr
PUBLIC _strlwr
PUBLIC ASMDISP_STRLWR

EXTERN asm_tolower

.strlwr
._strlwr

   push hl
   dec hl

.loop

   inc hl
   ld a,(hl)
   or a
   jr z, exit

   call asm_tolower
   ld (hl),a
   
   jp loop

.exit

   pop hl
   ret

DEFC ASMDISP_STRLWR = 0
