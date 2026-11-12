; 8085 +test v2.6 BIOS disk layer. Same contract as bios_disk.asm.
; No ldir/srl/sbc hl,de/djnz. sra hl for host/slice; sub hl,bc for window.

SECTION code_compiler

DEFC    hstsiz  =    512
DEFC    hstblk  =    hstsiz/128
DEFC    hstspt  =    256
DEFC    cpmbls  =    4096
DEFC    cpmspt  =    hstspt * hstblk
DEFC    secmsk  =    hstblk-1
DEFC    wrdir   =    1
DEFC    wrual   =    2

PUBLIC  _bios_home
PUBLIC  _bios_settrk
PUBLIC  _bios_setsec
PUBLIC  _bios_setdma
PUBLIC  _bios_setdsk
PUBLIC  _bios_read
PUBLIC  _bios_write
PUBLIC  writehst
PUBLIC  readhst

EXTERN  ide_read_sector
EXTERN  ide_write_sector
EXTERN  hstbuf, hstdsk, hsttrk, hstsec, hstwrt, wrtype, dmaadr, erflag
EXTERN  _cpm_dsk0_base
EXTERN  sekdsk, sektrk, seksec, sekhst, hstact
EXTERN  unacnt, unadsk, unatrk, unasec
EXTERN  rsflag, readop
EXTERN  DIRBUF

_bios_home:
    call    home
    ret

_bios_settrk:
    ld      (sektrk),hl
    ret

_bios_setsec:
    ld      (seksec),hl
    ret

_bios_setdma:
    ld      (dmaadr),hl
    ret

_bios_setdsk:
    ld      a,l
    ld      (sekdsk),a
    ret

_bios_read:
    call    read
    ld      l,a
    ld      h,0
    ret

_bios_write:
    ld      c,l
    call    write
    ld      l,a
    ld      h,0
    ret

home:
    ld      a,(hstwrt)
    or      a
    jr      NZ,homed
    ld      (hstact),a
homed:
    ld      hl,$0000
    ld      (sektrk),hl
    ret

read:
    xor     a
    ld      (unacnt),a
    inc     a
    ld      (readop),a
    ld      (rsflag),a
    ld      a,wrual
    ld      (wrtype),a
    jp      rwoper

write:
    xor     a
    ld      (readop),a
    ld      a,c
    ld      (wrtype),a
    cp      wrual
    jr      NZ,chkuna
    ld      a,cpmbls/128
    ld      (unacnt),a
    ld      a,(sekdsk)
    ld      (unadsk),a
    ld      a,(sektrk)
    ld      (unatrk),a
    ld      hl,(seksec)
    ld      (unasec),hl
chkuna:
    ld      a,(unacnt)
    or      a
    jr      Z,alloc
    dec     a
    ld      (unacnt),a
    ld      a,(sekdsk)
    ld      hl,unadsk
    cp      (hl)
    jr      NZ,alloc
    ld      a,(sektrk)
    ld      hl,unatrk
    cp      (hl)
    jr      NZ,alloc
    ld      de,seksec
    ld      hl,unasec
    ld      a,(de+)
    cp      (hl+)
    jr      NZ,alloc
    ld      a,(de)
    cp      (hl)
    jr      NZ,alloc
    ld      hl,(unasec)
    inc     hl
    ld      (unasec),hl
    ld      bc,cpmspt
    sub     hl,bc
    jr      C,noovf
    ld      hl,0
    ld      (unasec),hl
    ld      hl,unatrk
    inc     (hl)
noovf:
    xor     a
    ld      (rsflag),a
    jr      rwoper
alloc:
    xor     a
    ld      (unacnt),a
    inc     a
    ld      (rsflag),a

rwoper:
    xor     a
    ld      (erflag),a
    ld      hl,(seksec)
    sra     hl
    sra     hl
    ld      a,l
    ld      (sekhst),a
    ld      hl,hstact
    ld      a,(hl)
    ld      (hl),1
    or      a
    jr      Z,filhst
    ld      a,(sekdsk)
    ld      hl,hstdsk
    cp      (hl)
    jr      NZ,nomatch
    ld      a,(sektrk)
    ld      hl,hsttrk
    cp      (hl)
    jr      NZ,nomatch
    ld      a,(sekhst)
    ld      hl,hstsec
    cp      (hl)
    jr      Z,match
nomatch:
    ld      a,(hstwrt)
    or      a
    call    NZ,writehst
filhst:
    ld      a,(sekdsk)
    ld      (hstdsk),a
    ld      a,(sektrk)
    ld      (hsttrk),a
    ld      a,(sekhst)
    ld      (hstsec),a
    ld      a,(rsflag)
    or      a
    call    NZ,readhst
    xor     a
    ld      (hstwrt),a
match:
    ld      a,(seksec)
    and     secmsk
    ld      h,a
    ld      l,0
    sra     hl
    ld      de,hstbuf
    add     hl,de
IFDEF FORCE_COPY
    ; pre-8b0c1e7: always copy 128 bytes
    ld      de,(dmaadr)
    ld      a,(readop)
    or      a
    jr      NZ,rwmove
    inc     a
    ld      (hstwrt),a
    ex      de,hl
ELSE
    push    hl
    ld      bc,de
    ld      hl,(dmaadr)
    sub     hl,bc
    jr      C,do_copy
    ld      a,h
    cp      2
    jr      NC,do_copy
    pop     hl
    ld      (DIRBUF),hl
    ld      a,(readop)
    or      a
    jr      NZ,after_move
    push    hl
do_copy:
    pop     hl
    ld      de,(dmaadr)
    ld      a,(readop)
    or      a
    jr      NZ,rwmove
    inc     a
    ld      (hstwrt),a
    ex      de,hl
ENDIF
rwmove:
    call    ldi_128
after_move:
    ld      a,(wrtype)
    and     wrdir
    ld      a,(erflag)
    ret     Z
    or      a
    ret     NZ
    xor     a
    ld      (hstwrt),a
    call    writehst
    ld      a,(erflag)
    ret

ldi_128:
    ld      bc,ldi_16
    push    bc
    push    bc
    push    bc
    push    bc
    push    bc
    push    bc
    push    bc
ldi_16:
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ret

writehst:
    call    setLBAaddr
    ld      hl,hstbuf
    call    ide_write_sector
    ret     C
    ld      a,$01
    ld      (erflag),a
    ret

readhst:
    call    setLBAaddr
    ld      hl,hstbuf
    call    ide_read_sector
    ret     C
    ld      a,$01
    ld      (erflag),a
    ret

setLBAaddr:
    ld      a,(hstdsk)
    call    getLBAbase
    ld      a,(hstsec)
    add     a,(hl+)
    ld      e,a
    ld      a,(hsttrk)
    adc     a,(hl+)
    ld      d,a
    ld      a,(hl+)
    adc     a,$00
    ld      c,a
    ld      a,(hl)
    adc     a,$00
    ld      b,a
    ret

getLBAbase:
    add     a,a
    add     a,a
    ld      hl,_cpm_dsk0_base
    add     a,l
    ld      l,a
    ret     NC
    inc     h
    ret
