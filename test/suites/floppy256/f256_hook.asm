; 256-byte sector hook for the floppy glue. The image is linear.
; Sector N is 256 bytes at N * 256. A = 2 does not touch the buffer.
; f256_fail counts calls that return not ready, including the wait.

    SECTION code_driver

    PUBLIC  floppy256_sector
    PUBLIC  _f256_init_unit
    PUBLIC  _f256_sp_stable
    PUBLIC  _f256_wait_keeps
    PUBLIC  _f256_quiet

    EXTERN  asm_disk_initialize
    EXTERN  floppy256_read
    EXTERN  fat_wflag
    EXTERN  fat_winsect

floppy256_sector:
    cp      2
    jr      nz, f256_io
    scf
    ret

f256_io:
    push    af
    ld      a, (_f256_fail)
    or      a
    jr      z, f256_move
    dec     a
    ld      (_f256_fail), a
    pop     af
    or      a
    ret

f256_move:
    pop     af
    push    hl                  ; buffer
    ld      l, 0
    ld      h, e                ; E * 256. The test disk fits in E.
    ld      de, _f256_image
    add     hl, de
    pop     de
    or      a
    jr      nz, f256_wr
    ld      b, 0
f256_rdlp:
    ld      a, (hl+)
    ld      (de+), a
    djnz    f256_rdlp
    scf
    ret

f256_wr:
    ld      b, 0
f256_wrlp:
    ld      a, (de+)
    ld      (hl+), a
    djnz    f256_wrlp
    scf
    ret

; L is the unit. Returns 1 when carry is set.
_f256_init_unit:
    call    asm_disk_initialize
    ld      hl, 0
    ret     nc
    ld      l, 1
    ret

; A read and an LBA that does not fit must leave SP where it was.
_f256_sp_stable:
    ld      hl, 0
    add     hl, sp
    ld      (f256_sp_save), hl
    ld      hl, f256_sp_buf
    ld      bc, 0
    ld      de, 0
    call    floppy256_read
    call    f256_sp_cmp
    ret     nz
    ld      hl, 0
    add     hl, sp
    ld      (f256_sp_save), hl
    ld      hl, f256_sp_buf
    ld      bc, $8000
    ld      de, 0
    call    floppy256_read
    call    f256_sp_cmp
    ret     nz
    ld      hl, 0
    ret

f256_sp_cmp:
    ld      hl, 2               ; this return address sits under the caller's SP
    add     hl, sp
    ld      de, (f256_sp_save)
    ld      a, l
    cp      e
    jr      nz, f256_sp_bad
    ld      a, h
    cp      d
    jr      nz, f256_sp_bad
    ld      hl, 0
    ret
f256_sp_bad:
    ld      hl, 1
    ret

; A = 2 must not write the buffer.
_f256_wait_keeps:
    ld      hl, f256_sp_buf
    ld      (hl), $3c
    ld      a, 2
    ld      bc, 0
    ld      de, 0
    call    floppy256_sector
    ld      a, (f256_sp_buf)
    cp      $3c
    ld      hl, 0
    ret     z
    ld      l, 1
    ret

_f256_quiet:
    xor     a
    ld      (fat_wflag), a
    ld      hl, 0
    ld      (fat_winsect), hl
    ld      (fat_winsect+2), hl
    ret


    SECTION bss_clib

    PUBLIC  _f256_image
    PUBLIC  _f256_fail

_f256_fail:
    defs    1

_f256_image:
    defs    4096

f256_sp_save:
    defs    2

f256_sp_buf:
    defs    512
