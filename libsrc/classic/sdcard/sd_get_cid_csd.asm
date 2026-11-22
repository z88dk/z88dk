;
;	SD Card driver
;	by Stefano Bodrato, 2012
;	portions of the code are by Alessandro Poppi and Phil Ruston
;	Modified November 2026 feilipu.
;
;
;	$Id: sd_get_cid_csd.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;
;--------------------------------------------------------------------------------------------------------
; Read CID or CSD. HL is the buffer. A is CMD10 or CMD9.
; R1 must be $00. TOKEN_DATA follows. 16 bytes and 2 CRC bytes are stored.
;
; Returns error code in A (0 = no error).
; HL = 0 on success
;
;--------------------------------------------------------------------------------------------------------
;

    SECTION code_driver

    PUBLIC  sd_get_cid_csd

    EXTERN  sd_send_command_null_args
    EXTERN  sd_wait_data_token
    EXTERN  sd_read_bytes

    INCLUDE "sdcard.def"

sd_get_cid_csd:
    ld      (hl), 0                     ; kill the OEM ID, just to touch the CID a little
    push    hl
    call    sd_send_command_null_args
    pop     hl
    ld      a, sd_error_bad_command_response
    ret     nz                          ; ZF set if command response = 00

    call    sd_wait_data_token          ; wait for the data token
    ld      a, sd_error_data_token_timeout
    ret     nz

    ld      b, 18                       ; read the card info to sector buffer (16 bytes + 2 CRC)
    call    sd_read_bytes
    xor     a
    ret
