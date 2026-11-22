;
;	Sharp MZ-2500 specific routines
;
;	int mz2500_disk_rw(uint8_t write, uint8_t drive, uint8_t cylinder, uint8_t head, uint8_t sector, void *buf) __smallc;
;	void mz2500_disk_off(void);
;
;	Read or write one 256 byte MFM sector by driving the MB8877 floppy controller directly (no IPL
;	service, so no window or stack restrictions): ports $D8 command/status, $D9 track, $DA sector,
;	$DB data, $DC drive and motor, $DD side.  The controller's bus is inverted (every value written to
;	or read from $D8-$DA is complemented; data bytes go in and come out unchanged, so what is written
;	is read back as it was).  `sector` is the sector ID on the track (1-16 on the IPL's disks).
;	Returns 0 for success, else the controller's error bits (never 0) or $100 if it did not answer.
;	Three attempts, restoring to track 0 before each retry.  The motor is switched on (with a wait to
;	spin up) at the first call and stays on until mz2500_disk_off.  Interrupts are not touched: they
;	should be off, or the handler must not use the controller.  Preserves IX.
;

    SECTION code_clib
    PUBLIC  mz2500_disk_rw
    PUBLIC  _mz2500_disk_rw
    PUBLIC  mz2500_disk_off
    PUBLIC  _mz2500_disk_off

mz2500_disk_rw:
_mz2500_disk_rw:
    push    ix
    ld      hl,4
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (dk_buf),de
    inc     hl
    ld      a,(hl)                      ; sector
    ld      (dk_sec),a
    inc     hl
    inc     hl
    ld      a,(hl)                      ; head
    ld      (dk_head),a
    inc     hl
    inc     hl
    ld      a,(hl)                      ; cylinder
    ld      (dk_cyl),a
    inc     hl
    inc     hl
    ld      a,(hl)                      ; drive
    and     3
    ld      (dk_drive),a
    inc     hl
    inc     hl
    ld      a,(hl)                      ; write
    ld      (dk_wr),a
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

mz2500_disk_off:
_mz2500_disk_off:
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
    ld      a,$fe                       ; restore, 12 ms steps: ~$01
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
    ld      a,$ee                       ; seek, 12 ms steps: ~$11
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
    ld      a,$7f                       ; read sector: ~$80
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
    ld      a,$5f                       ; write sector: ~$A0
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
