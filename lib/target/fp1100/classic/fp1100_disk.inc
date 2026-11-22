; The Casio FP-1100's polled floppy driver (uPD765A), shared source: z88dk's library (libsrc/target/fp1100/disk/fp1100_disk.asm: fp1100_disk_read/write for programs) and the bootstrap's RAM
; loader (lib/target/fp1100/classic/bootstrap.asm) include it, so the loader has its own copy.  The labels are all local (the includer exports what it wants); entry: fd_regs.
;   fd_regs  a = 0 read, 1 write;  e = unit (0 to 3), d = track, c = sector (1 to 16), b = count (1 to 255), hl = buffer.  Exit: hl = 0 or the error (1 to 5).  Uses all registers but IX and IY.
; The variables are in the code's section: the machine is all RAM.

        defc    CPUSEL = $FFA0
        defc    IOSEL = $FF00
        defc    P_MOTOR = 0
        defc    P_TC = 2
        defc    P_MSR = 4
        defc    P_DATA = 5
        defc    TRIES = 3
        defc    SPINUP = $3000          ; turns of the ready check before giving up on the drive

        defc    E_NOPACK = 1
        defc    E_NOTREADY = 2
        defc    E_SEEK = 3
        defc    E_FDC = 4
        defc    E_TIMEOUT = 5

; Carry set and the error code in fd_err
fd_error:
        ld      (fd_err),a
        scf
        ret

fd_regs:
        ld      (fd_mode),a
        ld      a,e
        ld      (fd_unit),a
        ld      a,d
        ld      (fd_track),a
        ld      a,c
        ld      (fd_sector),a
        ld      a,b
        ld      (fd_count),a
        ld      (fd_buf),hl
        call    fd_select
        jr      c,fd_ret_err
        ld      bc,P_MOTOR
        xor     a
        out     (c),a
        ld      hl,fd_spec
        ld      d,3
        call    fd_cmd
        jr      c,fd_ret_err
fd_next:
        ld      a,(fd_count)
        or      a
        jr      z,fd_ok
        ld      a,TRIES
        ld      (fd_tries),a
fd_again:
        call    fd_sector_io
        jr      nc,fd_done
        ld      a,(fd_tries)
        dec     a
        ld      (fd_tries),a
        jr      z,fd_ret_err
        ld      a,$FF
        ld      (fd_cur),a              ; (the heads are found again before another try)
        jr      fd_again
fd_done:
        ld      hl,(fd_buf)
        inc     h
        ld      (fd_buf),hl
        ld      hl,fd_count
        dec     (hl)
        ld      a,(fd_sector)
        inc     a
        cp      17
        jr      c,fd_sec
        ld      hl,fd_track
        inc     (hl)
        ld      a,1
fd_sec: ld      (fd_sector),a
        jr      fd_next
fd_ok:  ld      hl,0
        ret
fd_ret_err:
        ld      a,(fd_err)
        ld      l,a
        ld      h,0
        ret

; Choose the FDC pack: carry set if there is none.
fd_select:
        ld      d,0
fs_lp:  ld      e,2
        ld      a,d
        cp      4
        jr      c,fs_g
        inc     e
fs_g:   ld      bc,CPUSEL
        out     (c),e
        and     3
        ld      bc,IOSEL
        out     (c),a
        in      a,(c)
        cp      4
        jr      z,fs_found
        inc     d
        ld      a,d
        cp      8
        jr      nz,fs_lp
        ld      a,E_NOPACK
        jp      fd_error
fs_found:
        or      a
        ret

; The main status register once RQM is set: a = it.  Carry set on a timeout.  (The timeout counts in the alternate registers, so the callers' own are kept.)
fd_rqm:
        exx
        ld      de,0
        exx
        ld      bc,P_MSR
fq1:    in      a,(c)
        bit     7,a
        jr      nz,fq_ok
        exx
        dec     de
        ld      a,d
        or      e
        exx
        jr      nz,fq1
        ld      a,E_TIMEOUT
        jp      fd_error
fq_ok:  or      a
        ret

; A command: hl = its bytes, d = how many.  Carry set on an error.
fd_cmd:
        ld      bc,P_MSR
        ld      e,0
fcb:    in      a,(c)
        and     $10                     ; (a command still running)
        jr      z,fcl
        dec     e
        jr      nz,fcb
        ld      a,E_TIMEOUT
        jp      fd_error
fcl:    call    fd_rqm
        ret     c
        bit     6,a                     ; the direction must be to the controller
        jr      nz,fd_bad
        ld      a,(hl)
        inc     hl
        ld      c,P_DATA
        out     (c),a
        dec     d
        jr      nz,fcl
        or      a
        ret
fd_bad: ld      a,E_FDC
        jp      fd_error

; One result byte: a = it.  Carry set on an error.
fd_res1:
        call    fd_rqm
        ret     c
        bit     6,a                     ; the direction must be to the CPU
        jr      z,fd_bad
        ld      c,P_DATA
        in      a,(c)
        or      a
        ret

; Wait for a seek or recalibrate to end and sense it: carry set if it did not end well.
fd_seekend:
        ld      bc,P_MSR
        ld      de,0
fse1:   in      a,(c)
        and     $0F                     ; (a drive still seeking)
        jr      z,fse2
        dec     de
        ld      a,d
        or      e
        jr      nz,fse1
        ld      a,E_TIMEOUT
        jp      fd_error
fse2:   ld      hl,fd_sis
        ld      d,1
        call    fd_cmd
        ret     c
        call    fd_res1                 ; st0
        ret     c
        ld      (fd_st0),a
        call    fd_res1                 ; the cylinder it reached
        ret     c
        ld      a,(fd_st0)
        and     $E0                     ; the seek end bit, without the abnormal or invalid command bits
        cp      $20
        jr      z,fse3
        ld      a,E_SEEK
        jp      fd_error
fse3:   or      a
        ret

; The drive up to speed: carry set if it never is.
fd_ready:
        ld      hl,SPINUP
        ld      (fd_wait),hl
frd:    ld      a,(fd_unit)
        ld      (fd_sds + 1),a
        ld      hl,fd_sds
        ld      d,2
        call    fd_cmd
        ret     c
        call    fd_res1                 ; st3
        ret     c
        bit     5,a                     ; ready
        jr      nz,frd_ok
        ld      hl,(fd_wait)
        dec     hl
        ld      (fd_wait),hl
        ld      a,h
        or      l
        jr      nz,frd
        ld      a,E_NOTREADY
        jp      fd_error
frd_ok: or      a
        ret

; One sector: carry set on an error (and fd_err).
fd_sector_io:
        ld      a,(fd_track)
        ld      b,a
        and     1
        ld      (fd_head),a
        ld      a,b
        srl     a
        ld      (fd_cylw),a
        call    fd_ready
        ret     c
        ld      a,(fd_cur)              ; the heads: where they are, or $FF if not known
        cp      $FF
        jr      nz,fio_pos
        ld      a,(fd_unit)
        ld      (fd_recal_b + 1),a
        ld      hl,fd_recal_b
        ld      d,2
        call    fd_cmd
        ret     c
        call    fd_seekend
        ret     c
        xor     a
        ld      (fd_cur),a
fio_pos:
        ld      a,(fd_cylw)
        ld      b,a
        ld      a,(fd_cur)
        cp      b
        jr      z,fio_go
        ld      a,(fd_unit)
        ld      (fd_seek_b + 1),a
        ld      a,b
        ld      (fd_seek_b + 2),a
        ld      hl,fd_seek_b
        ld      d,3
        call    fd_cmd
        ret     c
        call    fd_seekend
        ret     c
        ld      a,(fd_cylw)
        ld      (fd_cur),a
fio_go: ld      a,(fd_mode)             ; the command: MFM read data ($46) or MFM write data ($45), drive and head, C, H, R, N = 1 (256 bytes),
        or      a                       ; EOT = R, GPL, DTL
        ld      a,$46
        jr      z,fio_c
        ld      a,$45
fio_c:  ld      (fd_rw),a
        ld      a,(fd_head)
        add     a,a
        add     a,a
        ld      b,a
        ld      a,(fd_unit)
        or      b
        ld      (fd_rw + 1),a
        ld      a,(fd_cylw)
        ld      (fd_rw + 2),a
        ld      a,(fd_head)
        ld      (fd_rw + 3),a
        ld      a,(fd_sector)
        ld      (fd_rw + 4),a
        ld      (fd_rw + 6),a
        ld      hl,fd_rw
        ld      d,9
        call    fd_cmd
        ret     c
        ld      hl,(fd_buf)
        ld      d,0                     ; 256 bytes
        ld      a,(fd_mode)
        or      a
        jr      nz,fio_wr
; read
fio_rd: ld      e,0
        ld      c,P_MSR
fr1:    in      a,(c)
        and     $A0                     ; RQM and NDM: a byte
        cp      $A0
        jr      z,fr2
        cp      $80                     ; RQM alone: the execution is over (an error): the result says which
        jr      z,fio_early
        dec     e
        jr      nz,fr1
        ld      a,E_TIMEOUT
        jp      fd_error
fr2:    ld      c,P_DATA
        in      a,(c)
        ld      (hl),a
        inc     hl
        dec     d
        jr      nz,fio_rd
        jr      fio_tc
; write
fio_wr: ld      e,0
        ld      c,P_MSR
fw1:    in      a,(c)
        and     $A0
        cp      $A0
        jr      z,fw2
        cp      $80
        jr      z,fio_early
        dec     e
        jr      nz,fw1
        ld      a,E_TIMEOUT
        jp      fd_error
fw2:    ld      c,P_DATA
        ld      a,(hl)
        out     (c),a
        inc     hl
        dec     d
        jr      nz,fio_wr
fio_tc: ld      bc,P_TC                 ; terminal count: that was the last byte
        xor     a
        out     (c),a
        call    fio_result
        ret     c
        ld      a,(fd_rst)
        and     $C0                     ; normal termination
        jr      z,fio_end
        ld      a,E_FDC
        jp      fd_error
fio_early:
        call    fio_result
        ld      a,E_FDC
        jp      fd_error
fio_end: or     a
        ret

; The seven result bytes into fd_rst
fio_result:
        ld      hl,fd_rst
        ld      d,7
fr_lp:  call    fd_res1
        ret     c
        ld      (hl),a
        inc     hl
        dec     d
        jr      nz,fr_lp
        or      a
        ret

; (the includer's section: the variables are in RAM with the code)
fd_spec:    defb    $03, $DF, $03       ; specify: step rate and head unload time, head load time with the non-DMA bit
fd_sis:     defb    $08                 ; sense interrupt status
fd_sds:     defb    $04, 0              ; sense drive status
fd_recal_b: defb    $07, 0
fd_seek_b:  defb    $0F, 0, 0
fd_rw:      defb    $46, 0, 0, 0, 1, 1, 1, $1B, $FF
fd_cur:     defb    $FF

fd_mode:    defb    0
fd_unit:    defb    0
fd_track:   defb    0
fd_sector:  defb    0
fd_count:   defb    0
fd_buf:     defw    0
fd_tries:   defb    0
fd_head:    defb    0
fd_cylw:    defb    0
fd_st0:     defb    0
fd_wait:    defw    0
fd_err:     defb    0
fd_rst:     defs    7
