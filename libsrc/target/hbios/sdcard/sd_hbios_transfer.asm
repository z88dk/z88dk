;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;	Modified November 2026 feilipu.
;
;	Seek once, then read or write in chunks of at most 127 sectors.
;	Entry: A is $13 or $14. BCDE is the LBA. E is the low byte.
;	HL is the buffer. sd_hbios_count and sd_hbios_unit are set.
;	Success: Z set, A = 0, carry clear, HL at the end of the buffer.
;	Failure: Z clear and A holds an error code.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  asm_sd_hbios_transfer

    EXTERN  asm_hbios
    EXTERN  sd_hbios_unit
    EXTERN  sd_hbios_bank
    EXTERN  sd_hbios_count
    EXTERN  sd_hbios_fn

    INCLUDE "sdcard.def"

    defc    HB_DIOSEEK = $12
    defc    HB_GETBNK = $f3

asm_sd_hbios_transfer:
    ld      (sd_hbios_fn), a
    ld      a, b
    and     $80
    jr      z, sd_hb_lba
    ld      a, sd_error_too_big
    or      a
    ret

sd_hb_lba:
    ld      a, b
    or      $80
    ld      b, a
    push    hl
    ld      hl, de
    ld      e, c
    ld      d, b
    push    de
    push    hl
    ld      bc, $f300
    call    asm_hbios
    ld      a, c
    ld      (sd_hbios_bank), a
    pop     hl
    pop     de
    ld      a, (sd_hbios_unit)
    ld      c, a
    ld      b, HB_DIOSEEK
    call    asm_hbios
    or      a
    jr      z, sd_hb_loop
    pop     hl
    ret

sd_hb_loop:
    ld      hl, (sd_hbios_count)
    ld      a, h
    or      l
    jr      z, sd_hb_done
    ld      a, h
    or      a
    jr      nz, sd_hb_cap
    ld      a, l
    cp      128
    jr      c, sd_hb_chunk
sd_hb_cap:
    ld      a, 127
sd_hb_chunk:
    ld      e, a
    ld      a, (sd_hbios_bank)
    ld      d, a
    ld      a, (sd_hbios_unit)
    ld      c, a
    ld      a, (sd_hbios_fn)
    ld      b, a
    pop     hl
    push    hl
    push    de
    call    asm_hbios
    or      a
    pop     bc
    jr      nz, sd_hb_err
    ld      a, e
    or      a
    jr      z, sd_hb_err0
    cp      128
    jr      nc, sd_hb_err0
    ld      c, a
    pop     hl
    add     a, a                        ; Z180: count * 512. mlt is 8x8 and is not this shift
    ld      d, a
    ld      e, 0
    add     hl, de
    push    hl
    ld      b, 0                        ; Z180: B still holds the bank
    or      a
    ld      hl, (sd_hbios_count)
    sbc     hl, bc
    ld      (sd_hbios_count), hl
    jp      nc, sd_hb_loop
    pop     hl
    ld      a, sd_error_bad_command_response
    or      a
    ret

sd_hb_done:
    pop     hl
    xor     a
    ret

sd_hb_err:
    pop     hl
    or      a
    ret

sd_hb_err0:
    pop     hl
    ld      a, sd_error_bad_command_response
    or      a
    ret
