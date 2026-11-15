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
;	One card, slot 0. SDSC, SDHC, SDXC, and SPI MMC.
;	A 32-bit block address covers SDXC through 2 TB. SDUC is not covered.
;	80 clocks with the card deselected, then:
;	CMD0 until R1 is idle.
;	CMD8. R7 echo $01AA is v2. An illegal R1 is v1 or MMC.
;	v2: CMD55, then ACMD41 with HCS, until R1 is $00. CMD58 reads CCS.
;	CCS set: SDHC or SDXC, block address, no CMD16.
;	CCS clear: SDSC, byte address, CMD16 sets 512.
;	v1: CMD55, then ACMD41 with HCS clear. Illegal falls through to CMD1.
;	MMC: CMD1 until R1 is $00, then CMD16.
;
;	$Id: sd_init_main.asm,v 1.6 2015-01-19 01:33:07 pauloscustodio Exp $
;

    SECTION code_driver

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
    ld      b, 128                      ; wait approx 0.5 seconds
sd_init_off:
    push    bc                          ; pause_4ms can change BC
    call    pause_4ms
    pop     bc
    djnz    sd_init_off

    call    sd_power_on
    ld      b, 10                       ; 80 clocks, card deselected. The spec asks for 74.
sd_init_clk:
    call    sd_send_eight_clocks
    djnz    sd_init_clk

;	CMD0 GO_IDLE_STATE. R1 pending. Idle is $01. $FF is delay, not a failed R1.
    ld      b, 32
sd_cmd0_lp:
    push    bc
    ld      a, CMD0
    call    sd_send_command_null_args
    pop     bc
    cp      R1_IDLE
    jr      z, sd_cmd8
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_cmd0_lp

sd_cmd0_fail:
    ld      a, sd_error_spi_mode_failed
    or      a
    ret

;	CMD8 SEND_IF_COND. R1 pending.
;	Idle means the four R7 bytes follow. Illegal means v1 or MMC, and no R7.
;	$FF, or a CRC or parameter R1, is retried. Bit 7 set is not an R1.
sd_cmd8:
    ld      b, 8
sd_cmd8_lp:
    push    bc
    ld      hl, sd_cmd8_str
    call    sd_send_command_string
    pop     bc
    cp      R1_IDLE
    jr      z, sd_v2
    cp      $80
    jr      nc, sd_cmd8_wait
    and     R1_ILLEGAL
    jp      nz, sd_v1
sd_cmd8_wait:
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_cmd8_lp
    ld      a, sd_error_sd_init_failed
    or      a
    ret

sd_v2:
;	R7 payload: command version, reserved, VHS, check pattern.
;	8080: the four R7 bytes sit on the stack. ld hl,sp+n is the cheap synthetic.
    ld      hl, sp-4
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
    jr      sd_v2_acmd

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
;	One second. A v2 card that rejects ACMD41 is not an MMC.
    ld      b, 250
sd_v2_lp:
    push    bc
    ld      a, CMD55                    ; APP_CMD. R1 pending. 0 or idle allows ACMD41.
    call    sd_send_command_null_args
    pop     bc
    or      a
    jr      z, sd_v2_do41
    cp      R1_IDLE
    jr      z, sd_v2_do41
    cp      $80                         ; bit 7 set: not an R1
    jr      nc, sd_v2_wait
    and     R1_ILLEGAL
    jr      nz, sd_v2_fail
    jr      sd_v2_wait
sd_v2_do41:
    push    bc
    ld      hl, sd_acmd41_str           ; ACMD41 SD_SEND_OP_COND, HCS set. R1 pending.
    call    sd_send_command_string
    pop     bc
    or      a                           ; $00: left idle. SDSC, SDHC, or SDXC.
    jr      z, sd_v2_ready
    cp      $80
    jr      nc, sd_v2_wait
    and     R1_ILLEGAL
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
;	CMD58 READ_OCR. R1 pending. $00 means the R3 OCR follows. $FF is retried.
    ld      b, 4
sd_cmd58_lp:
    push    bc
    ld      a, CMD58
    call    sd_send_command_null_args
    pop     bc
    or      a
    jr      z, sd_v2_ocr
    cp      $80
    jr      c, sd_cmd58_bad
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_cmd58_lp
sd_cmd58_bad:
    ld      a, sd_error_bad_command_response
    or      a
    ret

sd_v2_ocr:
;	R3 payload. First byte is OCR bits 31-24.
;	Bit 6 is CCS. Set: SDHC or SDXC, block address. Clear: SDSC, byte address.
    ld      hl, sp-4
    ld      sp, hl
    ld      b, 4
    call    sd_read_bytes
    ld      a, (hl)
    and     $40
    rrca
    rrca
    or      2                           ; type 2. Bit 4 keeps CCS.
    ld      (sd_card_info), a
    ld      hl, sp+4
    ld      sp, hl
    jr      sd_cmd16_512

sd_v1:
;	HCS stays clear. A v1 card rejects the v2 argument.
    ld      b, 250
sd_v1_lp:
    push    bc
    ld      a, CMD55                    ; APP_CMD. R1 pending.
    call    sd_send_command_null_args
    pop     bc
    or      a
    jr      z, sd_v1_do41
    cp      R1_IDLE
    jr      z, sd_v1_do41
    cp      $80
    jr      nc, sd_v1_wait
    and     R1_ILLEGAL                  ; not an SD card. Try MMC CMD1.
    jr      nz, sd_mmc
    jr      sd_v1_wait
sd_v1_do41:
    push    bc
    ld      a, ACMD41                   ; SD_SEND_OP_COND, argument 0. R1 pending.
    call    sd_send_command_null_args
    pop     bc
    or      a
    jr      z, sd_v1_ready
    cp      $80
    jr      nc, sd_v1_wait
    and     R1_ILLEGAL
    jr      nz, sd_mmc
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
    jr      sd_cmd16_512

sd_mmc:
;	CMD1 SEND_OP_COND. R1 pending. $00 is ready. Idle and $FF keep waiting.
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

;	Byte-addressed cards are set to 512-byte blocks. Block cards skip CMD16.
sd_cmd16_512:
    ld      a, (sd_card_info)
    and     $10
    jr      z, sd_cmd16_go
    xor     a
    ret

sd_cmd16_go:
    ld      hl, cmd_generic_args        ; 512-byte blocks, big-endian
    ld      (hl), 0
    inc     hl
    ld      (hl), 0
    inc     hl
    ld      (hl), 2
    inc     hl
    ld      (hl), 0
    ld      b, 4
sd_cmd16_lp:
    push    bc
    ld      a, CMD16                    ; SET_BLOCKLEN. R1 pending. $FF is retried.
    call    sd_send_command_current_args
    pop     bc
    ret     z
    cp      $80
    jr      c, sd_cmd16_bad
    push    bc
    call    pause_4ms
    pop     bc
    djnz    sd_cmd16_lp
sd_cmd16_bad:
    ld      a, sd_error_bad_command_response
    or      a
    ret

    SECTION rodata_driver

sd_cmd8_str:
    defb    CMD8, $00, $00, $01, $aa    ; VHS 2.7-3.6 V, check pattern $AA

sd_acmd41_str:
    defb    ACMD41, $40, $00, $00, $00  ; HCS. SDHC and SDXC may set CCS.
