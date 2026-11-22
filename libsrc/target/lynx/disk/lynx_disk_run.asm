;
;    Camputers Lynx 128K: reading and writing sectors, the one path that
;    lynx_disk_read and lynx_disk_write take
;
;    The disk interface's controller is a WD1793, read at ports $50 (status),
;    $51 (track), $52 (sector) and $53 (data) and written at $54 (command), $55,
;    $56 and $57; port $58 (write) selects the drive (bits 1-0) and the side
;    (bit 2), and bit 3 is the motor: 0 is on.  The disk is 40 tracks of 10
;    sectors of 512 bytes, numbered from 1 (a .ldf image, and appmake's +cpmdisk
;    -f lynx), one side.  A sector is moved by polling the status for the data
;    request: a byte every 32 us, so interrupts are off for the length of the
;    call (and come back if they were on).
;
;    The controller's head settling delay (the E bit) is asked for only on the
;    first sector after the heads moved: asked for on every sector, the delay is
;    longer than the gap to the next one, which then costs a whole turn of the
;    disk.
;
;    A failure to read or write a sector is tried again up to TRIES times, from
;    a restore.  A drive that is not ready (no disk, or no drive) is an error at
;    once.
;
;    The heads' position is remembered (the first call restores to track 0).
;    The motor is stopped at the end of each call, and a call waits for it to be
;    ready, so a program that moves a lot of sectors should do it in as few
;    calls as it can.
;
;    The C entries set the mode (0 read, 1 write) and jump here.  The arguments
;    are drive, track, sector, count and buf, pushed in that order (__smallc).
;

    MODULE  lynx_disk_run

    defc    TRIES=3

    SECTION code_clib
    PUBLIC  asm_lynx_disk_call
    PUBLIC  asm_lynx_disk_call_callee
    PUBLIC  asm_lynx_disk_regs

; Entry: a = the mode.  The caller's own return address is on the stack above
;   the arguments.
asm_lynx_disk_call:
    ld      (mode), a
    call    load_args
    jr      run

asm_lynx_disk_call_callee:
    ld      (mode), a
    call    load_args
    pop     bc                      ;the return address
    pop     de                      ;and the five arguments
    pop     de
    pop     de
    pop     de
    pop     de
    push    bc
    jr      run

; The same from assembler, with the arguments in registers.
; Entry: a = the mode (0 read, 1 write), e = drive, d = track (0 to 39), c =
;   sector (1 to 10), b = count, hl = buf.
; Exit: hl = 0, or 1 on an error.
asm_lynx_disk_regs:
    ld      (mode), a
    ld      a, e
    ld      (drive), a
    ld      a, d
    ld      (track), a
    ld      a, c
    ld      (sector), a
    ld      a, b
    ld      (count), a

; Entry: hl = buf and the variables set.  Exit: hl = 0, or 1 on an error.
run:
    ld      a, TRIES
    ld      (tries), a
    ld      a, $04
    ; (the head settling delay for the first sector of the call only)
    ld      (efl), a
    ld      a, i                    ;(the interrupt flag, kept on the stack)
    push    af
    di
    ld      (buf), hl
next:
    ld      a, (count)
    or      a
    jp      z, done
    call    position
    jp      nz, retry
    ld      a, (sector)
    out     ($56), a
    ld      hl, (buf)
    ld      a, (mode)
    or      a
    jr      nz, write
    ld      a, (efl)
    ; read sector, with the head settling delay for the first
    or      $80
    out     ($54), a
    ld      d, 0
    ld      e, 2                    ;512 bytes: twice 256
read_byte:
    in      a, ($50)
    bit     1, a                    ;data request?
    jr      nz, read_got
    rrca
    jr      c, read_byte            ;still busy
    jp      retry                   ;the command ended without the data
read_got:
    in      a, ($53)
    ld      (hl), a
    inc     hl
    dec     d
    jr      nz, read_byte
    dec     e
    jr      nz, read_byte
    call    fdc_wait
    ; lost data, CRC error, record not found, or never finished
    and     $1D
    jp      nz, retry
    jr      moved
write:
    ld      a, (efl)
    or      $A0                     ;write sector
    out     ($54), a
    ld      d, 0
    ld      e, 2
write_byte:
    in      a, ($50)
    bit     1, a
    jr      nz, write_got
    rrca
    jr      c, write_byte
    jp      retry
write_got:
    ld      a, (hl)
    out     ($57), a
    inc     hl
    dec     d
    jr      nz, write_byte
    dec     e
    jr      nz, write_byte
    call    fdc_wait
    ; lost data, CRC, record not found, write fault, write protected, or
    ; never finished
    and     $7D
    jp      nz, retry
moved:
    xor     a
    ld      (efl), a                ;(the head is settled)
    ld      a, TRIES                ;(the next sector has its own attempts)
    ld      (tries), a
    ld      (buf), hl
    ld      hl, count
    dec     (hl)
    ld      a, (sector)
    inc     a
    ld      (sector), a
    cp      11
    jp      c, next
    ld      a, 1                    ;after sector 10: the next track
    ld      (sector), a
    ld      hl, track
    inc     (hl)
    jp      next
done:
    ld      hl, 0
    jr      finish
retry:
    ld      a, (tries)
    or      a
    jr      z, error                ;(out of attempts)
    dec     a
    ld      (tries), a
    ; force interrupt: idle, then the heads are found again and the sector
    ; tried again
    ld      a, $D0
    out     ($54), a
    xor     a
    ld      (cyl1), a
    ld      a, $04
    ld      (efl), a
    jp      next
error:
    ; force interrupt: the controller is idle again
    ld      a, $D0
    out     ($54), a
    ld      hl, 1
finish:
    ld      a, 8
    out     ($58), a                ;the motor off
    pop     af
    ret     po
    ei
    ret

; The drive selected with its motor on and the heads on the track.  Z if all is
;   well.  Uses all.
position:
    ld      a, (drive)
    and     3                       ;(bit 3 clear: the motor is on)
    out     ($58), a
    ; (the motor takes a while to come up to speed)
    ld      b, 3
ready0: 
    ld      hl, 0
ready:  
    in      a, ($50)
    rlca                            ;bit 7: not ready
    jr      nc, ready_ok
    dec     hl
    ld      a, h
    or      l
    jr      nz, ready
    djnz    ready0
    jr      notready
ready_ok:
    ld      a, (track)
    ld      d, a                    ;the track
    ld      a, (cyl1)
    or      a
    jr      nz, known
    ; restore, 30 ms a step (the rate the Lynx's own boot sector uses)
    ld      a, $0B
    out     ($54), a
    call    fdc_wait
    ; not ready, or still busy (bit 2 is "at track 0")
    and     $81
    jr      nz, failed
    ld      a, 1
    ld      (cyl1), a               ;(the track plus one: 0 is not known)
    ld      a, $04
    ld      (efl), a
known:
    ld      a, (cyl1)
    dec     a
    cp      d
    jr      z, there
    ld      a, d
    out     ($57), a                ;the data register is where to go
    ; seek, 30 ms a step (no verify: the sector commands check the IDs)
    ld      a, $1B
    out     ($54), a
    call    fdc_wait
    ; not ready, CRC error, record not found, still busy
    and     $99
    jr      nz, failed
    ld      a, d
    inc     a
    ld      (cyl1), a
    ld      a, $04
    ld      (efl), a
there:
    xor     a
    ret
notready:
    xor     a
    ld      (cyl1), a
    ; (no attempts left: a drive that is not ready stays not ready)
    ld      (tries), a
    or      1
    ret
failed:
    xor     a
    ld      (cyl1), a               ;(where the heads are is not known now)
    or      1
    ret

; Wait for the controller to finish its command (bounded: a seek across the disk
;   takes about a second).  Exit: a = its status; bit 0
; is still set if it never did.  Keeps bc and de.
fdc_wait:
    push    bc
    push    de
    ld      b, 24
    ld      de, 0
wait_busy:
    in      a, ($50)
    rrca
    jr      nc, wait_done
    dec     de
    ld      a, d
    or      e
    jr      nz, wait_busy
    djnz    wait_busy
wait_done:
    in      a, ($50)
    pop     de
    pop     bc
    ret

; The arguments from the stack, two calls down: hl = buf.  (call load_args, then
;   the entry's own return address, then ours)
load_args:
    ld      hl, 4
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                 ;buf
    inc     hl
    ld      a, (hl)
    ld      (count), a
    inc     hl
    inc     hl
    ld      a, (hl)
    ld      (sector), a
    inc     hl
    inc     hl
    ld      a, (hl)
    ld      (track), a
    inc     hl
    inc     hl
    ld      a, (hl)
    ld      (drive), a
    ex      de, hl
    ret

        SECTION bss_clib
mode:   defb    0
drive:  defb    0
track:  defb    0
sector: defb    0
count:  defb    0
; the track the heads are on, plus one (0: not known)
cyl1:   defb    0
buf:    defw    0
tries:  defb    0                       ;the attempts left at this sector
; 4 until the first sector after a move is through: the E bit of the command
efl:    defb    0
