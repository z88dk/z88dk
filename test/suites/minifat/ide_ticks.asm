; ticks hook_io device 0. ED FE is the hook on z80, 8080, 8085, gbz80, and vm1.
; The hook clears carry on success. This layer sets carry and adds 512 to HL.
; LBA in the hook is BCHL with L the least significant byte.
; An LBA at or past _ram_nsect fails here. The host file does not shrink.

SECTION code_compiler

PUBLIC asm_disk_initialize
PUBLIC ide_read_sector
PUBLIC ide_write_sector
PUBLIC ide_init
PUBLIC _ticks_put_sector
PUBLIC _ticks_get_sector

EXTERN _disk_flush
EXTERN _ram_nsect

ticks_ide:
    defb    $ed, $fe
    ccf
    ret

asm_disk_initialize:
ide_init:
    ld      a,(_ram_nsect)
    or      a
    jr      Z,ide_absent        ;no sectors. The drive is not ready.
    ld      a,40                ;CMD_IDE_SELECT, unit in L
    ld      l,0
    call    ticks_ide
    ld      hl,0                ;ld hl,nn does not touch flags
    ret
ide_absent:
    ld      hl,0
    or      a                   ;carry clear
    ret

; Library entry. Flush the C sector cache, then transfer.
; A = 42 read or 43 write. HL = buffer. BCDE = LBA, E least significant.
ide_read_sector:
    ld      a,42                ;CMD_IDE_READ
    jr      ide_entry
ide_write_sector:
    ld      a,43                ;CMD_IDE_WRITE
ide_entry:
    push    hl
    push    de
    push    bc
    push    af
    call    _disk_flush
    pop     af
    pop     bc
    pop     de
    pop     hl

; A = command. HL = buffer. BCDE = LBA. No cache flush.
ide_go:
    push    af
    ld      a,b
    or      c
    or      d
    jr      NZ,ide_range
    ld      a,(_ram_nsect)
    cp      e
    jr      Z,ide_range
    jr      C,ide_range
    pop     af
    push    hl                  ;buffer
    ld      h,d                 ;H = LBA byte 1, L = byte 0
    ld      l,e                 ;BC is already LBA bytes 3 and 2
    pop     de
    push    de
    call    ticks_ide
    pop     hl
    ret     NC
    ld      de,512
    add     hl,de
    scf
    ret
ide_range:
    pop     af
    or      a                   ;carry clear: LBA is past the glue limit
    ret

; C __smallc, caller pops. uint8_t *buf at sp+2, uint32 lba at sp+4
; (low word closer to SP). L = 0 on success. add hl,sp is legal on
; z80, 8080, 8085, gbz80, and vm1.
_ticks_put_sector:
    ld      a,43
    jr      ticks_xfer
_ticks_get_sector:
    ld      a,42
ticks_xfer:
    push    af
    ld      hl,4
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de                  ;buffer
    inc     hl
    ld      e,(hl)              ;LBA byte 0
    inc     hl
    ld      d,(hl)              ;LBA byte 1
    inc     hl
    ld      c,(hl)              ;LBA byte 2
    inc     hl
    ld      b,(hl)              ;LBA byte 3
    pop     hl
    pop     af
    call    ide_go
    ld      hl,0
    ret     C
    ld      l,1
    ret
