; char __FASTCALL__ *strupr(char *s)
; change string to upper case
; 01.2007 aralbrec

; enter: hl = char *s
; exit : hl = char *s
; uses : af

SECTION code_clib
PUBLIC strupr
PUBLIC _strupr
PUBLIC ASMDISP_STRUPR

EXTERN asm_toupper

.strupr
._strupr

   push hl

.loop

   ld a,(hl)
   or a
   jr z, exit

   call asm_toupper
   ld (hl),a
   
   inc hl
   jp loop

.exit

   pop hl
   ret

DEFC ASMDISP_STRUPR = 0

