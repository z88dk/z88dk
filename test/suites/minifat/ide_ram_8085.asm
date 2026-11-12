; 8085 ram-disk IDE stub. Same contract as ide_ram.asm; no ldir.

SECTION code_compiler

PUBLIC  ide_init
PUBLIC  asm_disk_initialize
PUBLIC  ide_read_sector
PUBLIC  ide_write_sector

EXTERN  _ram_image
EXTERN  _ram_nsect

; One LBA the BDOS extent test must not be able to write. 0 disables it.
; Cluster 34 is LBA 51; the directory drives sit at LBA 52 and 53.
SECTION bss_compiler
PUBLIC  _ram_bad_lba
_ram_bad_lba:   defb    0

SECTION code_compiler

lba_to_ptr:
    ld      a,b
    or      c
    jp      NZ,lba_bad
    ld      a,(_ram_bad_lba)
    or      a
    jp      Z,lba_lim
    ld      a,d
    or      a
    jp      NZ,lba_lim
    ld      a,(_ram_bad_lba)
    cp      e
    jp      Z,lba_bad
lba_lim:
    ld      a,(_ram_nsect)
    ld      c,a
    ld      a,e
    cp      c
    jp      NC,lba_bad
    ld      a,d
    or      a
    jp      NZ,lba_bad
    ld      h,e
    ld      l,0
    add     hl,hl                   ;*512
    ld      de,_ram_image
    add     hl,de
    scf
    ret
lba_bad:
    or      a
    ret

; 512 bytes HL -> DE
copy512:
    ld      b,0
copy512_lp:
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    dec     b
    jp      NZ,copy512_lp
    ret

ide_init:
    scf
    ret

asm_disk_initialize:
    ld      hl,0
    scf
    ret

ide_read_sector:
    push    hl
    call    lba_to_ptr
    pop     de
    ret     NC
    call    copy512
    scf
    ret

ide_write_sector:
    push    hl
    call    lba_to_ptr
    pop     de
    ret     NC
    ex      de,hl
    call    copy512
    scf
    ret
