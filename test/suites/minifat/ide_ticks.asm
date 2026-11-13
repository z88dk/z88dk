; ticks hook_io device 0. ED FE is the hook on z80, 8080, 8085, gbz80, and vm1.
; The hook clears carry on success. This layer sets carry and adds 512 to HL.
; LBA in the hook is BCHL with L the least significant byte.

SECTION code_compiler

PUBLIC asm_disk_initialize
PUBLIC ide_read_sector
PUBLIC ide_write_sector
PUBLIC ide_init
PUBLIC _ticks_put_sector

ticks_ide:
    defb    $ed, $fe
    ccf
    ret

asm_disk_initialize:
ide_init:
    ld      a,40                ;CMD_IDE_SELECT, unit in L
    ld      l,0
    call    ticks_ide
    ld      hl,0                ;ld hl,nn does not touch flags
    ret

ide_read_sector:
    ld      a,42                ;CMD_IDE_READ
    jr      ide_xfer
ide_write_sector:
    ld      a,43                ;CMD_IDE_WRITE
ide_xfer:
    push    hl                  ;buffer
    ld      h,d                 ;H = LBA byte 1, L = byte 0
    ld      l,e                 ;BC is already LBA bytes 3 and 2
    pop     de
    push    de
    call    ticks_ide
    pop     hl
    ret     nc
    ld      de,512
    add     hl,de
    scf
    ret

; C __smallc, caller pops. uint8_t *buf at sp+2, uint32 lba at sp+4
; (low word closer to SP). L = 0 on success. add hl,sp is legal on
; z80, 8080, 8085, gbz80, and vm1.
_ticks_put_sector:
    ld      hl,2
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
    call    ide_write_sector
    ld      hl,0
    ret     c
    ld      l,1
    ret
