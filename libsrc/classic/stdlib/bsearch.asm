
;
; void *bsearch(const void *key, const void *base, size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))
;
; sccz80 entry.  Same closure design as qsort (see qsort.asm): build a 6-byte
; comparator closure on the stack, pass its address in ix, and let the shared
; newlib asm_bsearch core reach it via l_jpix.  The comparator thunk
; (l_cmp_sccz80) is shared with qsort.
;

    SECTION code_clib

IF !__CPU_INTEL__ && !__CPU_GBZ80__

    PUBLIC  bsearch

    EXTERN  asm_bsearch
    EXTERN  l_cmp_sccz80

;------------------------------------------------------------------------
; bsearch(key, base, nmemb, size, compar)  __smallc  (caller cleans args)
;
;   sp -> ix, ret, compar, size, nmemb, base, key   (after preserving caller ix)
;------------------------------------------------------------------------

bsearch:

    push    ix                          ; preserve caller's ix

    ld      hl,4
    add     hl,sp
    ld      e,(hl)                      ; de = compar
    inc     hl
    ld      d,(hl)

    push    de                          ; closure bytes 4,5 = user comparator
    ld      hl,0C300h + (l_cmp_sccz80 >> 8)
    push    hl                          ; bytes 2,3 = hi(thunk), C3
    ld      hl,0C3h + ((l_cmp_sccz80 & 0FFh) << 8)
    push    hl                          ; bytes 0,1 = C3, lo(thunk)

    ld      ix,0
    add     ix,sp                       ; ix -> closure

    ; asm_bsearch wants: hl = nmemb, de = size, bc = base, af = key, ix = closure
    ; args above the 6-byte closure: compar@+10 size@+12 nmemb@+14 base@+16 key@+18

    ld      e,(ix+12)                   ; de = size
    ld      d,(ix+13)
    ld      c,(ix+16)                   ; bc = base
    ld      b,(ix+17)
    ld      l,(ix+18)                   ; hl = key
    ld      h,(ix+19)
    push    hl
    pop     af                          ; af = key (a=hi, f=lo) for asm_bsearch's push af
    ld      l,(ix+14)                   ; hl = nmemb (loaded last)
    ld      h,(ix+15)

    call    asm_bsearch                 ; hl = result (item ptr or 0), carry = not found

    pop     bc                          ; discard the 6-byte closure
    pop     bc
    pop     bc

    pop     ix                          ; restore caller's ix
    ret                                 ; hl = result; caller cleans the arguments

ENDIF
