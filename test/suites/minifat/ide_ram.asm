; ide_read/write: HL = 512-byte buffer, BCDE = LBA (E LSB).
; Image is _ram_image, 512 * RAM_NSECT bytes in DATA.

SECTION code_compiler

PUBLIC  ide_init
PUBLIC  asm_disk_initialize
PUBLIC  ide_read_sector
PUBLIC  ide_write_sector

EXTERN  _ram_image
EXTERN  _ram_nsect

DEFC    RAM_NSECT = 64

; One LBA the BDOS extent test must not be able to write. 0 disables it.
; Cluster 34 is LBA 51; the directory drives sit at LBA 52 and 53.
SECTION bss_compiler
PUBLIC  _ram_bad_lba
_ram_bad_lba:   defb    0

SECTION code_compiler

; DE = LBA low (from E,D), *512 = <<9
lba_to_ptr:
    ld      a,b
    or      c
    jr      NZ,lba_bad
    ld      a,(_ram_bad_lba)
    or      a
    jr      Z,lba_lim
    ld      a,d
    or      a
    jr      NZ,lba_lim
    ld      a,(_ram_bad_lba)
    cp      e
    jr      Z,lba_bad
lba_lim:
    ld      a,(_ram_nsect)
    ld      c,a
    ld      a,e
    cp      c
    jr      NC,lba_bad
    ld      a,d
    or      a
    jr      NZ,lba_bad
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

ide_init:
    scf
    ret

asm_disk_initialize:
    ld      hl,0
    scf
    ret

ide_read_sector:
    push    hl                      ;dest
    call    lba_to_ptr
    pop     de
    ret     NC
    ld      bc,512
    ldir
    scf
    ret

ide_write_sector:
    push    hl                      ;src
    call    lba_to_ptr
    pop     de
    ret     NC
    ex      de,hl
    ld      bc,512
    ldir
    scf
    ret
