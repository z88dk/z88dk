;
; Toshiba Pasopia 7: the floppy disk, with no ROM and no interrupts: a
; polled uPD765A.
;
;   int pasopia7_disk_read(uint8_t drive, uint8_t track, uint8_t sector,
;                          uint8_t count, void *buf) __smallc;
;   int pasopia7_disk_write(uint8_t drive, uint8_t track, uint8_t sector,
;                           uint8_t count, const void *buf) __smallc;
;   asm_pasopia7_disk_rw   the same in registers: a = 0 read, 1 write;
;                          e = drive (0 to 3), d = track, c = sector,
;                          b = count, hl = buffer
;
; Reads or writes `count` (1 to 255) sectors of 256 bytes from `sector` (1 to
; 16) of `track` (the cylinder: the disks are single sided, 40 tracks of 16
; sectors, numbered from 1 in order: appmake +pasopia7's image), carrying on
; to the next track after sector 16.  Returns 0 or an error: 2 not ready,
; 3 the seek failed, 4 the controller refused or said no, 5 timed out.  Uses
; all registers but IX and IY.  The drive's motor is turned on for the call
; and off at the end of it.  Interrupts are the caller's (the routines do not
; use any); the ROM is not used, so it works with the machine all RAM.
;
; The controller's ports (and its other numbers: lib/target/pasopia7/def/pasopia7.h):
; $E4 (read) the main status register, $E5 the data
; register;  $E2 (write) terminal count on and $E0 off;  $E6 (write): bit 6
; the motor, bit 7 resets the controller (not used here).  The controller is
; put in non-DMA mode (Specify), so a byte is moved when the main status
; register's RQM and NDM bits say so.  A sector takes 32 us a byte (250 kbit/s,
; MFM); the loops move one in about 26 us at 4 MHz.  A read or write is ended
; by the terminal count after the last byte, so the controller does not go on
; to the next sector.  The variables are in the code's section: the machine is
; all RAM.

    SECTION code_clib
    PUBLIC  asm_pasopia7_disk_rw
    PUBLIC  pasopia7_disk_read, _pasopia7_disk_read
    PUBLIC  pasopia7_disk_write, _pasopia7_disk_write

; the C entries (__smallc: the last argument is at sp+2)
pasopia7_disk_write:
_pasopia7_disk_write:
    ld      a, 1
    jr      fd_c
pasopia7_disk_read:
_pasopia7_disk_read:
    xor     a
fd_c:   ld      hl, 2
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    push    de              ; the buffer
    ld      b, (hl)         ; count
    inc     hl
    inc     hl
    ld      c, (hl)         ; sector
    inc     hl
    inc     hl
    ld      d, (hl)         ; track
    inc     hl
    inc     hl
    ld      e, (hl)         ; drive
    pop     hl
    jp      fd_regs

    defc    asm_pasopia7_disk_rw=fd_regs

    INCLUDE "target/pasopia7/def/pasopia7.h"

; Carry set and the error code in fd_err
fd_error:
    ld      (fd_err), a
    scf
    ret

fd_regs:
    ld      (fd_mode), a
    ld      a, e
    ld      (fd_unit), a
    ld      a, d
    ld      (fd_track), a
    ld      a, c
    ld      (fd_sector), a
    ld      a, b
    ld      (fd_count), a
    ld      (fd_buf), hl
    ld      bc, FDC_CTRL
    ld      a, FDC_CTRL_MOTOR
    out     (c), a          ; the motor on
    ld      hl, fd_spec
    ld      d, 3
    call    fd_cmd
    jr      c, fd_ret_err
fd_next:
    ld      a, (fd_count)
    or      a
    jr      z, fd_ok
    ld      a, FDC_TRIES
    ld      (fd_tries), a
fd_again:
    call    fd_sector_io
    jr      nc, fd_done
    ld      a, (fd_tries)
    dec     a
    ld      (fd_tries), a
    jr      z, fd_ret_err
    ld      a, $FF
    ld      (fd_cur), a         ; (the heads are found again before another try)
    jr      fd_again
fd_done:
    ld      hl, (fd_buf)
    inc     h
    ld      (fd_buf), hl
    ld      hl, fd_count
    dec     (hl)
    ld      a, (fd_sector)
    inc     a
    cp      17
    jr      c, fd_sec
    ld      hl, fd_track
    inc     (hl)
    ld      a, 1
fd_sec: ld      (fd_sector), a
    jr      fd_next
fd_ok:  call    fd_motor_off
    ld      hl, 0
    ret
fd_ret_err:
    call    fd_motor_off
    ld      a, (fd_err)
    ld      l, a
    ld      h, 0
    ret
fd_motor_off:
    ld      bc, FDC_CTRL
    xor     a
    out     (c), a
    ret

; The main status register once RQM is set: a = it.  Carry set on a timeout.  (The timeout counts in the alternate registers, so the callers' own are kept.)
fd_rqm:
    exx
    ld      de, 0
    exx
    ld      bc, FDC_MSR
fq1:    in      a, (c)
    bit     7, a
    jr      nz, fq_ok
    exx
    dec     de
    ld      a, d
    or      e
    exx
    jr      nz, fq1
    ld      a, FDC_E_TIMEOUT
    jp      fd_error
fq_ok:  or      a
    ret

; A command: hl = its bytes, d = how many.  Carry set on an error.
fd_cmd:
    ld      bc, FDC_MSR
    ld      e, 0
fcb:    in      a, (c)
    and     MSR_CB          ; (a command still running)
    jr      z, fcl
    dec     e
    jr      nz, fcb
    ld      a, FDC_E_TIMEOUT
    jp      fd_error
fcl:    call    fd_rqm
    ret     c
    bit     6, a            ; the direction must be to the controller
    jr      nz, fd_bad
    ld      a, (hl)
    inc     hl
    ld      c, FDC_DATA
    out     (c), a
    dec     d
    jr      nz, fcl
    or      a
    ret
fd_bad: ld      a, FDC_E_FDC
    jp      fd_error

; One result byte: a = it.  Carry set on an error.
fd_res1:
    call    fd_rqm
    ret     c
    bit     6, a            ; the direction must be to the CPU
    jr      z, fd_bad
    ld      c, FDC_DATA
    in      a, (c)
    or      a
    ret

; Wait for a seek or recalibrate to end and sense it: carry set if it did not end well.
fd_seekend:
    ld      bc, FDC_MSR
    ld      de, 0
fse1:   in      a, (c)
    and     MSR_DRIVES_BUSY ; (a drive still seeking)
    jr      z, fse2
    dec     de
    ld      a, d
    or      e
    jr      nz, fse1
    ld      a, FDC_E_TIMEOUT
    jp      fd_error
fse2:   ld      hl, fd_sis
    ld      d, 1
    call    fd_cmd
    ret     c
    call    fd_res1         ; st0
    ret     c
    ld      (fd_st0), a
    call    fd_res1         ; the cylinder it reached
    ret     c
    ld      a, (fd_st0)
    and     ST0_END_MASK    ; the seek end bit, without the abnormal or invalid command bits
    cp      ST0_SEEK_END
    jr      z, fse3
    ld      a, FDC_E_SEEK
    jp      fd_error
fse3:   or      a
    ret

; The drive up to speed: carry set if it never is.
fd_ready:
    ld      hl, FDC_SPINUP
    ld      (fd_wait), hl
frd:    ld      a, (fd_unit)
    ld      (fd_sds+1), a
    ld      hl, fd_sds
    ld      d, 2
    call    fd_cmd
    ret     c
    call    fd_res1         ; st3
    ret     c
    bit     5, a            ; ready
    jr      nz, frd_ok
    ld      hl, (fd_wait)
    dec     hl
    ld      (fd_wait), hl
    ld      a, h
    or      l
    jr      nz, frd
    ld      a, FDC_E_NOTREADY
    jp      fd_error
frd_ok: or      a
    ret

; One sector: carry set on an error (and fd_err).
fd_sector_io:
    ld      a, (fd_track)
    ld      (fd_cylw), a
    xor     a
    ld      (fd_head), a
    call    fd_ready
    ret     c
    ld      a, (fd_cur)         ; the heads: where they are, or $FF if not known
    cp      $FF
    jr      nz, fio_pos
    ld      a, (fd_unit)
    ld      (fd_recal_b+1), a
    ld      hl, fd_recal_b
    ld      d, 2
    call    fd_cmd
    ret     c
    call    fd_seekend
    ret     c
    xor     a
    ld      (fd_cur), a
fio_pos:
    ld      a, (fd_cylw)
    ld      b, a
    ld      a, (fd_cur)
    cp      b
    jr      z, fio_go
    ld      a, (fd_unit)
    ld      (fd_seek_b+1), a
    ld      a, b
    ld      (fd_seek_b+2), a
    ld      hl, fd_seek_b
    ld      d, 3
    call    fd_cmd
    ret     c
    call    fd_seekend
    ret     c
    ld      a, (fd_cylw)
    ld      (fd_cur), a
fio_go: ld      a, (fd_mode)        ; the command: MFM read data ($46) or MFM write data ($45), drive and head, C, H, R, N = 1 (256 bytes),
    or      a               ; EOT = R, GPL, DTL
    ld      a, FDC_CMD_READ
    jr      z, fio_c
    ld      a, FDC_CMD_WRITE
fio_c:  ld      (fd_rw), a
    ld      a, (fd_head)
    add     a, a
    add     a, a
    ld      b, a
    ld      a, (fd_unit)
    or      b
    ld      (fd_rw+1), a
    ld      a, (fd_cylw)
    ld      (fd_rw+2), a
    ld      a, (fd_head)
    ld      (fd_rw+3), a
    ld      a, (fd_sector)
    ld      (fd_rw+4), a
    ld      (fd_rw+6), a
    ld      hl, fd_rw
    ld      d, 9
    call    fd_cmd
    ret     c
    ld      hl, (fd_buf)
    ld      d, 0            ; 256 bytes
    ld      a, (fd_mode)
    or      a
    jr      nz, fio_wr
; read
fio_rd: ld      e, 0
    ld      c, FDC_MSR
fr1:    in      a, (c)
    and     MSR_BYTE        ; RQM and NDM: a byte
    cp      MSR_BYTE
    jr      z, fr2
    cp      MSR_RQM         ; RQM alone: the execution is over (an error): the result says which
    jr      z, fio_early
    dec     e
    jr      nz, fr1
    ld      a, FDC_E_TIMEOUT
    jp      fd_error
fr2:    ld      c, FDC_DATA
    in      a, (c)
    ld      (hl), a
    inc     hl
    dec     d
    jr      nz, fio_rd
    jr      fio_tc
; write
fio_wr: ld      e, 0
    ld      c, FDC_MSR
fw1:    in      a, (c)
    and     MSR_BYTE
    cp      MSR_BYTE
    jr      z, fw2
    cp      MSR_RQM
    jr      z, fio_early
    dec     e
    jr      nz, fw1
    ld      a, FDC_E_TIMEOUT
    jp      fd_error
fw2:    ld      c, FDC_DATA
    ld      a, (hl)
    out     (c), a
    inc     hl
    dec     d
    jr      nz, fio_wr
fio_tc: ld      bc, FDC_TC_ON        ; terminal count: that was the last byte
    xor     a
    out     (c), a
    ld      bc, FDC_TC_OFF
    out     (c), a
    call    fio_result
    ret     c
    ld      a, (fd_rst)
    and     ST0_TERMINATION ; normal termination
    jr      z, fio_end
    ld      a, FDC_E_FDC
    jp      fd_error
fio_early:
    call    fio_result
    ld      a, FDC_E_FDC
    jp      fd_error
fio_end:
    or      a
    ret

; The seven result bytes into fd_rst
fio_result:
    ld      hl, fd_rst
    ld      d, 7
fr_lp:  call    fd_res1
    ret     c
    ld      (hl), a
    inc     hl
    dec     d
    jr      nz, fr_lp
    or      a
    ret

; (the includer's section: the variables are in RAM with the code)
fd_spec:
    defb    FDC_CMD_SPECIFY, $DF, $03 ; specify: step rate and head unload time, head load time with the non-DMA bit
fd_sis: defb    FDC_CMD_SIS             ; sense interrupt status
fd_sds: defb    FDC_CMD_SDS, 0          ; sense drive status
fd_recal_b:
    defb    FDC_CMD_RECALIBRATE, 0
fd_seek_b:
    defb    FDC_CMD_SEEK, 0, 0
fd_rw:  defb    FDC_CMD_READ, 0, 0, 0, 1, 1, 1, $1B, $FF
fd_cur: defb    $FF

fd_mode:
    defb    0
fd_unit:
    defb    0
fd_track:
    defb    0
fd_sector:
    defb    0
fd_count:
    defb    0
fd_buf: defw    0
fd_tries:
    defb    0
fd_head:
    defb    0
fd_cylw:
    defb    0
fd_st0: defb    0
fd_wait:
    defw    0
fd_err: defb    0
fd_rst: defs    7
