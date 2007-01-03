; char __FASTCALL__ *strupr(char *s)
; change string to upper case
; 01.2007 aralbrec

; enter: hl = char *s
; exit : hl = char *s
; uses : af

XLIB strupr
XDEF ASMDISP_STRUPR

.strupr

   push hl
   dec hl

.loop

   inc hl
   ld a,(hl)
   or a
   jr z, exit

   cp 'a'
   jr c, loop
   cp 'z'+1
   jr nc, loop
   and $df
   ld (hl),a
   jp loop

.exit

   pop hl
   ret

DEFC ASMDISP_STRUPR = 0

