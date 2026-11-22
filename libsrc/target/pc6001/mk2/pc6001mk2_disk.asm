; NEC PC-6001mkII: the disc, with no ROM (it is mapped out while an all-RAM
; program runs): the PC-6031 / PC-80S31 unit, a polled handshake on the 8255 at
; $D0-$D3.
;
;   int pc6001mk2_disk_read(uint8_t track, uint8_t sector, uint8_t count, void
;   *dest) __smallc       returns 0, or $FF for an error
;   int pc6001mk2_disk_write(uint8_t track, uint8_t sector, uint8_t count, const
;   void *src) __smallc
;
; Reads or writes `count` sectors of 256 bytes from `sector` (1 to 16) of
; `track` (0 to 39, drive 0).  A call must not cross a track (count <= 17 -
; sector).  Uses all registers but IX (the C frame pointer); interrupts are the
; caller's: the timing loops want them off while the unit is read or written.
; Only for the mkII disc subtype (the ports are the mkII's, and the original
; PC-6001 has no disc code in its ROM): it is in pc6001mk2.lib, which only that
; subtype links.
;
    SECTION     code_clib
    PUBLIC      _pc6001mk2_disk_read, pc6001mk2_disk_read
    PUBLIC      _pc6001mk2_disk_write, pc6001mk2_disk_write

    defc        D_ATN_ON=$0f
    defc        D_ATN_OFF=$0e
    defc        D_DAV_ON=$09
    defc        D_DAV_OFF=$08
    defc        D_RFD_ON=$0b
    defc        D_RFD_OFF=$0a
    defc        D_DAC_ON=$0d
    defc        D_DAC_OFF=$0c

; dk_wait: wait for the port C bit mask in B to be set (c = 1 in the callers:
; dk_waitset) or clear; carry on a timeout
dk_waitset:
    ld          de, 0
dws:
    in          a, ($d2)
    and         b
    ret         nz
    dec         de
    ld          a, d
    or          e
    jr          nz, dws
    scf
    ret
dk_waitclr:
    ld          de, 0
dwc:
    in          a, ($d2)
    and         b
    ret         z
    dec         de
    ld          a, d
    or          e
    jr          nz, dwc
    scf
    ret

; dk_send: a = a byte to the unit with the handshake: wait RFD (bit 1), ATN off,
; data, DAV on, wait DAC (bit 2), DAV off, wait DAC off.  Carry on a timeout;
; keeps bc, de-free (uses de, b).
dk_send:
    push        bc
    push        af
    ld          b, 2
    call        dk_waitset
    jr          c, dks_x
    ld          a, D_ATN_OFF
    out         ($d3), a
    pop         af
    push        af
    out         ($d1), a
    ld          a, D_DAV_ON
    out         ($d3), a
    ld          b, 4
    call        dk_waitset
    jr          c, dks_x
    ld          a, D_DAV_OFF
    out         ($d3), a
    ld          b, 4
    call        dk_waitclr
; (the saved af: a is the result of the waits, carry the timeout)
dks_x:
    pop         de
    pop         bc
    ret

; dk_cmd: a = a command: ATN on, then the byte
dk_cmd:
    push        af
    ld          a, D_ATN_ON
    out         ($d3), a
    pop         af
    jr          dk_send

; dk_recv: a byte from the unit: RFD on, wait DAV (bit 0), RFD off, read, DAC
; on, wait DAV off, DAC off.  Carry on a timeout.
dk_recv:
    push        bc
    ld          a, D_RFD_ON
    out         ($d3), a
    ld          b, 1
    call        dk_waitset
    jr          c, dkr_x
    ld          a, D_RFD_OFF
    out         ($d3), a
    in          a, ($d0)
    push        af
    ld          a, D_DAC_ON
    out         ($d3), a
    ld          b, 1
    call        dk_waitclr
    jr          c, dkr_t
    ld          a, D_DAC_OFF
    out         ($d3), a
    pop         af
    or          a
    pop         bc
    ret
dkr_t:
    pop         af
dkr_x:
    pop         bc
    scf
    ret

; dk_status: command $06 and the byte: carry on a timeout, else a = the status
; (bit 6 = ok)
dk_status:
    ld          a, 6
    call        dk_cmd
    ret         c
    jr          dk_recv

; dk_start: a = the command ($01 write, $02 read), the four parameters from the
; frame at ix: count, drive 0, track, sector.  Carry on a timeout.
dk_start:
    call        dk_cmd
    ret         c
    ld          a, (ix+6)               ; count
    call        dk_send
    ret         c
    xor         a                       ; drive 1
    call        dk_send
    ret         c
    ld          a, (ix+10)              ; track
    call        dk_send
    ret         c
    ld          a, (ix+8)               ; sector
    jp          dk_send

; uint8_t pc_disk_read(track, sector, count, dest)
pc6001mk2_disk_read:
_pc6001mk2_disk_read:
    push        ix
    ld          ix, 0
    add         ix, sp
    ld          a, 2
    call        dk_start
    jr          c, dkerr
    call        dk_status
    jr          c, dkerr
    and         $40
    jr          z, dkerr
    ld          a, 3
    call        dk_cmd
    jr          c, dkerr
    ld          l, (ix+4)
    ld          h, (ix+5)
    ld          b, (ix+6)
    ld          c, 0                    ; count * 256 bytes
dkrd:
    call        dk_recv
    jr          c, dkerr
    ld          (hl), a
    inc         hl
    dec         bc
    ld          a, b
    or          c
    jr          nz, dkrd
    call        dk_status
    jr          c, dkerr
    ld          l, 0                    ; (a status with bit 0 set is an error)
    and         1
    ld          l, a
    ld          h, 0
    pop         ix
    ret

; uint8_t pc_disk_write(track, sector, count, src)
pc6001mk2_disk_write:
_pc6001mk2_disk_write:
    push        ix
    ld          ix, 0
    add         ix, sp
    ld          a, 1
    call        dk_start
    jr          c, dkerr
    ld          l, (ix+4)
    ld          h, (ix+5)
    ld          b, (ix+6)
    ld          c, 0
dkwr:
    ld          a, (hl)
    inc         hl
    call        dk_send
    jr          c, dkerr
    dec         bc
    ld          a, b
    or          c
    jr          nz, dkwr
    call        dk_status
    jr          c, dkerr
    and         1
    ld          l, a
    ld          h, 0
    pop         ix
    ret

dkerr:
    ld          hl, $ff
    pop         ix
    ret
