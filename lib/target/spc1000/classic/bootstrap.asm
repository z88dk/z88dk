; SPC-1000 bootstrap for -subtype=allram.
;
; Unpacker moved to $f000, the packed program moved up to end below it (so that the program, unpacked at 0, cannot
; catch up with it however big it is), and the program unpacked at 0.  appmake puts the length of the packed
; program in the `ld bc` below.
;
; While it works it shows a bar across the middle of the screen (the video RAM is behind I/O ports and BASIC's text
; screen is in the way, so the screen is cleared in the 256x192 mode first): a quarter of the width when the unpacker
; has been moved, half when the packed program has, three quarters as the unpacking starts, all of it when the program is unpacked.  The program clears it.

    SECTION BOOTSTRAP

    PUBLIC  __spc1000_bootstrap_built
    PUBLIC  __spc1000_bootstrap_org
    PUBLIC  __spc1000_bootstrap_reloc
    PUBLIC  __spc1000_bootstrap_top
    PUBLIC  __spc1000_bootstrap_clen
    EXTERN  __spc1000_allram_start

    defc    __spc1000_bootstrap_built = 1
    defc    __spc1000_bootstrap_org = $7CDD
    defc    __spc1000_bootstrap_reloc = $F000       ; where the unpacker runs (above everything the program and its uninitialised data use)
    defc    __spc1000_bootstrap_top = $EFE0         ; where the packed program ends (the stack, below the unpacker, has the 32 bytes after it)

    org     __spc1000_bootstrap_org

bootstrap_start:
    di                                      ; BASIC's interrupts would write over what we are unpacking
    ld      hl,unpack_image
    ld      de,__spc1000_bootstrap_reloc
    ld      bc,unpack_len
    ldir
    ld      sp,__spc1000_bootstrap_reloc
    call    screen_setup                    ; (the screen routines are in the unpacker, at its new address)
    ld      hl,bootstrap_end                ; the packed program follows this code ...
    ld      bc,0                            ; ... its length (appmake's)
    defc    __spc1000_bootstrap_clen = ASMPC-2
    add     hl,bc
    dec     hl
    ld      de,__spc1000_bootstrap_top-1
    lddr                                    ; ... and goes up, to end at the top
    inc     de
    ex      de,hl
    push    hl
    ld      a,16
    call    bar                             ; half
    pop     hl
    ld      de,CRT_ORG_CODE
    jp      __spc1000_bootstrap_reloc

unpack_image:
    phase   __spc1000_bootstrap_reloc
unpack_start:
    push    hl
    push    de
    ld      a,24
    call    bar                             ; three quarters: the unpacker is running
    pop     de
    pop     hl
    call    dzx0_standard
    ld      a,32
    call    bar                             ; all of it
    jp      __spc1000_allram_start

; The 256x192 mono mode (white on black), the screen black, and the first quarter of the bar
screen_setup:
    ld      bc,$2000
    ld      a,$8e
    out     (c),a
    ld      bc,0
clear:
    xor     a
    out     (c),a
    inc     bc
    ld      a,b
    cp      $18                             ; 6144 bytes
    jr      nz,clear
    ld      a,8
; A bar of a bytes (8 pixels each) and eight lines, from the left of the screen's middle (row 11)
bar:
    ld      e,a
    ld      bc,$0b00
    ld      d,8
bar_line:
    push    bc
    ld      l,e
bar_byte:
    ld      a,$ff
    out     (c),a
    inc     bc
    dec     l
    jr      nz,bar_byte
    pop     bc
    ld      a,c
    add     a,32
    ld      c,a
    dec     d
    jr      nz,bar_line
    ret

; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas & Urusergi, "standard" version (68 bytes)
; hl = source, de = destination
; -----------------------------------------------------------------------------
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
    defc    unpack_len = ASMPC-unpack_start        ; (both phased: the length of the code that is copied)
    dephase
bootstrap_end:
