;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

    SECTION code_clib
    PUBLIC  set_psg
    PUBLIC  _set_psg

    EXTERN  asm_set_psg


set_psg:
_set_psg:

    pop     bc
    pop     de
    pop     hl

    push    hl
    push    de
    push    bc

    jp      asm_set_psg
