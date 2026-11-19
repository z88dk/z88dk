; RC2014 firmware start under z88dk-ticks -b rc2014.
; The file is at most 32 kB and is loaded at 0, so it is the ROM.
; The ROM is on, both RAM pages are clear, and the hook traps are absent.
; The name contains rc2014. That name is the RAM-program path for a longer file.
; Code is 8080 only, so the same image runs on -mz80 and -m8085.
; Sixteen result bytes are stored at 0x8100 on RAM page 0.
; Stop with jp 0x807e. -output reads page 0. The ROM is on at the stop.
;
; 0x8100:
;   a5 a5 00        cold ROM read, ROM read after a write, page 1 at 0xF200
;   5a c3 06 f2 11  RAM under the write, cboot page zero, ROM byte 0x0101
;   c3 77           warm CCP, FAT kept by canary 0xAA55
;   00              FAT cleared after canary 0x5555, ROM on
;   00 00           page 1 at 0x0000 and at 0xF200
;   c3 c3 a5        page 0 resident after the shadow step, done

    org 0
    jp cold
    defs $0008 - $
    defb $3e                ; not the ED FE C9 hook
    defs $0100 - $
    defb $a5                ; ROM signature at 0x0100
    defb $11                ; ROM byte that cboot must not change
    defb $c3                ; stored CCP byte

cold:
    ld a, ($0100)
    ld ($8100), a           ; a5, a read below 0x8000 matches the ROM
    ld a, $5a
    ld ($0100), a           ; write-through into page 0
    ld a, ($0100)
    ld ($8101), a           ; a5, the ROM byte is unchanged
    ld a, 1
    out ($30), a            ; page 1. Fetches stay in the ROM.
    ld a, ($f200)
    ld ($8102), a           ; 00, page 1 is clear
    xor a
    out ($30), a

    ld a, ($0102)
    ld ($e9e0), a           ; CCP
    ld a, $c3
    ld ($f206), a           ; stub
    ld a, $fb
    ld ($fb00), a           ; BIOS table
    ld a, $77
    ld ($f7d0), a           ; FAT block
    ld hl, $aa55
    ld ($fafe), hl          ; canary under the BIOS

    ld hl, cboot_stub
    ld de, $9000
    ld bc, cboot_end - cboot_stub
    call copy
    jp $9000

after_cboot:
    xor a
    ld ($e9e0), a           ; smash the CCP. Warm boot copies it back.
    ld hl, warm_stub
    ld de, $9000
    ld bc, warm_end - warm_stub
    call copy
    jp $9000

after_warm:
    ld hl, exit_stub
    ld de, $9000
    ld bc, exit_end - exit_stub
    call copy
    jp $9000

after_exit:
    ld hl, sh_stub
    ld de, $9100
    ld bc, sh_end - sh_stub
    call copy
    ld a, 1
    out ($30), a            ; plant the same stub on page 1
    ld hl, sh_stub
    ld de, $9100
    ld bc, sh_end - sh_stub
    call copy
    xor a
    out ($30), a
    jp $9100

; Copy BC bytes from HL to DE. Straight 8080. SP starts at 0, so the
; return address sits at the top of page 0, above the FAT block.
copy:
    ld a, b
    or c
    ret z
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    dec bc
    jp copy

; Stubs are assembled in the ROM and copied to 0x9000 or 0x9100.
; Every operand is absolute, so the copy runs at the new address.
; Each stub ends with jp back to the ROM, or with jp 0x807e.

cboot_stub:
    ld a, 1
    out ($38), a            ; window is RAM
    ld a, ($0100)
    ld ($8103), a           ; 5a, the write landed in page 0
    ld a, $c3
    ld ($0000), a
    ld ($0005), a
    ld hl, $f200
    ld ($0001), hl
    ld hl, $f206
    ld ($0006), hl
    ld a, ($0000)
    ld ($8104), a           ; c3
    ld a, ($0006)
    ld ($8105), a           ; 06
    ld a, ($0007)
    ld ($8106), a           ; f2
    xor a
    out ($38), a            ; ROM on again
    ld a, ($0101)
    ld ($8107), a           ; 11, the ROM byte
    jp after_cboot
cboot_end:

warm_stub:
    xor a
    out ($38), a            ; ROM on. The copy reads the ROM.
    ld a, ($0102)
    ld ($e9e0), a
    ld a, 1
    out ($38), a            ; window is RAM for the compare
    ld a, ($e9e0)
    ld ($8108), a           ; c3, CCP matches the stored byte
    xor a
    out ($38), a            ; ROM on before any jp into the low image
    ld hl, ($fafe)
    ld a, l
    cp $55
    jp nz, after_warm
    ld a, h
    cp $aa
    jp nz, after_warm
    ld a, ($f7d0)
    ld ($8109), a           ; 77, canary 0xAA55 keeps the FAT block
    jp after_warm
warm_end:

exit_stub:
    ld hl, $5555
    ld ($fafe), hl
    xor a
    out ($38), a            ; shell, ROM in the window
    ld hl, ($fafe)
    ld a, l
    cp $55
    jp nz, after_exit
    ld a, h
    cp $55
    jp nz, after_exit
    xor a
    ld ($f7d0), a
    ld a, ($f7d0)
    ld ($810a), a           ; 00
    jp after_exit
exit_end:

; Copied to 0x9100 on both pages before the out to port 0x30.
sh_stub:
    ld a, 1
    out ($38), a            ; ROM off, so 0x0000 is RAM
    ld a, 1
    out ($30), a            ; page 1. The next byte is on page 1.
    ld a, ($0000)
    ld b, a                 ; 00
    ld a, ($f200)
    ld c, a                 ; 00
    xor a
    out ($30), a            ; page 0. The next byte is on page 0.
    ld a, b
    ld ($810b), a
    ld a, c
    ld ($810c), a
    ld a, ($f206)
    ld ($810d), a           ; c3, the resident stub is back
    ld a, ($e9e0)
    ld ($810e), a           ; c3
    ld a, $a5
    ld ($810f), a
    jp $807e
sh_end:

    ASSERT ($ < $8000)
    ASSERT (sh_end - sh_stub < $100)
    ASSERT (cboot_end - cboot_stub < $100)
