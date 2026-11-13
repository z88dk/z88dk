;
; f_expand finds one contiguous run of free clusters for an empty file.
; The search starts at cluster 2 and does not wrap.
; opt 0 stores the next-free hint only.
; opt 1 links that run with put_fat.
; opt above 1 returns FR_INVALID_PARAMETER.
; create_chain is not used. The directory entry is not written here.
; A full search that finds no run fails.
;
; 8085 reads a stacked argument with ld de,sp+n and ld hl,(de).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_expand
PUBLIC  f_expand

EXTERN  mf_fil_check
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  mf_copy
EXTERN  get_fat
EXTERN  put_fat
EXTERN  fat_fp
EXTERN  fat_seek
EXTERN  fat_remain
EXTERN  fat_hold
EXTERN  fat_want
EXTERN  fat_cfo
EXTERN  fat_trail
EXTERN  fat_zeros
EXTERN  fat_csect
EXTERN  fat_last_clst
EXTERN  _cpm_fat_vol

; Call. opt is a byte at sp+2 and occupies one word.
; Call. The size is a uint32 at sp+4. The file is at sp+8.
; Call. The caller removes the arguments.
; Return. HL is the FRESULT and H is 0.
; Return. FR_OK is L = 0 and carry set. An error is carry clear.
; Writes. opt 0 writes fat_last_clst only.
; Writes. opt 1 also writes the chain and the file object.
; Clobber. AF, BC, DE, HL.
_f_expand:
f_expand:
    ld      de,sp+2
    ld      a,(de)
    ld      (fat_trail),a       ;opt
    ld      de,sp+4
    ld      hl,(de)
    ld      (fat_seek),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (fat_seek+2),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      a,h
    or      l
    jp      Z,fe_bad            ;the file pointer is null
    ld      (fat_fp),hl
    call    mf_fil_check
    ret     NC                  ;the file object is not valid. HL is the FRESULT
    ld      a,(fat_trail)
    cp      2                   ;opt above 1 is rejected
    jr      C,fe_opt            ;opt is 0 or 1
    ld      a,FR_INVALID_PARAMETER ;FRESULT 19
    jp      mf_err
fe_opt:
    ld      hl,fat_seek
    ld      a,(hl+)
    or      (hl+)
    or      (hl+)
    or      (hl)
    jp      Z,fe_deny           ;a size of 0 is refused
    ld      hl,(fat_fp)
    ld      de,hl+FIL_FLAG
    ex      de,hl
    ld      a,(hl)
    and     FA_WRITE
    jp      Z,fe_deny           ;the file is not open for write
    ld      hl,(fat_fp)
    ld      de,hl+FIL_SIZE
    ex      de,hl
    ld      a,(hl+)
    or      (hl+)
    or      (hl+)
    or      (hl)
    jp      NZ,fe_deny          ;the file is not empty
    ld      hl,(fat_fp)
    ld      de,hl+FIL_SCLUST
    ex      de,hl
    ld      a,(hl+)
    or      (hl+)
    or      (hl+)
    or      (hl)
    jp      NZ,fe_deny          ;the file already has a chain
    call    fe_tcl
    jp      NC,fe_deny          ;the cluster count is 0
    ld      hl,0
    ld      (fat_cfo),hl        ;the free run length
    ld      (fat_cfo+2),hl
    ld      hl,2                ;the search starts at cluster 2
    ld      (fat_want),hl
    ld      hl,0
    ld      (fat_want+2),hl
fe_loop:
    call    fe_ge
    jp      NC,fe_deny          ;The search does not wrap. No run was found.
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    call    get_fat
    jp      NC,fe_disk          ;the FAT entry was not read
    ld      a,b
    or      c
    or      d
    jr      NZ,fe_used          ;a non-zero high byte means the cluster is in use
    ld      a,e
    or      a
    jr      Z,fe_free           ;a link of 0 is a free cluster
    cp      1
    jp      Z,fe_int            ;a link of 1 is an internal error
fe_used:
    ld      hl,0
    ld      (fat_cfo),hl        ;a used cluster breaks the run
    ld      (fat_cfo+2),hl
    jr      fe_adv
fe_free:
    ld      hl,(fat_cfo)
    ld      a,h
    or      l
    ld      hl,(fat_cfo+2)
    or      h
    or      l
    jr      NZ,fe_count         ;the run already has a start
    ld      hl,(fat_want)
    ld      (fat_hold),hl       ;remember the first free cluster
    ld      hl,(fat_want+2)
    ld      (fat_hold+2),hl
fe_count:
    ld      hl,(fat_cfo)
    inc     hl
    ld      (fat_cfo),hl
    ld      a,h
    or      l
    jr      NZ,fe_cmp           ;the run length low word did not wrap
    ld      hl,(fat_cfo+2)
    inc     hl
    ld      (fat_cfo+2),hl
fe_cmp:
    call    fe_eq
    jr      Z,fe_found          ;the run length equals the cluster count
fe_adv:
    ld      hl,(fat_want)
    inc     hl
    ld      (fat_want),hl
    ld      a,h
    or      l
    jp      NZ,fe_loop          ;the cursor low word did not wrap
    ld      hl,(fat_want+2)
    inc     hl
    ld      (fat_want+2),hl
    jp      fe_loop
fe_found:
    ld      a,(fat_trail)
    or      a
    jr      NZ,fe_alloc         ;opt 1 links the run
    ld      hl,(fat_hold)
    ld      de,(fat_hold+2)
    ld      a,l
    sub     1
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    ld      a,e
    sbc     a,0
    ld      e,a
    ld      a,d
    sbc     a,0
    ld      d,a
    ld      (fat_last_clst),hl  ;opt 0 writes this hint and nothing else
    ld      (fat_last_clst+2),de
    jp      mf_ok
; opt 1 links a contiguous run with put_fat. create_chain is not used.
fe_alloc:
    ld      hl,(fat_hold)
    ld      (fat_want),hl       ;the first cluster of the run
    ld      hl,(fat_hold+2)
    ld      (fat_want+2),hl
    ld      hl,(fat_remain)
    ld      (fat_cfo),hl        ;clusters still to link
    ld      hl,(fat_remain+2)
    ld      (fat_cfo+2),hl
fe_aput:
    ld      hl,(fat_cfo)
    ld      a,h
    or      l
    ld      hl,(fat_cfo+2)
    or      h
    or      l
    jr      Z,fe_afile          ;every cluster in the run is linked
    ld      a,(fat_cfo)
    cp      1                   ;one cluster left takes the end mark
    jr      NZ,fe_anext         ;more than one cluster remains
    ld      a,(fat_cfo+1)
    or      a
    jr      NZ,fe_anext         ;more than one cluster remains
    ld      a,(fat_cfo+2)
    or      a
    jr      NZ,fe_anext         ;more than one cluster remains
    ld      a,(fat_cfo+3)
    or      a
    jr      NZ,fe_anext         ;more than one cluster remains
    ld      hl,fe_eoc           ;the last link is $0FFFFFFF
    jr      fe_put
fe_anext:
    ld      hl,(fat_want)
    ld      de,(fat_want+2)
    inc     hl                  ;the next cluster in the run
    ld      a,h
    or      l
    jr      NZ,fe_ast           ;the next cluster low word did not wrap
    inc     de
fe_ast:
    ld      (fat_zeros),hl
    ld      (fat_zeros+2),de
    ld      hl,fat_zeros
fe_put:
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    call    put_fat             ;store the link. create_chain is not used
    jp      NC,fe_disk          ;the FAT entry was not written
    ld      hl,(fat_want)
    ld      (fat_last_clst),hl  ;the last linked cluster becomes the hint
    ld      hl,(fat_want+2)
    ld      (fat_last_clst+2),hl
    ld      hl,(fat_cfo)
    ld      a,l
    sub     1
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    ld      (fat_cfo),hl
    jr      NC,fe_anxt          ;the count low word did not borrow
    ld      hl,(fat_cfo+2)
    dec     hl
    ld      (fat_cfo+2),hl
fe_anxt:
    ld      hl,(fat_want)
    inc     hl
    ld      (fat_want),hl
    ld      a,h
    or      l
    jp      NZ,fe_aput          ;the cursor low word did not wrap
    ld      hl,(fat_want+2)
    inc     hl
    ld      (fat_want+2),hl
    jp      fe_aput
fe_afile:
    ld      hl,(fat_fp)
    ld      de,hl+FIL_SCLUST
    ld      hl,fat_hold
    ld      bc,4
    call    mf_copy
    ld      hl,(fat_fp)
    ld      de,hl+FIL_CLUST
    ld      hl,fat_hold
    ld      bc,4
    call    mf_copy
    ld      hl,(fat_fp)
    ld      de,hl+FIL_SIZE
    ld      hl,fat_seek
    ld      bc,4
    call    mf_copy
    ld      hl,(fat_fp)
    ld      de,hl+FIL_FLAG
    ex      de,hl
    ld      a,(hl)
    or      FA_MODIFIED         ;opt 1 marks the file modified
    ld      (hl),a
    jp      mf_ok
fe_deny:
    ld      a,FR_DENIED
    jp      mf_err
fe_int:
    ld      a,FR_INT_ERR
    jp      mf_err
fe_disk:
    ld      a,FR_DISK_ERR
    jp      mf_err
fe_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err

; End-of-chain value $0FFFFFFF.
fe_eoc:
    defb    $FF,$FF,$FF,$0F

; Call. fat_seek is the requested size. csize is 2^n.
; Return. Carry set means fat_remain is the cluster count.
; Return. Carry clear means the count is 0 or csize is 0.
; Clobber. AF, BC, DE, HL.
; Writes. fat_remain on success.
fe_tcl:
    ld      hl,fat_seek
    ld      de,fat_zeros
    ld      bc,4
    call    mf_copy
    ld      a,(_cpm_fat_vol+1)  ;csize is 2^n
    ld      b,9                 ;a sector is 512 bytes, so start at shift 9
fe_blog:
    cp      1
    jr      Z,fe_sh0            ;One csize bit remains. The shift count is ready.
    or      a
    jr      Z,fe_tcl_no         ;csize is 0
    or      a
    rra
    inc     b
    jr      fe_blog
fe_sh0:
    xor     a
    ld      (fat_csect),a       ;no remainder bit yet
fe_sh:
    ld      a,b
    or      a
    jr      Z,fe_ceil           ;the size has been shifted by the cluster
    push    bc
    ld      hl,fat_zeros+3
    ld      a,(hl)
    or      a
    rra
    ld      (hl-),a
    ld      a,(hl)
    rra
    ld      (hl-),a
    ld      a,(hl)
    rra
    ld      (hl-),a
    ld      a,(hl)
    rra
    ld      (hl),a
    jr      NC,fe_sh_nc         ;the bit that left was 0
    ld      a,1
    ld      (fat_csect),a       ;a 1 fell off, so round the count up
fe_sh_nc:
    pop     bc
    dec     b
    jr      fe_sh
fe_ceil:
    ld      a,(fat_csect)
    or      a
    jr      Z,fe_tcl_cp         ;the size was an exact cluster count
    ld      hl,fat_zeros
    inc     (hl)
    jr      NZ,fe_tcl_cp        ;the low byte did not wrap
    inc     hl
    inc     (hl)
    jr      NZ,fe_tcl_cp        ;this byte did not wrap
    inc     hl
    inc     (hl)
    jr      NZ,fe_tcl_cp        ;this byte did not wrap
    inc     hl
    inc     (hl)
fe_tcl_cp:
    ld      hl,fat_zeros
    ld      a,(hl+)
    or      (hl+)
    or      (hl+)
    or      (hl)
    jr      Z,fe_tcl_no         ;the cluster count is 0
    ld      hl,fat_zeros
    ld      de,fat_remain
    ld      bc,4
    call    mf_copy
    scf                         ;Carry set. fat_remain holds the count.
    ret
fe_tcl_no:
    or      a                   ;carry clear
    ret

; Call. fat_want is the cluster under test.
; Return. Carry clear means fat_want is at or above n_fatent.
; Return. Carry set means fat_want is still inside the FAT.
; Clobber. AF, DE, HL. BC stays.
fe_ge:
    ld      hl,_cpm_fat_vol+4
    ld      de,fat_want
    ld      a,(de)
    sub     (hl)
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    ret

; Call. fat_cfo is the run length. fat_remain is the cluster count.
; Return. Z means the run length equals that count.
; Clobber. AF, B, DE, HL. C stays.
fe_eq:
    ld      hl,fat_cfo
    ld      de,fat_remain
    ld      b,4                 ;four bytes of the cluster count
fe_eq1:
    ld      a,(de)
    cp      (hl)
    ret     NZ                  ;this byte differs
    inc     hl
    inc     de
    dec     b
    jr      nz,fe_eq1
    xor     a                   ;all four bytes matched. Z is set
    ret
