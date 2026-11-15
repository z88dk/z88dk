;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	int sd_write_sectors(struct SD_INFO descriptor, long sector,
;	                     unsigned char *address, unsigned int count);
;
;	on exit: 0 if all OK or error code
;
;	CMD55 then ACMD23 is a pre-erase hint. A rejected hint still allows CMD25.
;	CMD25 WRITE_MULTIPLE_BLOCK. Each block is TOKEN_MULTI and a data response.
;	TOKEN_STOP ends the write. Busy after the stop uses the same 250 ms wait.
;

    PUBLIC  sd_write_sectors_callee
    PUBLIC  _sd_write_sectors_callee
    PUBLIC  sd_write_sectors_body

    EXTERN  sd_set_sector_addr_regs
    EXTERN  sd_send_command_null_args
    EXTERN  sd_send_command_current_args
    EXTERN  sd_send_eight_clocks
    EXTERN  sd_send_byte
    EXTERN  sd_get_byte
    EXTERN  sd_write_sector_main
    EXTERN  sd_wait_not_busy
    EXTERN  sd_deselect_card
    EXTERN  sd_c_return_hl
    EXTERN  sd_block_count
    EXTERN  cmd_generic_args

    INCLUDE "sdcard.def"

sd_write_sectors_callee:
_sd_write_sectors_callee:
    defc    SD_WANT_COUNT = 1
    INCLUDE "sd_pop_sector.inc"

sd_write_sectors_body:
    push    hl
    push    de
    push    bc
    ld      a, CMD55                    ; APP_CMD. R1 pending. $00 makes the next command ACMD23.
    call    sd_send_command_null_args
    or      a
    jr      nz, sd_mwr_no23
    ld      hl, (sd_block_count)
    xor     a
    ld      (cmd_generic_args), a
    ld      (cmd_generic_args+1), a
    ld      a, h
    ld      (cmd_generic_args+2), a
    ld      a, l
    ld      (cmd_generic_args+3), a
    ld      a, ACMD23                   ; SET_WR_BLK_ERASE_COUNT. R1 is not required.
    call    sd_send_command_current_args
sd_mwr_no23:
    pop     bc
    pop     de
    pop     hl
    push    bc
    scf
    call    sd_set_sector_addr_regs
    ld      a, CMD25                    ; WRITE_MULTIPLE_BLOCK. R1 pending.
    call    sd_send_command_current_args
    jr      z, sd_mwr_go
    pop     bc
    ld      a, sd_error_bad_command_response
    or      a
    jr      sd_mwr_end

sd_mwr_go:
    pop     hl
sd_mwr_lp:
    call    sd_send_eight_clocks
    ld      a, TOKEN_MULTI
    call    sd_send_byte
    push    hl
    call    sd_write_sector_main
    pop     hl
    ld      b, 8                        ; data response pending. Up to 8 $FF bytes.
sd_mwr_rsp:
    call    sd_get_byte
    cp      $ff
    jr      nz, sd_mwr_tok
    djnz    sd_mwr_rsp
    call    sd_get_byte
sd_mwr_tok:
    and     $1f                         ; 8080: and/cp, not srl. Accepted token is $05.
    cp      TOKEN_ACCEPTED
    jr      nz, sd_mwr_rej
    call    sd_wait_not_busy
    jr      nz, sd_mwr_busy
    ld      de, 512
    add     hl, de
    push    hl
    ld      hl, (sd_block_count)
    dec     hl
    ld      (sd_block_count), hl
    ld      a, h
    or      l
    pop     hl
    jr      nz, sd_mwr_lp
    call    sd_mwr_stop
    jr      z, sd_mwr_ok
    ld      a, sd_error_write_timeout
    or      a
    jr      sd_mwr_end

sd_mwr_ok:
    xor     a
    jr      sd_mwr_end

sd_mwr_rej:
    call    sd_mwr_stop
    ld      a, sd_error_write_failed
    or      a
    jr      sd_mwr_end

sd_mwr_busy:
    call    sd_mwr_stop
    ld      a, sd_error_write_timeout
    or      a

sd_mwr_end:
    call    sd_deselect_card
    ld      l, a
    ld      h, 0
    jp      sd_c_return_hl

sd_mwr_stop:
    call    sd_send_eight_clocks
    ld      a, TOKEN_STOP               ; end of CMD25. Busy follows. No R1.
    call    sd_send_byte
    jp      sd_wait_not_busy
