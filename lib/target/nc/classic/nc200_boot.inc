; Boot sector/FAT table for NC200 autobootable discs
;
; Info taken from: http://cowlark.com/2017-12-04-nc200-reverse-engineering/index.html


    SECTION BOOTSTRAP
    org     0

; Sector 0: the main FAT boot sector.

    db 0xeb, 0xfe, 0x90
    db "NCBOOT "

    ; BIOS parameter block
    ds 0x00b - $
    dw 512  ; bytes per sector
    db 2    ; sectors per cluster
    dw 2    ; reserved sectors
    db 2    ; FAT count
    dw 0x70 ; number of root directory entries
    dw 108  ; filesystem size, in sectors
    db 0xf9 ; media byte
    dw 3    ; sectors per FAT
    dw 9    ; number of sectors per track
    dw 2    ; number of heads
    dw 0    ; number of hidden sectors

    ds  54 - $
    defm    "FAT12"

    ; Partition table (for Fuzix)
    ds 0x1be - $

    ; partition 0
    db 0          ; partition status (not bootable)
    db 0, 2, 0    ; encoded CHS of start
    db 0xda       ; partition type
    db 1, 8, 5    ; encoded CHS of end
    dw 1, 0       ; LBA of start
    dw 0x6a, 0    ; LBA of end

    ; partition 1
    db 0          ; partition status (not bootable)
    db 1, 9, 5    ; encoded CHS of start
    db 0x83       ; partition type
    db 1, 9, 0x4f ; encoded CHS of end
    dw 0x6b, 0    ; LBA of start
    dw 0x534, 0   ; LBA of end

    ; Boot signature
    ds 0x1fe - $
    db 0x55, 0xaa

; Sector 1: the magic numbers needed to make the disk bootable.

    ds 0x20b - $
    dw 512  ; bytes per sector
    db 2    ; sectors per cluster
    dw 0    ; reserved sectors
    db 2    ; FAT count
    dw 0x70 ; number of root directory entries
    dw 108  ; filesystem size, in sectors
    db 0xf9 ; media byte
    dw 3    ; sectors per FAT
    dw 9    ; number of sectors per track
    dw 2    ; number of heads
    dw 0    ; number of hidden sectors

; FATs.

; The FAT entries for two cylinders (four physical tracks).
; That's 18*4 = 72 sectors = 0x12 clusters. But we are offset left
; by one sector, so clusters 0 and 5 span two tracks (and are inaccessible).
; Then the pattern is repeated again for the other two tracks.


MACRO four_tracks
    db 0xf7, 0x0f, 0x00 ; clusters 0, 1
    db 0x00, 0x00, 0x00 ; clusters 2, 3
    db 0x00, 0x70, 0xff ; clusters 4, 5
    db 0x00, 0x00, 0x00 ; clusters 6, 7
    db 0x00, 0x70, 0xff ; clusters 8, 9
    db 0x00, 0x00, 0x00 ; clusters a, b
    db 0x00, 0x00, 0x00 ; clusters c, d
    db 0xf7, 0x0f, 0x00 ; clusters d, e
    db 0x00, 0x00, 0x00 ; clusters f, 10
ENDM

macro fat_definition
    db 0xf9, 0xff, 0xff
    db 0x00, 0x70, 0xff ; clusters 2, 3
    db 0x00, 0x00, 0x00 ; clusters 4, 5
    db 0x00, 0x00, 0x00 ; clusters 6, 7
    db 0xf7, 0x0f, 0x00 ; clusters 8, 9
    db 0x00, 0x00, 0x00 ; clusters a, b

    four_tracks
    four_tracks
ENDM

    ds 0x400 - ASMPC
    fat_definition

    ds 0xa00 - ASMPC
    fat_definition

    ; The root directory.

    ds 0x1000 - ASMPC
    db 0

