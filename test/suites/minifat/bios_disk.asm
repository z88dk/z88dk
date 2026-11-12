; +test v2.6 BIOS disk layer (no PHASE, no ROM paging).
; Not this branch's product BIOS. READ/WRITE deblock on ram ide_read/write.
; LBA = _cpm_dsk0_base[dsk] + hstsec + (hsttrk << 8)  (v2 / six-port BIOS)

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

; C: void bios_home(void)
_bios_home:
    call    home
    ret

; C fastcall: void bios_settrk(uint16_t)
_bios_settrk:
    ld      (sektrk),hl
    ret

; C fastcall: void bios_setsec(uint16_t)
_bios_setsec:
    ld      (seksec),hl
    ret

; C fastcall: void bios_setdma(void *)
_bios_setdma:
    ld      (dmaadr),hl
    ret

; C fastcall: void bios_setdsk(uint8_t)
_bios_setdsk:
    ld      a,l
    ld      (sekdsk),a
    ret

; C: uint8_t bios_read(void)
_bios_read:
    call    read
    ld      l,a
    ld      h,0
    ret

; C fastcall: uint8_t bios_write(uint8_t wrtype)
_bios_write:
    ld      c,l
    call    write
    ld      l,a
    ld      h,0
    ret

home:
    ld      a,(hstwrt)      ;PAT 09: keep host buffer if dirty
    or      a
    jr      NZ,homed
    ld      (hstact),a
homed:
    ld      bc,$0000
    ld      (sektrk),bc
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
    ld      de,cpmspt
    sbc     hl,de
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
    ld      a,l
    srl     h
    rra
    srl     h
    rra
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
    srl     h
    rr      l
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
    ld      hl,(dmaadr)
    or      a
    sbc     hl,de
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
    ld      bc,ldi_32
    push    bc
    push    bc
    push    bc
ldi_32:
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
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
