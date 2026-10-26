; Aquarius+ AQX bootstrap used when CRT_COMPRESS_AQX is enabled.

    PUBLIC __aqx_zx0_program_entry_point
    PUBLIC __aqx_zx0_compressed_size

start:
    di
    ld      sp,CRT_ORG_CODE
IF CRT_AQPLUS_BANK3_RAM
    in      a,(PORT_BANK2)
    inc     a
    out     (PORT_BANK3),a
ENDIF
    EXTERN  __data_user_tail
    ld      de,__data_user_tail+10
__aqx_zx0_compressed_size:
    ld      bc,0
    ld      hl,__aqx_zx0_program_entry_point
    push    hl
    add     hl,bc
    dec     hl
    lddr
    inc     de
    ex      de,hl
    pop     de
    call    dzx0_standard
    jp      __aqx_zx0_program_entry_point

dzx0_standard:
    ld      bc,$ffff
    push    bc
    inc     bc
    ld      a,$80
dzx0s_literals:
    call    dzx0s_elias
    ldir
    add     a,a
    jr      c,dzx0s_new_offset
    call    dzx0s_elias
dzx0s_copy:
    ex      (sp),hl
    push    hl
    add     hl,de
    ldir
    pop     hl
    ex      (sp),hl
    add     a,a
    jr      nc,dzx0s_literals
dzx0s_new_offset:
    pop     bc
    ld      c,$fe
    call    dzx0s_elias_loop
    inc     c
    ret     z
    ld      b,c
    ld      c,(hl)
    inc     hl
    rr      b
    rr      c
    push    bc
    ld      bc,1
    call    nc,dzx0s_elias_backtrack
    inc     bc
    jr      dzx0s_copy
dzx0s_elias:
    inc     c
dzx0s_elias_loop:
    add     a,a
    jr      nz,dzx0s_elias_skip
    ld      a,(hl)
    inc     hl
    rla
dzx0s_elias_skip:
    ret     c
dzx0s_elias_backtrack:
    add     a,a
    rl      c
    rl      b
    jr      dzx0s_elias_loop

__aqx_zx0_program_entry_point:
