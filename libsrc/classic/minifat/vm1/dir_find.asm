;
; dir_find finds an 8.3 name in the current directory.
; $00 ends the table. $E5 is a deleted entry and is skipped.
; Attribute $0F is a long name and includes the volume bit.
; A stored $05 compares as $E5. Both sides fold to A-Z.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  dir_find
PUBLIC  _dir_find

EXTERN  _cpm_fat_vol
EXTERN  dir_next
EXTERN  dir_ptr
EXTERN  dir_sclust
EXTERN  dir_sdi
EXTERN  fat_found_sclust
EXTERN  fat_found_size
EXTERN  pack_sv

; Call. A is one name byte.
; Return. A is that byte folded to A-Z.
; Return. A byte outside a-z is unchanged.
; Clobber. AF. BC, DE, and HL stay.
fat_fold:
    cp      'a'                 ;below 'a' leaves A unchanged
    ret     c                   ;A is below 'a'
    cp      'z'+1               ;above 'z' leaves A unchanged
    ret     nc                  ;A is above 'z'
    sub     32                  ;'a' to 'z' becomes 'A' to 'Z'
    ret

; Call. HL points at the 11-byte name. This is __z88dk_fastcall.
; Return. Success is L = 0 and carry set. H is 0.
; Return. A miss is L = 1, carry clear, and Z set.
; Return. A read error is L = 1, carry clear, and Z clear.
; Return. An open failure is L = 1 and carry clear.
; Return. That Z stays as dir_sdi left it. ld hl,1 does not change flags.
; Writes. On success, fat_found_sclust, fat_found_size, and dir_ptr.
; Clobber. AF, BC, DE, HL.
_dir_find:
dir_find:
    ld      (pack_sv),hl        ;keep the 11-byte name
    ld      hl,(dir_sclust+2)
    ld      bc,hl
    ld      hl,(dir_sclust)
    ex      de,hl
    ld      hl,0
    call    dir_sdi             ;rewind to the first entry
    ld      hl,1
    ret     NC                  ;the directory did not open
df_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a                   ;$00 ends the table
    jr      Z,df_miss           ;no further entry exists
    cp      $E5                 ;deleted entry
    jr      Z,df_next           ;skip a deleted slot
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    and     AM_VOL
    jr      NZ,df_next          ;volume label or long name $0F
    ld      hl,(dir_ptr)
    ex      de,hl
    ld      hl,(pack_sv)
    ld      a,(de)
    cp      $05                 ;a stored $05 means the byte $E5
    jr      NZ,df_cmp1          ;the first byte is not $05
    ld      a,$E5
df_cmp1:
    call    fat_fold            ;fold the byte on disk
    ld      c,a
    ld      a,(hl)
    call    fat_fold            ;fold the wanted byte
    cp      c                   ;compare the folded first byte
    jr      NZ,df_next          ;the first byte differs
    inc     de
    inc     hl
    ld      b,10
df_cmp:
    ld      a,(de)
    call    fat_fold            ;fold the byte on disk
    ld      c,a
    ld      a,(hl)
    call    fat_fold            ;fold the wanted byte
    cp      c                   ;compare this folded name byte
    jr      NZ,df_next          ;this name byte differs
    inc     de
    inc     hl
    dec     b
    jp      NZ,df_cmp           ;ten bytes still to match
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusLO
    add     hl,de
    ex      de,hl
    ld      hl,(de)             ;ff ld_16 DIR_FstClusLO
    ld      (fat_found_sclust),hl
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32            ;fs_type against FAT32
    ld      hl,0
    jr      NZ,df_hi            ;FAT16 cluster is 16 bits
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusHI
    add     hl,de
    ex      de,hl
    ld      hl,(de)             ;ff ld_16 DIR_FstClusHI
df_hi:
    ld      (fat_found_sclust+2),hl
    ld      hl,(dir_ptr)
    ld      de,DIR_FileSize
    add     hl,de
    ex      de,hl
    ld      hl,(de)
    ld      (fat_found_size),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (fat_found_size+2),hl
    ld      hl,0
    scf                         ;L = 0 and carry set
    ret
df_next:
    call    dir_next            ;advance to the next entry
    jr      C,df_loop           ;dir_next found another entry
    jr      NZ,df_io            ;dir_next reported a read error
df_miss:
    ld      hl,1
    xor     a                   ;L = 1, carry clear, and Z set
    ret
df_io:
    ld      hl,1
    ld      a,1
    or      a                   ;L = 1, carry clear, and Z clear
    ret
