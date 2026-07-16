
;
; void *bsearch(...)  -- sdcc entry.  Same as bsearch.asm (sccz80) but embeds the
; sdcc comparator thunk (l_cmp_sdcc).  See qsort.asm / bsearch.asm for the design.
;

    SECTION code_clib

IF !__CPU_INTEL__ && !__CPU_GBZ80__

    PUBLIC  _bsearch

    EXTERN  asm_bsearch
    EXTERN  l_cmp_sdcc

;------------------------------------------------------------------------
; bsearch(key, base, nmemb, size, compar)  __smallc  (caller cleans args)
;   sp -> ix, ret, compar, size, nmemb, base, key
;------------------------------------------------------------------------

_bsearch:

    push    ix                          ; preserve caller's ix

    ld      hl,4
    add     hl,sp
    ld      e,(hl)                      ; de = compar
    inc     hl
    ld      d,(hl)

    push    de                          ; closure bytes 4,5 = user comparator
    ld      hl,0C300h + (l_cmp_sdcc >> 8)
    push    hl                          ; bytes 2,3 = hi(thunk), C3
    ld      hl,0C3h + ((l_cmp_sdcc & 0FFh) << 8)
    push    hl                          ; bytes 0,1 = C3, lo(thunk)

    ld      ix,0
    add     ix,sp                       ; ix -> closure

    ld      e,(ix+12)                   ; de = size
    ld      d,(ix+13)
    ld      c,(ix+16)                   ; bc = base
    ld      b,(ix+17)
    ld      l,(ix+18)                   ; hl = key
    ld      h,(ix+19)
    push    hl
    pop     af                          ; af = key for asm_bsearch's push af
    ld      l,(ix+14)                   ; hl = nmemb (loaded last)
    ld      h,(ix+15)

    call    asm_bsearch                 ; hl = result (item ptr or 0)

    pop     bc                          ; discard the 6-byte closure
    pop     bc
    pop     bc

    pop     ix                          ; restore caller's ix
    ret

ENDIF
