;
;      ZX81 Tape save routines
;
;
; void __FASTCALL__ set_tape_speed(uchar speed)
;
;
;	$Id: set_tape_speed.asm,v 1.1 2012-01-09 16:02:36 stefano Exp $
;


XLIB set_tape_speed

LIB musamy_save
XREF SAVE_SPEED


set_tape_speed:
   ld a,l
   ld (musamy_save-musamy_save+SAVE_SPEED+1),a
   ret
