
    SECTION code_clib
    PUBLIC  kbd_click
    PUBLIC  _kbd_click


;
;	$Id: kbd_click.asm $
;
;	This function patches the current BIOS session altering
;	the sound table currently associated to the keypresses
;
; ******************************************************************


kbd_click:
_kbd_click:
	ld a,h
	or l
	jr nz,load_sound
	ld hl,no_tone
load_sound:
	ld de,($da84)   ; usually 'CLICK', but it depends on the CMOS settings
	ld bc,15
	ldir
	ret


no_tone:
defb 00,00,00,00,0x0F,0x0F,0x0F,0x0FF,00,00,00,00,00,00,00
