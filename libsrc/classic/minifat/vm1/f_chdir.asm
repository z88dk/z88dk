;
; f_chdir. Outline is ChaN ff.c f_chdir. A file returns FR_NO_PATH.
; Success stores the cluster in fat_cwd and the text in fat_cwd_str.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_chdir
PUBLIC  f_chdir

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_cwd_apply
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_here
EXTERN  fat_cwd

; Call. The path is at sp+2. The caller removes it.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. Success stores the cluster in fat_cwd and the text in fat_cwd_str.
_f_chdir:
f_chdir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    ret     NC                      ; the volume is not mounted. HL holds the FRESULT
    ld      hl,(fat_path)
    call    mf_follow
    jr      NC,fh_miss              ; follow failed
    ld      a,(fat_noname)
    or      a
    jr      NZ,fh_ok                ; the path names the directory itself
    ld      a,(fat_attr)
    and     AM_DIR                  ; directory attribute
    jr      NZ,fh_ok                ; the entry is a directory
    ld      a,FR_NO_PATH            ; a file returns FR_NO_PATH
    jp      mf_err
; the path names a directory
fh_ok:
    ld      hl,(fat_path)
    call    mf_cwd_apply
    ret     NC                      ; the path text was rejected. HL holds the FRESULT
    ld      hl,(fat_here)
    ld      (fat_cwd),hl            ; store the low word of the cluster
    ld      hl,(fat_here+2)
    ld      (fat_cwd+2),hl          ; store the high word of the cluster
    jp      mf_ok
; follow failed. FR_NO_FILE becomes FR_NO_PATH
fh_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err               ; keep a code other than FR_NO_FILE
    ld      a,FR_NO_PATH
    jp      mf_err
