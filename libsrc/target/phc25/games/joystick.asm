;
; The joysticks are attached to the PSG

    SECTION code_clib
    PUBLIC  joystick
    PUBLIC  _joystick
    EXTERN  get_psg
    EXTERN  keys_qaop
    EXTERN  keys_vi
    EXTERN  keys_cursor
    EXTERN  joystick_sc


joystick:
_joystick:
	;__FASTCALL__ : joystick no. in HL
    ld      a, 14
    dec     l
    jr      z, got_port
    inc     a
    dec     l
    jr      z, got_port

    ld      a,l
    ld      hl, keys_qaop
    dec     a
    jp      z, joystick_sc
    ld      hl, keys_cursor
    dec     a
    jp      z, joystick_sc
    ld      hl, keys_vi
    dec     a
    jp      z, joystick_sc
    ld      hl, 0
    ret


    ;; And here we'd do keyboard
    ld      hl, 0

    ret

got_port:
    ld      l, a
    call    get_psg                     ;Exits with a = value
    ld      hl, 0
    cpl
    rra                                 ;UP
    rl      l
    rra                                 ;DOWN
    rl      l
    rra                                 ;LEFT
    rl      l
    rra                                 ;RIGHT
    rl      l
    rra
    jr      nc, not_fire1
    set     4, l
not_fire1:
    rra
    ret     nc
    set     5, l
    ret

