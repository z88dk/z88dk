; Aquarius+ all-RAM AQX bootstrap.
;
; This is emitted as <program>_BOOTSTRAP.bin.  appmake loads it at $3e00;
; it maps plusBASIC's pages 56..59, relocates to $0000, installs safe vector
; defaults, loads the sibling stage-1 .bin at CRT_ORG_CODE ($0200 unless a pragma says otherwise; below $4000), then
; transfers control.

    SECTION BOOTSTRAP

    PUBLIC __aqx_bootstrap_built
    defc   __aqx_bootstrap_built = 1

    defc LOADER_ENTRY      = $0080
    defc LOADER_READ_BLOCK = $00d0
    defc LOADER_SEND_CMD   = $0100
    defc LOADER_SEND_BYTE  = $0110
    defc LOADER_READ_BYTE  = $0120
    defc LOADER_READ_BYTES = $0130
    defc LOADER_FILENAME   = $0140
    defc LOADER_FD         = $0157

    ; The relocation prefix is padded to $80 bytes below, so loader_entry
    ; is linked at its post-relocation address of $0080.
    org $0000

bootstrap_start:
    di
    ; The AQX image at $3e00 fits wholly below $4000.  Copy it to bank 1
    ; before replacing bank 0, so source and destination cannot overlap.
    ld a,57
    out (PORT_BANK1),a
    ld a,58
    out (PORT_BANK2),a
    ld a,59
    out (PORT_BANK3),a

    ld hl,$3e00
    ld de,$4000
    ld bc,bootstrap_end-bootstrap_start
    ldir
    jp $4000+bootstrap_relocate-bootstrap_start

; This code runs from the temporary copy at $4000, so it is safe to claim
; bank 0 and finish the relocation into the reserved low page.
bootstrap_relocate:
    ld a,56
    out (PORT_BANK0),a
    ; The high-address relay is not part of the low-memory image.  Copy only
    ; the loader body to its final $0080 address.
    ld hl,$4000+LOADER_ENTRY
    ld de,LOADER_ENTRY
    ld bc,bootstrap_end-bootstrap_start-LOADER_ENTRY
    ldir
    ld hl,$4000+vector_template-bootstrap_start
    ld de,$0000
    ld bc,vector_template_end-vector_template
    ldir
    jp LOADER_ENTRY

    defs LOADER_ENTRY-($-bootstrap_start),0

loader_entry:
    ld sp,$01ff
    ld a,$10                    ; ESPCMD_OPEN
    call LOADER_SEND_CMD
    xor a                       ; O_RDONLY
    call LOADER_SEND_BYTE
    ld hl,LOADER_FILENAME
    ld b,12                     ; appmake patches name length including NUL
send_filename:
    ld a,(hl)
    inc hl
    call LOADER_SEND_BYTE
    djnz send_filename
    call LOADER_READ_BYTE
    ld (LOADER_FD),a
    bit 7,a
    jr nz,loader_failed

    ld hl,CRT_ORG_CODE          ; the program: up to $4000 (CRT_ORG_CODE is $0200 unless a pragma says otherwise)
    ld de,$4000-CRT_ORG_CODE
    call LOADER_READ_BLOCK
    ld hl,$4000
    ld de,$4000
    call LOADER_READ_BLOCK
    ld hl,$8000
    ld de,$4000
    call LOADER_READ_BLOCK
    ld hl,$c000
    ld de,$4000
    call LOADER_READ_BLOCK
    jp CRT_ORG_CODE
loader_failed:
    di
loader_halt:
    halt
    jr loader_halt

    defs LOADER_READ_BLOCK-($-bootstrap_start),0

loader_read_block:
    push hl
    push de
    ld a,$12                    ; ESPCMD_READ
    call LOADER_SEND_CMD
    ld a,(LOADER_FD)
    call LOADER_SEND_BYTE
    pop de
    ld a,e
    call LOADER_SEND_BYTE
    ld a,d
    call LOADER_SEND_BYTE
    call LOADER_READ_BYTE
    or a
    jr nz,read_failed
    call LOADER_READ_BYTE
    ld c,a
    call LOADER_READ_BYTE
    ld b,a
    pop hl
    jp LOADER_READ_BYTES
read_failed:
    pop hl
    di
read_halt:
    halt
    jr read_halt

    defs LOADER_SEND_CMD-($-bootstrap_start),0

loader_send_cmd:
    ex af,af'
    ld a,$83
    out (PORT_ESPCTRL),a
    ex af,af'
    jp LOADER_SEND_BYTE

    defs LOADER_SEND_BYTE-($-bootstrap_start),0
loader_send_byte:
    push af
send_wait:
    in a,(PORT_ESPCTRL)
    and 2
    jr nz,send_wait
    pop af
    out (PORT_ESPDATA),a
    ret

    defs LOADER_READ_BYTE-($-bootstrap_start),0
loader_read_byte:
read_wait:
    in a,(PORT_ESPCTRL)
    and 1
    jr z,read_wait
    in a,(PORT_ESPDATA)
    ret

    defs LOADER_READ_BYTES-($-bootstrap_start),0
loader_read_bytes:
    ld a,b
    or c
    ret z
    call LOADER_READ_BYTE
    ld (hl),a
    inc hl
    dec bc
    jr loader_read_bytes

    defs LOADER_FILENAME-($-bootstrap_start),0
loader_filename:
    defm "program.bin"
    defb 0
    defs LOADER_FD-($-bootstrap_start),0
loader_fd:
    defb 0

; RST handlers return.  IM 1 returns with RETI; NMI returns with RETN.
vector_template:
    defb $c9,0,0,0,0,0,0,0
    defb $c9,0,0,0,0,0,0,0
    defb $c9,0,0,0,0,0,0,0
    defb $c9,0,0,0,0,0,0,0
    defb $c9,0,0,0,0,0,0,0
    defb $c9,0,0,0,0,0,0,0
    defb $c9,0,0,0,0,0,0,0
    defb $ed,$4d,0,0,0,0,0,0
    defs $66-($-vector_template),0
    defb $ed,$45
vector_template_end:
bootstrap_end:
