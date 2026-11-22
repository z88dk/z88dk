; Casio FP-1100: the floppy disk, with no ROM and no interrupts: a polled uPD765A.
;
;   int fp1100_disk_read(uint8_t unit, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
;   int fp1100_disk_write(uint8_t unit, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
;   asm_fp1100_disk_rw   the same in registers: a = 0 read, 1 write;  e = unit, d = track, c = sector, b = count, hl = buffer
;
; Reads or writes `count` (1 to 255) sectors of 256 bytes from `sector` (1 to 16) of `track`, carrying on to the next track after sector 16.  The
; disk image format is z88dk's fp1100 one: track = 2 * cylinder + side, 16 sectors a track, interleaved 1, 9, 2, 10, ...  Returns 0 or an error:
; 1 the pack is not there, 2 not ready, 3 the seek failed, 4 the controller refused or said no, 5 timed out.  Uses all registers but IX and IY.
; Interrupts are the caller's (the routines do not use any); the ROM is not used, so it works with the machine all RAM.
;
; The controller is on an expansion pack.  A slot is chosen with two ports ($FFA0: bit 0 the slot group, bit 1 keeps the RAM mapped; $FF00: the slot
; in the group), and reading $FF00 then gives the device code, 4 for the FDC pack.  The pack's ports are the low three bits of the address (the
; pack ignores addresses of $FF00 and up, so B must be 0 on every I/O):  0 (write) motor on;  2 (write) terminal count pulse;  4 (read) the main
; status register;  5 the data register (the pack's DMA data port is 6; this uses the non-DMA one).
;
; The controller is put in non-DMA mode (Specify), so a byte is moved when the main status register's RQM and NDM bits say so.  A sector takes 32 us
; a byte (250 kbit/s, MFM); the loops move one in about 26 us at 4 MHz.  A read or write is ended by the terminal count pulse after the last byte, so
; the controller does not go on to the next sector.  The variables are in the code's section: the machine is all RAM.

        SECTION code_clib
        PUBLIC  asm_fp1100_disk_rw
        PUBLIC  fp1100_disk_read, _fp1100_disk_read
        PUBLIC  fp1100_disk_write, _fp1100_disk_write

; the C entries (__smallc: the last argument is at sp+2)
fp1100_disk_write:
_fp1100_disk_write:
        ld      a,1
        jr      fd_c
fp1100_disk_read:
_fp1100_disk_read:
        xor     a
fd_c:   ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        push    de                      ; the buffer
        ld      b,(hl)                  ; count
        inc     hl
        inc     hl
        ld      c,(hl)                  ; sector
        inc     hl
        inc     hl
        ld      d,(hl)                  ; track
        inc     hl
        inc     hl
        ld      e,(hl)                  ; unit
        pop     hl
        jp      fd_regs

        defc    asm_fp1100_disk_rw = fd_regs

        INCLUDE "target/fp1100/classic/fp1100_disk.inc"
