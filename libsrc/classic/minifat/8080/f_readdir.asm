;
; f_readdir. Outline is ChaN ff.c f_readdir (R0.16) with FF_USE_LFN 0.
; dir_read skips a deleted entry, a dot name, AM_LFN, and a volume
; label. End of directory is FR_OK and an empty name. fno == NULL
; rewinds. fno at sp+2, dp at sp+4. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

EXTERN  mf_subhlbc

PUBLIC  _f_readdir
PUBLIC  f_readdir

EXTERN  mf_ok
EXTERN  mf_err
EXTERN  mf_fill_info
EXTERN  dir_sdi
EXTERN  dir_next
EXTERN  fat_dp
EXTERN  fat_user
EXTERN  fat_mount_id
EXTERN  _cpm_fat_vol
EXTERN  dir_ptr
EXTERN  dir_ofs

; Read the next directory entry into fno, or rewind when fno is null.
; Call. The caller removes the arguments. fno is at sp+2. dp is at sp+4.
; Return. HL is FR_OK and carry is set. The end is FR_OK and an empty name.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; Clobber. AF, BC, DE, HL.
; Writes. FILINFO and dptr. A rewind stores 0 in dptr.
_f_readdir:
f_readdir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; fno at sp+2
    ld      (fat_user),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; dp at sp+4
    ld      a,d
    or      e
    jp      Z,fr_bad                        ; dp is null
    ld      (fat_dp),de
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a                             ; HL is the object id
    or      l
    jp      Z,fr_bad                        ; the object id is 0
    ld      de,(fat_mount_id)
    or      a                               ; clear carry before the subtract
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jp      NZ,fr_bad                       ; the object id is not the mount id
    ld      a,(_cpm_fat_vol)
    or      a
    jp      Z,fr_bad                        ; fs_type is 0. No volume is mounted.
    ld      hl,(fat_user)
    ld      a,h
    or      l
    jr      Z,fr_rewind
    ld      de,FI_NAME
    add     hl,de
    ld      (hl),0                          ; an empty name until a real entry is copied
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR+2
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    jp      NZ,mf_ok                        ; the high half of dptr is not 0. This is the end.
    call    fr_sdi_dptr
    jr      NC,fr_sdi_nc                    ; dir_sdi failed
; Skip a deleted entry, a dot name, a long name, and a volume label.
fr_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a
    jp      Z,mf_ok                         ; $00 ends the directory
    cp      $E5
    jr      Z,fr_skip                       ; $E5 is a deleted entry
    cp      '.'
    jr      Z,fr_skip                       ; a dot name, including ".."
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    cp      $0F
    jr      Z,fr_skip                       ; $0F is a long name
    and     $DF                             ; clear the archive bit
    cp      AM_VOL
    jr      Z,fr_skip                       ; a volume label
    ld      hl,(fat_user)
    call    mf_fill_info
    call    dir_next
    jr      C,fr_kept                       ; carry is set. Another entry follows.
    jr      Z,fr_mark                       ; xor a at dir_next_end. This is a clean end.
    ld      a,FR_DISK_ERR                   ; dir_next_io is ld a,1 then or a
    jp      mf_err
; A real entry was copied. Remember the next offset.
fr_kept:
    call    fr_store
    jp      mf_ok
; This entry does not count. Step, then look again.
fr_skip:
    call    dir_next
    jr      C,fr_more                       ; carry is set. Another entry follows.
    jr      Z,fr_end                        ; xor a at dir_next_end. This is a clean end.
    ld      a,FR_DISK_ERR                   ; dir_next_io is ld a,1 then or a
    jp      mf_err
; The skipped entry was the last one. The name is already empty.
fr_end:
    jp      mf_ok
; dir_next found another entry. Store its offset and test it.
fr_more:
    call    fr_store
    jr      fr_loop
; dir_sdi failed. Offset 0 is a drive error. Any other dptr is the end.
fr_sdi_nc:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      NZ,mf_ok                        ; dptr is not 0. Return the empty name.
    ld      a,FR_DISK_ERR
    jp      mf_err
; A real entry was the last one. The next read can return at once.
fr_mark:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR+2
    add     hl,de
    ld      (hl),1
    inc     hl
    ld      (hl),0                          ; the high half of dptr is 1
    jp      mf_ok
; fno is null. Rewind dptr and open the first entry.
fr_rewind:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a                          ; dptr is 0
    ld      hl,(fat_dp)
    ld      de,DIR_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)                          ; BCDE is the start cluster
    ld      hl,0
    call    dir_sdi
    jp      C,mf_ok                         ; the first sector is in the window
    ld      a,FR_DISK_ERR
    jp      mf_err
; dp is null, the id is 0, the id does not match, or no volume is mounted.
fr_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err

; Open the directory at the low 16 bits of dptr.
; Call. fat_dp is the DIR object. The offset is the low half of dptr.
; Return. Carry is the carry from dir_sdi.
; Clobber. AF, BC, DE, HL.
fr_sdi_dptr:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; the low half of dptr
    push    de
    ld      hl,(fat_dp)
    ld      de,DIR_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)                          ; BCDE is the start cluster
    pop     hl                              ; HL is the byte offset
    jp      dir_sdi

; Copy dir_ofs into the low half of dptr. The high half stays 0.
; Call. dir_ofs is the next offset. fat_dp is the DIR object.
; Return. The low half of dptr is dir_ofs. The high half is 0.
; Clobber. AF, DE, HL. BC stays.
; Writes. dptr in the DIR object.
fr_store:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    ld      de,(dir_ofs)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a                          ; the high half of dptr is 0
    ret
