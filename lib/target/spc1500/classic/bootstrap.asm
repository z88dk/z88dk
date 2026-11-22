; SPC-1500 bootstrap.
;
; The IPL's "C: cassette system" reads a header block and then exactly 128 bytes
; to $0000 (RAM selected, interrupts on), and jumps to $0000.  This is those 128
; bytes:
;
;   stage 1 (at $0000)  moves the block up to $F000, out of the way of the
;   program, and runs it there
;   stage 2 (at $F010)  pages the IPL ROM in (I/O port $1D00), loads the packed
;   program with the ROM's own tape loader ($21B0: BC bytes to HL, carry set for
;   an
;                        error; the stores go to the RAM under the ROM) so that
;                        it ends at __spc1500_bootstrap_top, pages RAM in
;                        ($1E00), unpacks it to $0000 (ZX0)
;                        and jumps to it
;
; appmake puts the load address and the length of the packed program into the
; `ld hl` and `ld bc` of stage 2 and checks that the program cannot unpack over
; its own packed
; data.  The packed program is the second data block on the tape, after this
; one.

    SECTION BOOTSTRAP

    PUBLIC  __spc1500_bootstrap_built
    PUBLIC  __spc1500_bootstrap_org
    PUBLIC  __spc1500_bootstrap_reloc
    PUBLIC  __spc1500_bootstrap_top
    PUBLIC  __spc1500_bootstrap_len
    PUBLIC  __spc1500_bootstrap_clen
    PUBLIC  __spc1500_bootstrap_caddr
    EXTERN  __spc1500_start

    defc    __spc1500_bootstrap_built = 1
    defc    __spc1500_bootstrap_org = $0000
    defc    __spc1500_bootstrap_reloc = $F000       ; where the block runs (above everything the program uses)
    defc    __spc1500_bootstrap_top = $EFE0         ; where the packed program ends
    defc    __spc1500_bootstrap_len = 128           ; the IPL loads this much

    org     __spc1500_bootstrap_org

bootstrap_start:
    di
    ld      hl,bootstrap_start
    ld      de,__spc1500_bootstrap_reloc
    ld      bc,__spc1500_bootstrap_len
    ldir
    jp      __spc1500_bootstrap_reloc + stage2 - bootstrap_start

stage2:
    phase   __spc1500_bootstrap_reloc + stage2 - bootstrap_start
    ld      sp,__spc1500_bootstrap_reloc + $100     ; (the block is the 128 bytes at reloc: the stack grows down from above it)
    ld      bc,$1d00                                ; ROM select
    out     (c),a
    ld      hl,0                                    ; where the packed program goes (appmake's) ...
    defc    __spc1500_bootstrap_caddr = ASMPC-2
    ld      bc,0                                    ; ... and its length (appmake's)
    defc    __spc1500_bootstrap_clen = ASMPC-2
    push    hl
    call    $21b0                                   ; the ROM's loader (the IPL's own boot calls it here: RST $30 is $21AF, which starts with an exx)
    pop     hl
    jr      c,load_failed
    di
    ld      bc,$1e00                                ; RAM select
    out     (c),a
    ld      de,CRT_ORG_CODE
    call    dzx0_standard
    jp      __spc1500_start
load_failed:
    jr      load_failed

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
    dephase
bootstrap_end:
    defs    __spc1500_bootstrap_len - (bootstrap_end - bootstrap_start)
