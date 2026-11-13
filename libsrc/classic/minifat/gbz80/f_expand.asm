;
; f_expand. Outline is ChaN ff.c f_expand (R0.16) for FAT. The search
; starts at cluster 2 and does not wrap a run. opt 0 remembers the
; start. opt 1 links a contiguous run with put_fat. opt above 1 is
; rejected. create_chain is not used. The directory entry is not
; synced here. opt at sp+2, fsz at sp+4, fp at sp+8. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

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

_f_expand:
f_expand:
    ld      hl,sp+2
    ld      a,(hl)
    ld      (fat_trail),a
    ld      hl,sp+4
    ld      de,fat_seek
    ld      bc,4
    call    mf_copy
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,fe_bad
    ld      (fat_fp),de
    call    fat_ldhl
    defw    fat_fp
    call    mf_fil_check
    ret     NC
    ld      a,(fat_trail)
    cp      2
    jr      C,fe_opt
    ld      a,FR_INVALID_PARAMETER
    jp      mf_err
fe_opt:
    ld      hl,fat_seek
    ld      a,(hl+)
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      Z,fe_deny
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_WRITE
    jp      Z,fe_deny
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SIZE
    add     hl,de
    ld      a,(hl+)
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      NZ,fe_deny
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      a,(hl+)
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      NZ,fe_deny
    call    fe_tcl
    jp      NC,fe_deny
    ld      hl,0
    call    fat_sthl
    defw    fat_cfo
    call    fat_sthl
    defw    fat_cfo+2
    ld      hl,2
    call    fat_sthl
    defw    fat_want
    ld      hl,0
    call    fat_sthl
    defw    fat_want+2
fe_loop:
    call    fe_ge
    jp      NC,fe_deny
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    call    get_fat
    jp      NC,fe_disk
    ld      a,b
    or      c
    or      d
    jr      NZ,fe_used
    ld      a,e
    or      a
    jr      Z,fe_free
    cp      1
    jp      Z,fe_int
fe_used:
    ld      hl,0
    call    fat_sthl
    defw    fat_cfo
    call    fat_sthl
    defw    fat_cfo+2
    jr      fe_adv
fe_free:
    call    fat_ldhl
    defw    fat_cfo
    ld      a,h
    or      l
    call    fat_ldhl
    defw    fat_cfo+2
    or      h
    or      l
    jr      NZ,fe_count
    call    fat_ldhl
    defw    fat_want
    call    fat_sthl
    defw    fat_hold
    call    fat_ldhl
    defw    fat_want+2
    call    fat_sthl
    defw    fat_hold+2
fe_count:
    call    fat_ldhl
    defw    fat_cfo
    inc     hl
    call    fat_sthl
    defw    fat_cfo
    ld      a,h
    or      l
    jr      NZ,fe_cmp
    call    fat_ldhl
    defw    fat_cfo+2
    inc     hl
    call    fat_sthl
    defw    fat_cfo+2
fe_cmp:
    call    fe_eq
    jr      Z,fe_found
fe_adv:
    call    fat_ldhl
    defw    fat_want
    inc     hl
    call    fat_sthl
    defw    fat_want
    ld      a,h
    or      l
    jp      NZ,fe_loop
    call    fat_ldhl
    defw    fat_want+2
    inc     hl
    call    fat_sthl
    defw    fat_want+2
    jp      fe_loop
fe_found:
    ld      a,(fat_trail)
    or      a
    jr      NZ,fe_alloc
    call    fat_ldhl
    defw    fat_hold
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
    call    fat_sthl
    defw    fat_last_clst
    ld      (fat_last_clst+2),de
    jp      mf_ok
fe_alloc:
    call    fat_ldhl
    defw    fat_hold
    call    fat_sthl
    defw    fat_want
    call    fat_ldhl
    defw    fat_hold+2
    call    fat_sthl
    defw    fat_want+2
    call    fat_ldhl
    defw    fat_remain
    call    fat_sthl
    defw    fat_cfo
    call    fat_ldhl
    defw    fat_remain+2
    call    fat_sthl
    defw    fat_cfo+2
fe_aput:
    call    fat_ldhl
    defw    fat_cfo
    ld      a,h
    or      l
    call    fat_ldhl
    defw    fat_cfo+2
    or      h
    or      l
    jp      Z,fe_afile
    ld      a,(fat_cfo)
    cp      1
    jr      NZ,fe_anext
    ld      a,(fat_cfo+1)
    or      a
    jr      NZ,fe_anext
    ld      a,(fat_cfo+2)
    or      a
    jr      NZ,fe_anext
    ld      a,(fat_cfo+3)
    or      a
    jr      NZ,fe_anext
    ld      hl,fe_eoc
    jr      fe_put
fe_anext:
    call    fat_ldhl
    defw    fat_want
    ld      de,(fat_want+2)
    inc     hl
    ld      a,h
    or      l
    jr      NZ,fe_ast
    inc     de
fe_ast:
    call    fat_sthl
    defw    fat_zeros
    ld      (fat_zeros+2),de
    ld      hl,fat_zeros
fe_put:
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    call    put_fat
    jp      NC,fe_disk
    call    fat_ldhl
    defw    fat_want
    call    fat_sthl
    defw    fat_last_clst
    call    fat_ldhl
    defw    fat_want+2
    call    fat_sthl
    defw    fat_last_clst+2
    call    fat_ldhl
    defw    fat_cfo
    ld      a,l
    sub     1
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    call    fat_sthl
    defw    fat_cfo
    jr      NC,fe_anxt
    call    fat_ldhl
    defw    fat_cfo+2
    dec     hl
    call    fat_sthl
    defw    fat_cfo+2
fe_anxt:
    call    fat_ldhl
    defw    fat_want
    inc     hl
    call    fat_sthl
    defw    fat_want
    ld      a,h
    or      l
    jp      NZ,fe_aput
    call    fat_ldhl
    defw    fat_want+2
    inc     hl
    call    fat_sthl
    defw    fat_want+2
    jp      fe_aput
fe_afile:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      de,hl
    ld      hl,fat_hold
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_CLUST
    add     hl,de
    ld      de,hl
    ld      hl,fat_hold
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,hl
    ld      hl,fat_seek
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED
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

fe_eoc:
    defb    $FF,$FF,$FF,$0F

; Cluster bytes are csize << 9. tcl is ceil(fsz / cluster bytes) in
; fat_remain. Carry set on success.
fe_tcl:
    ld      hl,fat_seek
    ld      de,fat_zeros
    ld      bc,4
    call    mf_copy
    ld      a,(_cpm_fat_vol+1)
    ld      b,9
fe_blog:
    cp      1
    jr      Z,fe_sh0
    or      a
    jr      Z,fe_tcl_no
    or      a
    rra
    inc     b
    jr      fe_blog
fe_sh0:
    xor     a
    ld      (fat_csect),a
fe_sh:
    ld      a,b
    or      a
    jr      Z,fe_ceil
    push    bc
    ld      hl,fat_zeros+3
    ld      a,(hl)
    or      a
    rra
    ld      (hl),a
    dec     hl
    ld      a,(hl)
    rra
    ld      (hl),a
    dec     hl
    ld      a,(hl)
    rra
    ld      (hl),a
    dec     hl
    ld      a,(hl)
    rra
    ld      (hl),a
    jr      NC,fe_sh_nc
    ld      a,1
    ld      (fat_csect),a
fe_sh_nc:
    pop     bc
    dec     b
    jr      fe_sh
fe_ceil:
    ld      a,(fat_csect)
    or      a
    jr      Z,fe_tcl_cp
    ld      hl,fat_zeros
    inc     (hl)
    jr      NZ,fe_tcl_cp
    inc     hl
    inc     (hl)
    jr      NZ,fe_tcl_cp
    inc     hl
    inc     (hl)
    jr      NZ,fe_tcl_cp
    inc     hl
    inc     (hl)
fe_tcl_cp:
    ld      hl,fat_zeros
    ld      a,(hl+)
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jr      Z,fe_tcl_no
    ld      hl,fat_zeros
    ld      de,fat_remain
    ld      bc,4
    call    mf_copy
    scf
    ret
fe_tcl_no:
    or      a
    ret

; Carry clear when fat_want >= n_fatent.
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

; Z when the free run length equals tcl.
fe_eq:
    ld      hl,fat_cfo
    ld      de,fat_remain
    ld      b,4
fe_eq1:
    ld      a,(de)
    cp      (hl)
    ret     NZ
    inc     hl
    inc     de
    dec     b
    jr      nz,fe_eq1
    xor     a
    ret
