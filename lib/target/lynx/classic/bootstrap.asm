;
;    Camputers Lynx 128K: the boot sector of a -subtype=allram disk
;    (appmake +lynx --disc puts it in the first sector)
;
;    The DOS ROM's EXT BOOT (after XROM) reads the disk's first sector to an
;    address of its own choosing (about $4600 on the machines looked at) and
;    runs it from its offset 2 with HL = the address it jumped to.  What it
;    looks for in the sector is the header a CP/M system disk has: NOP, NOP,
;    JR to the code, and "Lynx disks, Copyright Intelligent Software" at
;    offset $14.
;
;    Nothing absolute can be used before the sector is copied to where it is
;    linked ($CF00), so that is the first thing it does.  It then reads the
;    program, from the second sector of the disk (track 0, sector 2) on, to
;    CRT_ORG_CODE: as many 512 byte sectors as it needs to reach
;    __DATA_END_tail (so the program, and what appmake +lynx --disc --data
;    adds after it, must end below $CF00), and starts it there.  A read that
;    goes wrong begins again from the start.  The sectors are numbered from
;    1, 10 to a track.
;

    SECTION BOOTSTRAP
    EXTERN  __DATA_END_tail

    ORG $CF00

    defc    PORT_BANK = $82
    defc    NORMAL = $08        ; the user RAM is read and written

    defb    0, 0
    jr  bs_start                ; (to $CF3F)
    defb    0, $81, 0, $1B      ; (as the system disk's header has them)
    defs    12
    defm    "Lynx disks, Copyright Intelligent Software"
    defb    0

bs_start:
    di
    dec hl
    dec hl                      ; the sector's address
    ld  de,$CF00
    ld  bc,512
    ldir
    jp  bs_go
bs_go:
    di
    ld  sp,$FFF0
    xor a
    ; the control port: cassette and the rest off (the BASIC and the DOS leave
    ;   bits that stop the video RAM being written)
    out ($80),a
    ld  a,NORMAL
    out (PORT_BANK),a
    xor a
    out ($58),a                 ; drive 0, the motor on (bit 3 clear), side 0
    ld  hl,0
    ld  b,8
bs_ready:
    in  a,($50)                 ; (the motor comes up to speed: a wait, bounded)
    rlca
    jr  nc,bs_restore
    dec hl
    ld  a,h
    or  l
    jr  nz,bs_ready
    djnz    bs_ready
bs_restore:
    xor a
    ld  (bs_curt),a
    ; restore, 30 ms a step as the system disk's own boot sector does
    ld  a,$0B
    out ($54),a
    call    bs_wbusy
    ld  hl,CRT_ORG_CODE         ; the program
    ld  a,+((__DATA_END_tail - CRT_ORG_CODE) + 511) / 512
    ld  (bs_cnt),a
    ld  d,0                     ; track 0
    ld  e,2                     ; sector 2: the boot sector was sector 1
bs_rd_n:
    call    bs_rd_sec
    inc e
    ld  a,e
    cp  11
    jr  c,bs_rd_nx
    ld  e,1
    inc d
bs_rd_nx:
    ld  a,(bs_cnt)
    dec a
    ld  (bs_cnt),a
    jr  nz,bs_rd_n
    ld  a,8
    out ($58),a                 ; the motor off
    jp  CRT_ORG_CODE

; the sector e of the track d to hl on (512 bytes): a failure starts all over
bs_rd_sec:
    ld  a,(bs_curt)
    cp  d
    jr  z,bs_rs_ons
    ld  a,d
    out ($57),a                 ; the data register: where to go
    ld  a,$1B                   ; seek (30 ms a step)
    out ($54),a
    call    bs_wbusy
    ld  a,d
    ld  (bs_curt),a
bs_rs_ons:
    ld  a,e
    out ($56),a
    ld  a,$84                   ; read sector, with the head settling delay
    out ($54),a
    ld  bc,512
bs_rs_b:
    in  a,($50)
    bit 1,a                     ; data request?
    jr  nz,bs_rs_g
    rrca
    jr  c,bs_rs_b               ; still busy
    jp  bs_go                   ; ended without the data
bs_rs_g:
    in  a,($53)
    ld  (hl),a
    inc hl
    dec bc
    ld  a,b
    or  c
    jr  nz,bs_rs_b
    call    bs_wbusy
    in  a,($50)
    and $1D                     ; lost data, CRC error, record not found
    ret z
    jp  bs_go

bs_wbusy:
    in  a,($50)
    rrca
    jr  c,bs_wbusy
    ret

bs_curt:
    defb    0                   ; the track the heads are on
bs_cnt:
    defb    0
