;
;	SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Returns HL = Pointer to device ID string
;
;	$Id: sd_read_cid.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_read_cid
    PUBLIC  sd_vnchars

    EXTERN  sector_buffer_loc
    EXTERN  sd_card_info
    EXTERN  sd_send_command_null_args
    EXTERN  sd_wait_data_token
    EXTERN  sd_read_bytes_to_sector_buffer

    INCLUDE "sdcard.def"

sd_vnchars:
    defm    " vx.x SN:00000000 "
    defb    0, 0

sd_read_cid:
    ld      a, CMD10                    ; send "read CID" $4a 00 00 00 00 00 command for more card data
    call    sd_send_command_null_args

    ld      a, sd_error_bad_command_response
    ret     nz                          ; ZF set if command response = 00

    call    sd_wait_data_token          ; wait for the data token
    ld      a, sd_error_data_token_timeout
    ret     nz

    ld      b, 18
    call    sd_read_bytes_to_sector_buffer
                                        ; read 16 bytes + 2 CRC

    ld      hl, (sector_buffer_loc)     ; Build name / version / serial number of card as ASCII string
    push    hl
    ld      bc, $20
    add     hl, bc
    ld      de, hl                      ; 8080: cheap pair copy. DE = sector buffer + 20
    pop     hl
    ld      bc, 3
    add     hl, bc                      ; HL = sector buffer + 3
    ld      bc, 5
    ld      a, (sd_card_info)
    and     $0f
    jr      nz, sd_cn5
    inc     bc
sd_cn5:
    call    sd_cid_copy
    push    hl
    push    de
    ld      hl, sd_vnchars
    ld      bc, 20
    call    sd_cid_copy
    pop     de
    pop     hl
    inc     de
    inc     de
    ld      a, (hl)
    rrca
    rrca
    rrca
    rrca
    and     $0f
    add     a, $30                      ; put in version digit 1
    ld      (de), a
    inc     de
    inc     de
    ld      a, (hl)
    and     $0f
    add     a, $30
    ld      (de), a                     ; put in version digit 2
    inc     de
    inc     de
    inc     de
    inc     de
    inc     de
    inc     hl
    ld      b, 4
sd_snulp:
    ld      a, (hl)                     ; put in 32 bit serial number
    rrca
    rrca
    rrca
    rrca
    and     $0f
    add     a, $30
    cp      $3a
    jr      c, sd_hvl1
    add     a, $7
sd_hvl1:
    ld      (de+), a
    ld      a, (hl)
    and     $0f
    add     a, $30
    cp      $3a
    jr      c, sd_hvl2
    add     a, $7
sd_hvl2:
    ld      (de+), a
    inc     hl
    djnz    sd_snulp

    ld      hl, (sector_buffer_loc)     ; Drive (hardware) name string at HL
    ld      de, $20
    add     hl, de
    xor     a
    ret

sd_cid_copy:
;	8080: (hl+) and (de+), not ldir. The nibble path uses rrca, not srl.
    ld      a, b
    or      c
    ret     z
sd_cid_cp:
    ld      a, (hl+)
    ld      (de+), a
    dec     bc
    ld      a, b
    or      c
    jr      nz, sd_cid_cp
    ret
