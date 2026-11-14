;
; f_lseek seeks to a byte offset in an open file.
; A read clips at the file size. A write extends the chain.
; A seek at or past the file size returns FR_OK at the size reached.
; The 512-byte offset path is the partial sector.
; A cluster-aligned end uses the byte before that offset.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

EXTERN  mf_subhlbc

PUBLIC  _f_lseek
PUBLIC  f_lseek

EXTERN  mf_fil_check
EXTERN  mf_place
EXTERN  mf_sector_for_fptr
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  mf_copy
EXTERN  fat_fp
EXTERN  fat_seek
EXTERN  fat_hold
EXTERN  fat_write
EXTERN  fat_off

; Call. The offset low word is at sp+2. The high word is at sp+4.
; Call. The file is at sp+6. The caller removes the arguments.
; Return. HL is the FRESULT and H is 0.
; Return. FR_OK is L = 0 and carry set. An error is carry clear.
; Writes. The file pointer. An extend also stores the size.
; Clobber. AF, BC, DE, HL.
_f_lseek:
f_lseek:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_seek),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_seek+2),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_fp),de
    ex      de,hl
    call    mf_fil_check
    ret     NC                  ;the file object is not valid. HL is the FRESULT
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_WRITE
    jr      Z,fl_clip           ;read mode clips at the file size
    call    fl_past
    jr      NC,fl_set           ;the seek is not past the file size
    jr      fl_ext
fl_clip:
    call    fl_past
    jr      NC,fl_set           ;the seek is inside the file
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_seek
    ld      bc,4
    call    mf_copy
fl_set:
    ld      hl,fat_seek
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_FPTR
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    jp      mf_place            ;place the cluster for the offset now in fat_seek
fl_ext:
    ld      a,1
    ld      (fat_write),a
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    call    mf_copy
    ld      hl,fat_hold
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_FPTR
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
fl_loop:
    call    fl_before
    jp      NC,mf_place         ;the pointer has reached the offset
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    ld      (fat_off),a
    inc     hl
    ld      a,(hl)
    and     1                   ;the low 9 bits are the offset in the sector
    ld      (fat_off+1),a
    ld      hl,(fat_off)
    ld      de,512              ;one sector is 512 bytes
    or      a
    ex      de,hl
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    ld      (fat_hold),hl
    call    fl_gap
    ld      a,(fat_off)
    ld      hl,fat_off+1
    or      (hl)
    jr      NZ,fl_step          ;the offset is inside the sector
    call    mf_sector_for_fptr
    jr      C,fl_step           ;the next sector is ready
    ld      a,h
    or      l
    jp      Z,mf_place          ;the disk is full. FR_OK at the size reached
    jp      mf_err              ;HL is a disk or chain FRESULT
fl_step:
    ld      bc,(fat_hold)
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    add     a,c
    ld      (hl+),a
    ld      a,(hl)
    adc     a,b
    ld      (hl+),a
    ld      a,(hl)
    adc     a,0
    ld      (hl+),a
    ld      a,(hl)
    adc     a,0
    ld      (hl),a
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SIZE
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED         ;the extend changed the file
    ld      (hl),a
    jr      fl_loop

; Call. fat_fp and fat_seek are set.
; Return. Carry set means fat_seek is above the file size.
; Return. Carry clear means fat_seek is at or below the file size.
; Clobber. AF, C, DE, HL. B stays.
fl_past:
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_seek
    or      a
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sub     c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    ret

; Call. fat_fp and fat_seek are set.
; Return. Carry set means the file pointer is below fat_seek.
; Return. Carry clear means the pointer is at or above fat_seek.
; Clobber. AF, C, DE, HL. B stays.
fl_before:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,fat_seek
    or      a
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sub     c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    ret

; Call. fat_hold is the bytes left in this sector.
; Call. The file pointer is below fat_seek.
; Return. fat_hold becomes the smaller of that remainder and the gap.
; Clobber. AF, BC, DE, HL.
fl_gap:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,fat_seek
    or      a
    ld      a,(de)
    sub     (hl)
    ld      c,a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    ld      b,a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    push    af
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    pop     de                  ;D is the third byte. E is the flags
    or      d
    ret     NZ                  ;the gap is at least 65536 bytes
    ld      hl,(fat_hold)
    or      a
    call    mf_subhlbc
    ret     C                   ;fat_hold is already the smaller count
    ret     Z                   ;fat_hold equals the gap
    ld      (fat_hold),bc       ;the gap is smaller than fat_hold
    ret
