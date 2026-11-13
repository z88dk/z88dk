;
;	Samsung SPC-1500 PSG routines: the AY-3-8910 (the address through $1C00,
;	the data through $1B00)
;
;	int set_psg(int reg, int val);
;
;	Set a PSG register.  Registers 14 and 15 are the ports: 14 is the
;	joystick (an input), 15 has the cassette's motor and the IPL ROM select:
;	leave them alone.

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
