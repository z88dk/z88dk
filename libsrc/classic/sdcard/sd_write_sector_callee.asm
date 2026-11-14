;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	int sd_write_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible,
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_write_sector_callee.asm,v 1.6 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_write_sector_callee
    PUBLIC  _sd_write_sector_callee
    PUBLIC  asm_sd_write_sector
    PUBLIC  asm_sd_write_lba

    EXTERN  sd_write_sector_main
    EXTERN  sd_set_sector_addr_regs
    EXTERN  sd_send_command_current_args
    EXTERN  sd_send_eight_clocks
    EXTERN  sd_send_byte
    EXTERN  sd_get_byte
    EXTERN  sd_wait_not_busy
    EXTERN  sd_deselect_card
    EXTERN  sd_c_return_hl

    INCLUDE "sdcard.def"

sd_write_sector_callee:
_sd_write_sector_callee:
    defc    SD_WANT_COUNT = 0
    INCLUDE "sd_pop_sector.inc"
    call    asm_sd_write_sector
    jr      z, sd_wr_ok
    ld      l, a
    ld      h, 0
    jp      sd_c_return_hl

sd_wr_ok:
    ld      hl, 0
    jp      sd_c_return_hl

asm_sd_write_sector:
    scf

asm_sd_write_lba:
    push    bc
    call    sd_set_sector_addr_regs
    ld      a, CMD24
    call    sd_send_command_current_args
    jr      nz, sd_wr_cmd
    pop     hl
    call    sd_send_eight_clocks
    ld      a, $fe
    call    sd_send_byte
    call    sd_write_sector_main
    call    sd_get_byte
    and     $1f
    cp      $05
    jr      nz, sd_wr_rej
    call    sd_wait_not_busy
    jr      nz, sd_wr_busy
    xor     a
    jp      sd_deselect_card

sd_wr_cmd:
    pop     bc
    ld      a, sd_error_bad_command_response
    jr      sd_wr_err

sd_wr_rej:
    ld      a, sd_error_write_failed
    jr      sd_wr_err

sd_wr_busy:
    ld      a, sd_error_write_timeout

sd_wr_err:
    or      a
    jp      sd_deselect_card
