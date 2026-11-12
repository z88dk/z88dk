
;	Sharp MZ-800 specific routines
;
;	int mz800_disk_rw(uint8_t write, uint8_t drive, uint16_t sector, void *buf) __smallc;
;	void mz800_disk_off(void);
;
;	Read or write one 256 byte MFM sector by driving the MB8876 directly (no IPL service): ports $D8 command/status, $D9 track, $DA sector, $DB data,
;	$DC drive and motor, $DD side.  The bus is inverted: values written to or read from $D8-$DA are complemented; data goes in and out unchanged (the IPL's discs hold it
;	complemented).
;	`sector` is the IPL's logical sector: track = sector / 16, cylinder = track / 2, side = track & 1 ($DD gets $FF for side 0, $FE for side 1), ID = sector % 16 + 1;
;	so sector 0 of a boot disc is the IPL header.
;	Returns 0, else the controller's error bits (never 0) or $ff for a short sector.  Three attempts, restoring to track 0 before each retry.  The motor starts (with a
;	wait to spin up) at the first call and runs until mz800_disk_off.  Interrupts are not touched: keep them off.  Preserves IX.
;

    SECTION code_clib
    PUBLIC  mz800_disk_rw
    PUBLIC  _mz800_disk_rw
    PUBLIC  mz800_disk_off
    PUBLIC  _mz800_disk_off

mz800_disk_rw:
_mz800_disk_rw:
    push    ix
    ld      hl,4
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (dk_buf),de
    inc     hl
    ld      c,(hl)                      ; the logical sector
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      a,(hl)                      ; drive
    and     3
    ld      (dk_drive),a
    inc     hl
    inc     hl
    ld      a,(hl)                      ; write
    ld      (dk_wr),a
    ld      a,c
    and     15
    inc     a
    ld      (dk_sec),a                  ; sector ID
    ld      h,b
    ld      l,c
    srl     h                           ; track = sector / 16
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    ld      a,$ff                       ; side 0: $FF, side 1: $FE
    bit     0,l
    jr      z,dk_s0
    dec     a
dk_s0:
    ld      (dk_head),a
    srl     l                           ; cylinder = track / 2
    ld      a,l
    ld      (dk_cyl),a
    ld      a,3
    ld      (dk_try),a
dk_again:
    call    dk_once
    jr      z,dk_ok
    ld      l,a
    ld      a,$ff
    ld      (dk_at),a                   ; the heads' place is no longer known
    ld      a,(dk_try)
    dec     a
    ld      (dk_try),a
    jr      nz,dk_again
    ld      h,0
    pop     ix
    ret
dk_ok:
    ld      hl,0
    pop     ix
    ret

mz800_disk_off:
_mz800_disk_off:
    xor     a
    out     ($dc),a
    ld      (dk_on),a
    ret

; one attempt: z set for success, else nz and a = the error bits ($ff if the sector was cut short)
dk_once:
    ld      a,(dk_drive)
    or      $80                         ; motor on
    ld      c,a
    ld      a,(dk_on)
    cp      c
    jr      z,dk_spun
    ld      a,c
    out     ($dc),a
    ld      (dk_on),a
    ld      a,$ff
    ld      (dk_at),a                   ; (a different drive or a motor just started)
    call    dk_delay
dk_spun:
    ld      a,(dk_head)
    out     ($dd),a
    ld      a,(dk_at)
    cp      $ff
    jr      nz,dk_known
    ld      a,$f4                       ; restore with head load: ~$0B
    out     ($d8),a
    call    dk_wait
    xor     a
    ld      (dk_at),a
dk_known:
    ld      a,(dk_cyl)
    ld      b,a
    ld      a,(dk_at)
    cp      b
    jr      z,dk_there
    ld      a,b
    cpl
    out     ($db),a                     ; the track wanted
    ld      a,$e4                       ; seek with verify and head load: ~$1B
    out     ($d8),a
    call    dk_wait
    ld      a,(dk_cyl)
    ld      (dk_at),a
dk_there:
    ld      a,(dk_sec)
    cpl
    out     ($da),a
    ld      hl,(dk_buf)
    ld      a,(dk_wr)
    or      a
    jr      nz,dk_w
    ld      a,$7b                       ; read sector with the head settling delay: ~$84
    out     ($d8),a
    nop
    nop
dk_r:
    in      a,($d8)
    cpl
    bit     1,a
    jr      nz,dk_rb
    rra
    jr      c,dk_r
    ld      c,$9c                       ; not ready, record not found, CRC error, lost data
    jr      dk_end
dk_rb:
    in      a,($db)
    ld      (hl),a
    inc     hl
    jr      dk_r
dk_w:
    ld      a,$5b                       ; write sector with the head settling delay: ~$A4
    out     ($d8),a
    nop
    nop
dk_wl:
    in      a,($d8)
    cpl
    bit     1,a
    jr      nz,dk_wb
    rra
    jr      c,dk_wl
    ld      c,$fc                       ; ... and write protect, write fault
    jr      dk_end
dk_wb:
    ld      a,(hl)
    out     ($db),a
    inc     hl
    jr      dk_wl
dk_end:
    in      a,($d8)
    cpl
    and     c
    ret     nz
    ld      de,(dk_buf)                 ; all 256 bytes moved?
    ld      a,l
    cp      e
    jr      nz,dk_short
    ld      a,h
    sub     d
    cp      1
    ret                                 ; z if the sector was moved in full
dk_short:
    ld      a,$ff
    or      a
    ret

; wait for the controller not to be busy (about 3 seconds at most)
dk_wait:
    nop
    nop
    nop
    ld      bc,0
    ld      d,6
dkw1:
    in      a,($d8)
    cpl
    and     1
    ret     z
    dec     bc
    ld      a,b
    or      c
    jr      nz,dkw1
    dec     d
    jr      nz,dkw1
    ret

dk_delay:                               ; about half a second for the motor
    ld      b,2
dkd1:
    ld      hl,0
dkd2:
    dec     hl
    ld      a,h
    or      l
    jr      nz,dkd2
    djnz    dkd1
    ret

    SECTION bss_clib
dk_buf:     defw    0
dk_sec:     defb    0
dk_head:    defb    0
dk_cyl:     defb    0
dk_drive:   defb    0
dk_wr:      defb    0
dk_try:     defb    0
dk_on:      defb    0
dk_at:      defb    0
