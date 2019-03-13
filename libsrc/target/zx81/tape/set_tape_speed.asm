;
;      ZX81 Tape save routines
;
;
; void __FASTCALL__ set_tape_speed(uchar speed)
;
;
;	$Id: set_tape_speed.asm,v 1.2 2015-01-19 01:33:27 pauloscustodio Exp $
;


PUBLIC set_tape_speed

EXTERN musamy_save
EXTERN SAVE_SPEED


set_tape_speed:
   ld a,l
   ld (musamy_save-musamy_save+SAVE_SPEED+1),a
   ret
