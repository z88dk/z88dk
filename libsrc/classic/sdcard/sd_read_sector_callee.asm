;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	int sd_read_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible,
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_read_sector_callee.asm,v 1.6 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_read_sector_callee
    PUBLIC  _sd_read_sector_callee
    PUBLIC  asm_sd_read_sector
    PUBLIC  asm_sd_read_lba

    EXTERN  sd_read_sector_main
    EXTERN  sd_set_sector_addr_regs
    EXTERN  sd_send_command_current_args
    EXTERN  sd_wait_data_token
    EXTERN  sd_deselect_card
    EXTERN  sd_c_return_hl

    INCLUDE "sdcard.def"

sd_read_sector_callee:
_sd_read_sector_callee:
    defc    SD_WANT_COUNT = 0
    INCLUDE "sd_pop_sector.inc"
    call    asm_sd_read_sector
    jr      z, sd_rd_ok
    ld      l, a
    ld      h, 0
    jp      sd_c_return_hl

sd_rd_ok:
    ld      hl, 0
    jp      sd_c_return_hl

; HL = high word, DE = low word, BC = buffer.
; Carry is set here so the helper multiplies by 512.
; Success: Z, A = 0, HL = buffer + 512.
;	8080 entry: no IX and no exx. vm1 keeps the return address in sd_c_ret.
;	The C call still returns HL = 0 or the error.

asm_sd_read_sector:
    scf

asm_sd_read_lba:
    push    bc
    call    sd_set_sector_addr_regs
    ld      a, CMD17
    call    sd_send_command_current_args
    jr      nz, sd_rd_cmd
    pop     hl
    call    sd_wait_data_token
    jr      nz, sd_rd_tok
    call    sd_read_sector_main
    jp      sd_deselect_card

sd_rd_cmd:
    pop     bc
    ld      a, sd_error_bad_command_response
    jr      sd_rd_err

sd_rd_tok:
    ld      a, sd_error_data_token_timeout

sd_rd_err:
    or      a
    jp      sd_deselect_card
