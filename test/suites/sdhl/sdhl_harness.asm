; Scripted card bytes. The real waits, the real single-sector read,
; and the real multi-block read and write bodies run.
; sd_get_byte keeps HL and BC, as the Next port does. The wait's counter
; lives in HL across that call.
; This is not a card. It does not mount a volume or close a file.

    SECTION code_compiler

    PUBLIC  _sdhl_run

    PUBLIC  sd_get_byte
    PUBLIC  sd_set_sector_addr_regs
    PUBLIC  sd_send_command_current_args
    PUBLIC  sd_send_command_null_args
    PUBLIC  sd_send_eight_clocks
    PUBLIC  sd_send_byte
    PUBLIC  sd_write_sector_main
    PUBLIC  sd_deselect_card
    PUBLIC  cmd_generic_args

    EXTERN  asm_sd_read_sector
    EXTERN  sd_read_sectors_body
    EXTERN  sd_write_sectors_body
    EXTERN  sd_wait_data_token
    EXTERN  sd_wait_not_busy
    EXTERN  sd_bytes_per_4ms
    EXTERN  sd_block_count
    EXTERN  sd_c_ret

_sdhl_run:
    call    sdhl_token
    ld      a, h
    or      l
    ret     nz
    call    sdhl_read
    ld      a, h
    or      l
    ret     nz
    call    sdhl_busy
    ld      a, h
    or      l
    ret     nz
    call    sdhl_timeout
    ld      a, h
    or      l
    ret     nz
    call    sdhl_mread
    ld      a, h
    or      l
    ret     nz
    jp      sdhl_mwrite

; HL = marker. A leading $FF then $FE must leave HL there and Z set.
sdhl_token:
    ld      hl, 32
    ld      (sd_bytes_per_4ms), hl
    ld      hl, sdhl_script
    ld      (hl), $ff
    inc     hl
    ld      (hl), $fe
    ld      hl, sdhl_script
    ld      (sdhl_script_p), hl
    ld      hl, sdhl_mark
    push    hl
    call    sd_wait_data_token
    pop     de
    jr      nz, sdhl_bad1
    call    sdhl_eq
    jr      nz, sdhl_bad1
    ld      hl, 0
    ret
sdhl_bad1:
    ld      hl, 1
    ret

; $FF, $FE, 512 data bytes, two CRC clocks. The guard sits at the old
; clobber address and must stay $A5. The buffer must become $5A.
sdhl_read:
    ld      hl, sdhl_dest
    ld      a, $11
    call    sdhl_fill256
    call    sdhl_fill256
    ld      hl, sdhl_guard
    ld      a, $a5
    call    sdhl_fill256
    call    sdhl_fill256
    ld      hl, sdhl_guard+1
    ld      (sd_bytes_per_4ms), hl
    ld      hl, sdhl_script
    ld      (sdhl_script_p), hl
    ld      (hl), $ff
    inc     hl
    ld      (hl), $fe
    inc     hl
    ld      a, $5a
    call    sdhl_fill256
    call    sdhl_fill256
    ld      (hl), 0
    inc     hl
    ld      (hl), 0
    ld      bc, sdhl_dest
    ld      de, 1
    ld      hl, 0
    call    asm_sd_read_sector
    jr      nz, sdhl_bad2
    ld      de, sdhl_dest+512
    call    sdhl_eq
    jr      nz, sdhl_bad2
    ld      a, (sdhl_dest)
    cp      $5a
    jr      nz, sdhl_bad2
    ld      a, (sdhl_dest+511)
    cp      $5a
    jr      nz, sdhl_bad2
    ld      a, (sdhl_guard)
    cp      $a5
    jr      nz, sdhl_bad2
    ld      a, (sdhl_guard+511)
    cp      $a5
    jr      nz, sdhl_bad2
    ld      hl, 0
    ret
sdhl_bad2:
    ld      hl, 2
    ret

; One busy byte, then $FF. HL must still be the source, then source+512.
sdhl_busy:
    ld      hl, 8
    ld      (sd_bytes_per_4ms), hl
    ld      hl, sdhl_script
    ld      (hl), $00
    inc     hl
    ld      (hl), $ff
    ld      hl, sdhl_script
    ld      (sdhl_script_p), hl
    ld      hl, sdhl_mark
    call    sd_wait_not_busy
    jr      nz, sdhl_bad3
    ld      de, sdhl_mark
    call    sdhl_eq
    jr      nz, sdhl_bad3
    ld      de, 512
    add     hl, de
    ld      de, sdhl_mark+512
    call    sdhl_eq
    jr      nz, sdhl_bad3
    ld      hl, 0
    ret
sdhl_bad3:
    ld      hl, 3
    ret

; Budget 1 and no $FF. Z must be clear and HL must stay.
sdhl_timeout:
    ld      hl, 1
    ld      (sd_bytes_per_4ms), hl
    ld      hl, sdhl_script
    ld      (sdhl_script_p), hl
    ld      b, 80
    xor     a
sdhl_zloop:
    ld      (hl), a
    inc     hl
    djnz    sdhl_zloop
    ld      hl, sdhl_mark
    call    sd_wait_not_busy
    jr      z, sdhl_bad4
    ld      de, sdhl_mark
    call    sdhl_eq
    jr      nz, sdhl_bad4
    ld      hl, 0
    ret
sdhl_bad4:
    ld      hl, 4
    ret

; Two blocks. The second 512 bytes must follow the first.
; The body returns through sd_c_ret, so the entry jumps to it.
sdhl_mread:
    ld      hl, sdhl_dest
    ld      a, $11
    call    sdhl_fill256
    call    sdhl_fill256
    call    sdhl_fill256
    call    sdhl_fill256
    ld      hl, 8
    ld      (sd_bytes_per_4ms), hl
    ld      hl, 2
    ld      (sd_block_count), hl
    ld      hl, sdhl_script
    ld      (sdhl_script_p), hl
    ld      (hl), $ff
    inc     hl
    ld      (hl), $fe
    inc     hl
    ld      a, $5a
    call    sdhl_fill256
    call    sdhl_fill256
    ld      (hl), 0
    inc     hl
    ld      (hl), 0
    inc     hl
    ld      (hl), $ff
    inc     hl
    ld      (hl), $fe
    inc     hl
    ld      a, $a6
    call    sdhl_fill256
    call    sdhl_fill256
    ld      (hl), 0
    inc     hl
    ld      (hl), 0
    inc     hl
    ld      (hl), $ff
    ld      hl, sdhl_mread_back
    ld      (sd_c_ret), hl
    ld      bc, sdhl_dest
    ld      de, 1
    ld      hl, 0
    jp      sd_read_sectors_body

sdhl_mread_back:
    ld      a, h
    or      l
    jr      nz, sdhl_bad5
    ld      a, (sdhl_dest)
    cp      $5a
    jr      nz, sdhl_bad5
    ld      a, (sdhl_dest+511)
    cp      $5a
    jr      nz, sdhl_bad5
    ld      a, (sdhl_dest+512)
    cp      $a6
    jr      nz, sdhl_bad5
    ld      a, (sdhl_dest+1023)
    cp      $a6
    jr      nz, sdhl_bad5
    ld      hl, 0
    ret
sdhl_bad5:
    ld      hl, 5
    ret

; Two blocks. The second source must be the first plus 512.
; A wait that drops HL reports success and writes the wrong block.
sdhl_mwrite:
    xor     a
    ld      (sdhl_widx), a
    ld      hl, 4
    ld      (sd_bytes_per_4ms), hl
    ld      hl, 2
    ld      (sd_block_count), hl
    ld      hl, sdhl_script
    ld      (sdhl_script_p), hl
    ld      (hl), $05
    inc     hl
    ld      (hl), $ff
    inc     hl
    ld      (hl), $05
    inc     hl
    ld      (hl), $ff
    inc     hl
    ld      (hl), $ff
    ld      hl, sdhl_mwrite_back
    ld      (sd_c_ret), hl
    ld      bc, sdhl_dest
    ld      de, 1
    ld      hl, 0
    jp      sd_write_sectors_body

sdhl_mwrite_back:
    ld      a, h
    or      l
    jr      nz, sdhl_bad6
    ld      a, (sdhl_widx)
    cp      2
    jr      nz, sdhl_bad6
    ld      hl, (sdhl_wlog)
    ld      de, sdhl_dest
    call    sdhl_eq
    jr      nz, sdhl_bad6
    ld      hl, (sdhl_wlog+2)
    ld      de, sdhl_dest+512
    call    sdhl_eq
    jr      nz, sdhl_bad6
    ld      hl, 0
    ret
sdhl_bad6:
    ld      hl, 6
    ret

; HL is the pointer under test. DE is the expected value.
sdhl_eq:
    ld      a, l
    cp      e
    ret     nz
    ld      a, h
    cp      d
    ret

; HL advances. A is the byte. B counts 256.
sdhl_fill256:
    ld      b, 0
sdhl_fill_lp:
    ld      (hl), a
    inc     hl
    djnz    sdhl_fill_lp
    ret

sd_set_sector_addr_regs:
    ret

sd_send_command_current_args:
    xor     a
    ret

sd_deselect_card:
    ret

sd_send_command_null_args:
    xor     a
    ret

sd_send_eight_clocks:
    ret

sd_send_byte:
    ret

; Record the buffer the multi-block write passed in. HL may change.
sd_write_sector_main:
    push    hl
    ld      a, (sdhl_widx)
    add     a, a
    ld      hl, sdhl_wlog
    add     a, l
    ld      l, a
    jr      nc, sdhl_wstore
    inc     h
sdhl_wstore:
    pop     de
    ld      (hl), e
    inc     hl
    ld      (hl), d
    ld      hl, sdhl_widx
    inc     (hl)
    ret

sd_get_byte:
    push    hl
    ld      hl, (sdhl_script_p)
    ld      a, (hl)
    inc     hl
    ld      (sdhl_script_p), hl
    pop     hl
    ret


    SECTION bss_compiler

sdhl_script:
    defs    1100
sdhl_script_p:
    defs    2
sdhl_dest:
    defs    512
sdhl_guard:
    defs    512
sdhl_mark:
    defs    2
sdhl_wlog:
    defs    4
sdhl_widx:
    defs    1
cmd_generic_args:
    defs    4
