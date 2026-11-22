;
;	Samsung SPC-1500 PSG routines
;
;	void psg_init(void);
;
;	Silence the PSG: the tone and noise periods and the volumes 0, the mixer
;	(register 7) with every tone and noise off, port A an input (the
;	joystick) and port B an output
;	(the cassette's motor and the IPL ROM select, which are left as they
;	are: register 15 is not written).

    SECTION code_clib
    PUBLIC  psg_init
    PUBLIC  _psg_init

psg_init:
_psg_init:
    ld      bc, $1c00
    xor     a
    ld      e, a
psg_loop:
    out     (c), a                      ; the register
    ld      b, $1b
    out     (c), e                      ; zero
    ld      b, $1c
    inc     a
    cp      14
    jr      nz, psg_loop
    ld      a, 7
    out     (c), a
    ld      b, $1b
    ld      a, $bf                      ; tones and noises off, port A in, port B out
    out     (c), a
    ret
