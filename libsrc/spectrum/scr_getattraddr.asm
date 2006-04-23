; 04.2006 aralbrec

; void __FASTCALL__ *scr_getattraddr(void *scrnaddr)

XLIB scr_getattraddr

.scr_getattraddr

; Computes the attribute address corresponding to a screen
; address such as returned by 'GetCharAddr' or 'GetScrnAddr'.
;
; enter: hl = screen address
; exit : hl = address of attribute square
; uses : af, de, hl

   ld e,l
   ld a,h
   or $07
   xor $85
   rrca
   rrca
   rrca
   ld d,a
   ex de,hl
   ret
