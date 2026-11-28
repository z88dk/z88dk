;       NEC PC-8001mkII boot sector for a program that runs with the ROM switched out
;
;       The ROM's disc boot reads track 0, sector 1 to $C000 and runs it. This
;       is that sector. It moves itself to $E000, lets the RAM under the ROM be
;       written, reads the program over the ROM with the disk unit's own protocol
;       (the same one as pc8001_disk_read, the sectors from 2 on), switches the RAM
;       in and runs it. The program is built for $0000, as the tape one is, and
;       it must end below $E000.
;
;       The sector is 256 bytes: the first part runs where the ROM puts it.

    INCLUDE "target/pc8001/def/pc8001.def"

    SECTION BOOTSTRAP

    EXTERN  __DATA_END_tail

    ; The ROM's print routine, which the progress message goes through: the mkII's (PRINT_CHAR). The PC-8001mkIISR in its own mode
    ; has the same routine at $0EA4 (-pragma-define:PC8001_BOOT_PRINT=0x0EA4), and the ROM is what is mapped when this runs
IF DEFINED_PC8001_BOOT_PRINT
    defc    boot_print = PC8001_BOOT_PRINT
ELSE
    defc    boot_print = PRINT_CHAR
ENDIF

    org     $e000

bootstrap:
    di
    ld      hl, $c000
    ld      de, bootstrap
    ld      bc, 256
    ldir
    jp      entry

entry:
    ld      sp, $f000
    out     ($5f), a                    ;Main memory at $8000 - $BFFF: the ROM can leave a graphics plane there
    ld      a, EXRAM_WRITE              ;Writes go to the RAM under the ROM
    out     (EXRAM_CTL), a
    ld      hl, message                 ;Something to see: the message, then a dot for each track. The ROM prints it,
    ld      b, message_end - message    ;which knows if the screen is 40 or 80 columns (it is still there to read)
show:
    ld      a, (hl)
    inc     hl
    call    boot_print
    djnz    show
    ld      hl, 0
    ld      b, +((__DATA_END_tail - 0) / 256) + 1
    ld      de, $0002                   ;track 0, sector 2
    call    disk_load
    ld      a, EXRAM_READ|EXRAM_WRITE   ;The RAM is what is at $0000 now
    out     (EXRAM_CTL), a
    jp      $0000

; Entry: hl = address, b = sectors, c = drive, d = track, e = sector
; The unit does a track at a time, and wants to be asked how it went after each
disk_load:
    ld      a, 17
    sub     e                           ;the sectors left on the track
    cp      b
    jr      c, load_chunk
    ld      a, b
load_chunk:
    push    af
    ld      a, $02                      ;Read data
    call    sd_cmd
    pop     af
    call    sd_byte                     ;the sectors
    xor     a                           ;drive 0
    call    sd_byte
    ld      a, d
    call    sd_byte
    ld      a, e
    call    sd_byte
    ld      a, $12                      ;Fast send
    call    sd_cmd
load_sector:
    ld      c, 128                      ;128 pairs of bytes
load_pair:
    call    rd_pair
    dec     c
    jr      nz, load_pair
    inc     e
    dec     b
    jr      z, load_end                 ;all the sectors
    ld      a, e
    cp      17
    jr      nz, load_sector
    call    status
    ld      a, '.'                      ;A dot for the track that is done
    call    boot_print
    inc     d                           ;the next track
    ld      e, 1
    jr      disk_load
load_end:
    ; fall into status

message:
    defm    "z88dk PC-8001 bootstrap loading"
message_end:

; How it went (command 6), which ends the command. It is one byte, which is not looked at
status:
    ld      a, 6
    call    sd_cmd
    call    rd_first
    ld      a, %00001101                ;data accepted
    out     ($ff), a
status_drop:
    in      a, ($fe)
    rrca
    jr      c, status_drop
    jr      rd_end

; a = the first byte of what the unit has for us
rd_first:
    ld      a, %00001011                ;ready for data
    out     ($ff), a
rd_valid:
    in      a, ($fe)
    rrca
    jr      nc, rd_valid
    ld      a, %00001010
    out     ($ff), a
    in      a, ($fc)
    ret

; a = command
sd_cmd:
    push    af
    ld      a, %00001111                ;ATN
    out     ($ff), a
sd_cmd_wait:
    in      a, ($fe)
    bit     1, a                        ;ready for data?
    jr      z, sd_cmd_wait
    ld      a, %00001110
    out     ($ff), a
    jr      sd_send

; a = byte
sd_byte:
    push    af
sd_byte_wait:
    in      a, ($fe)
    bit     1, a
    jr      z, sd_byte_wait
sd_send:
    pop     af
    out     ($fd), a
    ld      a, %00001001                ;data valid
    out     ($ff), a
sd_accepted:
    in      a, ($fe)
    bit     2, a
    jr      z, sd_accepted
    ld      a, %00001000
    out     ($ff), a
sd_done:
    in      a, ($fe)
    bit     2, a
    jr      nz, sd_done
    ret

; two bytes to (hl)
rd_pair:
    call    rd_first
    ld      (hl), a
    inc     hl
    ld      a, %00001101                ;data accepted
    out     ($ff), a
rd_drop:
    in      a, ($fe)
    rrca
    jr      c, rd_drop
    in      a, ($fc)
    ld      (hl), a
    inc     hl
rd_end:
    ld      a, %00001100
    out     ($ff), a
    ret
