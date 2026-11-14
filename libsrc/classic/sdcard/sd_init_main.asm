;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Init SD card communications
;	On entry: A = card slot number
;
;	$Id: sd_init_main.asm,v 1.6 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_init_main

    EXTERN  pause_4ms
    EXTERN  sd_power_on
    EXTERN  sd_power_off
    EXTERN  sd_send_eight_clocks
    EXTERN  sd_send_command_string
    EXTERN  sd_send_command_null_args
    EXTERN  sd_send_command_current_args
    EXTERN  sd_read_bytes
    EXTERN  sd_card_info
    EXTERN  card_select
    EXTERN  cmd_generic_args

    INCLUDE "sdcard.def"

sd_init_main:
    and     a
    ret     nz
    ld      (card_select), a
    ld      (sd_card_info), a

    call    sd_power_off
    ld      b, 4
sd_init_off:
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_init_off

    call    sd_power_on
    ld      b, 10
sd_init_clk:
    push    bc
    call    sd_send_eight_clocks
    pop     bc
    djnz    sd_init_clk

    ld      b, 32
    ld      c, 0
sd_cmd0_lp:
    push    bc
    ld      a, CMD0
    call    sd_send_command_null_args
    pop     bc
    cp      1
    jp      z, sd_cmd8
    cp      $ff
    jr      nz, sd_cmd0_other
    inc     c
    ld      a, c
    cp      4
    jp      z, sd_cmd0_fail
    jr      sd_cmd0_wait
sd_cmd0_other:
    ld      c, 0
sd_cmd0_wait:
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_cmd0_lp

sd_cmd0_fail:
    ld      a, sd_error_spi_mode_failed
    or      a
    ret

sd_cmd8:
    ld      hl, sd_cmd8_str
    call    sd_send_command_string
    cp      1
    jp      z, sd_v2
    cp      5
    jp      z, sd_v1
    ld      a, sd_error_sd_init_failed
    or      a
    ret

sd_v2:
    ld      hl, -4
    add     hl, sp
    ld      sp, hl
    ld      b, 4
    call    sd_read_bytes
    inc     hl
    inc     hl
    ld      a, (hl+)
    cp      1
    jr      nz, sd_v2_vr
    ld      a, (hl)
    cp      $aa
    jr      nz, sd_v2_pat
    ld      hl, sp+4
    ld      sp, hl
    jp      sd_v2_acmd

sd_v2_vr:
    ld      hl, sp+4
    ld      sp, hl
    ld      a, sd_error_vrange_bad
    or      a
    ret

sd_v2_pat:
    ld      hl, sp+4
    ld      sp, hl
    ld      a, sd_error_check_pattern_bad
    or      a
    ret

sd_v2_acmd:
    ld      b, 250
sd_v2_lp:
    push    bc
    ld      a, CMD55
    call    sd_send_command_null_args
    pop     bc
    cp      0
    jr      z, sd_v2_do41
    cp      1
    jr      z, sd_v2_do41
    and     $04
    jr      nz, sd_v2_fail
    jr      sd_v2_wait
sd_v2_do41:
    push    bc
    ld      hl, sd_acmd41_str
    call    sd_send_command_string
    pop     bc
    or      a
    jr      z, sd_v2_ready
    and     $04
    jr      nz, sd_v2_fail
sd_v2_wait:
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_v2_lp
sd_v2_fail:
    ld      a, sd_error_sdhc_init_failed
    or      a
    ret

sd_v2_ready:
    ld      a, CMD58
    call    sd_send_command_null_args
    or      a
    jr      z, sd_v2_ocr
    ld      a, sd_error_bad_command_response
    or      a
    ret

sd_v2_ocr:
    ld      hl, -4
    add     hl, sp
    ld      sp, hl
    ld      b, 4
    call    sd_read_bytes
    ld      a, (hl)
    and     $40
    rrca
    rrca
    or      2
    ld      (sd_card_info), a
    ld      hl, sp+4
    ld      sp, hl
    jp      sd_cmd16_512

sd_v1:
    ld      b, 250
sd_v1_lp:
    push    bc
    ld      a, CMD55
    call    sd_send_command_null_args
    pop     bc
    cp      0
    jr      z, sd_v1_do41
    cp      1
    jr      z, sd_v1_do41
    and     $04
    jp      nz, sd_mmc
    jr      sd_v1_wait
sd_v1_do41:
    push    bc
    ld      a, ACMD41
    call    sd_send_command_null_args
    pop     bc
    or      a
    jr      z, sd_v1_ready
    and     $04
    jp      nz, sd_mmc
sd_v1_wait:
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_v1_lp
    ld      a, sd_error_sd_init_failed
    or      a
    ret

sd_v1_ready:
    ld      a, 1
    ld      (sd_card_info), a
    jp      sd_cmd16_512

sd_mmc:
    ld      b, 250
sd_mmc_lp:
    push    bc
    ld      a, CMD1
    call    sd_send_command_null_args
    pop     bc
    or      a
    jr      z, sd_mmc_ready
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_mmc_lp
    ld      a, sd_error_mmc_init_failed
    or      a
    ret

sd_mmc_ready:
    xor     a
    ld      (sd_card_info), a

sd_cmd16_512:
    ld      a, (sd_card_info)
    and     $10
    jr      z, sd_cmd16_go
    xor     a
    ret

sd_cmd16_go:
    ld      hl, cmd_generic_args
    ld      (hl), 0
    inc     hl
    ld      (hl), 0
    inc     hl
    ld      (hl), 2
    inc     hl
    ld      (hl), 0
    ld      a, CMD16
    call    sd_send_command_current_args
    ret     z
    ld      a, sd_error_bad_command_response
    or      a
    ret

sd_cmd8_str:
    defb    $48, $00, $00, $01, $aa

sd_acmd41_str:
    defb    $69, $40, $00, $00, $00
