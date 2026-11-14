;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	set HL = location of 6 byte command string
;	returns command response in A (ZF set if $00)
;
;	$Id: sd_send_command_string.asm,v 1.8 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_send_command_string
    PUBLIC  sd_send_command_null_args
    PUBLIC  sd_send_command_int_args
    PUBLIC  sd_send_command
    PUBLIC  sd_send_command_current_args
    PUBLIC  cmd_generic
    PUBLIC  cmd_generic_args

    EXTERN  sd_select_card
    EXTERN  sd_send_eight_clocks
    EXTERN  sd_send_byte
    EXTERN  sd_get_byte

sd_send_command_null_args:
    ld      hl, 0
    ld      de, 0

sd_send_command:
sd_send_command_int_args:
    push    af
    ld      a, h
    ld      (cmd_generic_args), a
    ld      a, l
    ld      (cmd_generic_args+1), a
    ld      a, d
    ld      (cmd_generic_args+2), a
    ld      a, e
    ld      (cmd_generic_args+3), a
    pop     af

sd_send_command_current_args:
    ld      hl, cmd_generic
    ld      (hl), a

sd_send_command_string:
    call    sd_select_card
    call    sd_send_eight_clocks

    push    bc
;	8080: add a,a, not sla. The R1 test is and $80, not bit 7.
;	The first response byte is kept. The poll is 256 bytes, as before.
    ld      c, 0
    ld      b, 5
sd_sclp:
    ld      a, (hl)
    ld      d, 8
sd_crclp:
    ld      e, a
    ld      a, c
    add     a, a
    ld      c, a
    ld      a, e
    xor     c
    and     $80
    jr      z, sd_isz
    ld      a, 9
    xor     c
    ld      c, a
sd_isz:
    ld      a, e
    add     a, a
    dec     d
    jr      nz, sd_crclp

    ld      a, (hl+)
    call    sd_send_byte
    djnz    sd_sclp

    ld      a, c
    add     a, a
    ld      c, a
    ld      a, 1
    or      c
    call    sd_send_byte

    ld      b, 0
sd_wncrl:
    call    sd_get_byte
    ld      c, a
    and     $80
    jr      z, sd_gcr
    djnz    sd_wncrl

sd_gcr:
    ld      a, c
    or      a
    pop     bc
    ret


    SECTION data_compiler

cmd_generic:
    defb    0

cmd_generic_args:
    defb    0, 0, 0, 0
