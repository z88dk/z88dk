;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	int sd_read_sectors(struct SD_INFO descriptor, long sector,
;	                    unsigned char *address, unsigned int count);
;
;	on exit: 0 if all OK or error code
;
;	CMD18 READ_MULTIPLE_BLOCK. R1 must be $00. Each block is TOKEN_DATA.
;	CMD12 STOP_TRANSMISSION ends the read. R1b. The sender drops one stuff byte.
;

    SECTION code_driver

    PUBLIC  sd_read_sectors_callee
    PUBLIC  _sd_read_sectors_callee
    PUBLIC  sd_read_sectors_body

    EXTERN  sd_set_sector_addr_regs
    EXTERN  sd_send_command_null_args
    EXTERN  sd_send_command_current_args
    EXTERN  sd_wait_data_token
    EXTERN  sd_wait_not_busy
    EXTERN  sd_read_sector_main
    EXTERN  sd_deselect_card
    EXTERN  sd_block_count

    INCLUDE "sdcard.def"

sd_read_sectors_callee:
_sd_read_sectors_callee:
    defc    SD_WANT_COUNT = 1
    INCLUDE "sd_pop_sector.inc"

sd_read_sectors_body:
    push    bc
    scf
    call    sd_set_sector_addr_regs
    ld      a, CMD18                    ; READ_MULTIPLE_BLOCK. R1 pending.
    call    sd_send_command_current_args
    jr      z, sd_mrd_go
    pop     bc
    ld      a, sd_error_bad_command_response
    or      a
    jr      sd_mrd_end

sd_mrd_go:
    pop     hl
sd_mrd_lp:
    push    hl
    call    sd_wait_data_token
    jr      nz, sd_mrd_tok
    pop     hl
    call    sd_read_sector_main         ; HL comes back at the next byte
    push    hl
    ld      hl, (sd_block_count)
    dec     hl
    ld      (sd_block_count), hl
    ld      a, h
    or      l
    pop     hl
    jr      nz, sd_mrd_lp
    call    sd_mrd_stop
    jr      sd_mrd_end

sd_mrd_tok:
    pop     hl
    call    sd_mrd_stop
    ld      a, sd_error_data_token_timeout
    or      a

sd_mrd_end:
    call    sd_deselect_card
    ld      l, a
    ld      h, 0
    ret

sd_mrd_stop:
    ld      a, CMD12                    ; STOP_TRANSMISSION. R1 pending, then R1b busy.
    call    sd_send_command_null_args
    push    af
    call    sd_wait_not_busy
    pop     bc
    jr      z, sd_mrd_r1
    ld      a, sd_error_write_timeout
    or      a
    ret

sd_mrd_r1:
    ld      a, b
    or      a
    ret     z
    ld      a, sd_error_bad_command_response
    or      a
    ret
