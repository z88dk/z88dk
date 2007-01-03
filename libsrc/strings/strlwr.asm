; char __FASTCALL__ *strlwr(char *s)
; change string to lower case
; 12.2006 aralbrec

; enter: hl = char *s
; exit : hl = char *s
; uses : af

XLIB strlwr
XDEF ASMDISP_STRLWR

.strlwr

   push hl
   dec hl

.loop

   inc hl
   ld a,(hl)
   or a
   jr z, exit

   cp 'A'
   jr c, loop
   cp 'Z'+1
   jr nc, loop
   or 32
   ld (hl),a
   jp loop

.exit

   pop hl
   ret

DEFC ASMDISP_STRLWR = 0
