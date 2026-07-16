
;
; void qsort(void *base, size_t nel, size_t width, int (*compar)(const void *, const void *))
;
; sdcc entry + sdcc comparator thunk.  See qsort.asm (sccz80) for the design;
; this is the same entry with the sdcc comparator thunk, which differs only in
; the argument push order (sdcc --sdcccall 0 pushes right-to-left).
;

    SECTION code_clib

; Z80-family only (closure lives in ix); 8080/8085/gbz80 need a fallback -- TODO.
IF !__CPU_INTEL__ && !__CPU_GBZ80__

    PUBLIC  _qsort                      ; sdcc links the _-prefixed name
    PUBLIC  l_cmp_sdcc                  ; comparator thunk (closure slot target)

    EXTERN  asm_qsort

;------------------------------------------------------------------------
; qsort(base, nel, width, compar)  __smallc  (caller cleans arguments)
;
;   sp -> ix, ret, compar, width, nel, base   (after preserving caller ix)
;------------------------------------------------------------------------

_qsort:

    push    ix                          ; preserve caller's ix (frame pointer)

    ld      hl,4
    add     hl,sp
    ld      e,(hl)                      ; de = compar (user comparator address)
    inc     hl
    ld      d,(hl)

    push    de                          ; bytes 4,5 = user comparator address
    ld      hl,0C300h + (l_cmp_sdcc >> 8)
    push    hl                          ; bytes 2,3 = hi(thunk), C3
    ld      hl,0C3h + ((l_cmp_sdcc & 0FFh) << 8)
    push    hl                          ; bytes 0,1 = C3, lo(thunk)

    ld      ix,0
    add     ix,sp                       ; ix -> closure (slot0 = jp l_cmp_sdcc)

    ld      e,(ix+12)                   ; width -> de = size
    ld      d,(ix+13)
    ld      l,(ix+14)                   ; nel   -> hl = nmemb
    ld      h,(ix+15)
    ld      c,(ix+16)                   ; base  -> bc = base
    ld      b,(ix+17)

    call    asm_qsort

    pop     bc                          ; discard the 6-byte closure
    pop     bc
    pop     bc

    pop     ix                          ; restore caller's ix
    ret

;------------------------------------------------------------------------
; sdcc comparator thunk
;
; enter : ix -> closure ; de = left ; hl = right ; (sp) = return to core
; exit  : sign flags of (*compar)(left,right), a = low byte, carry reset,
;         de/hl/bc/ix preserved (mirrors l_compare_de_hl)
;------------------------------------------------------------------------

l_cmp_sdcc:

    push    bc                          ; core needs bc (size) preserved
    push    ix                          ; core needs ix (closure) preserved

    push    hl                          ; sdcc --sdcccall 0: right first (deeper)
    push    de                          ; left on top

    ld      c,(ix+4)                    ; bc = user comparator address
    ld      b,(ix+5)
    call    l_call_bc                   ; (*compar)(left, right) -> hl

    ld      a,h
    or      a
    ld      a,l                         ; sign flags + a = low byte, carry reset

    pop     de                          ; de = left  (restored)
    pop     hl                          ; hl = right (restored)
    pop     ix                          ; ix = closure
    pop     bc                          ; bc = size
    ret

;------------------------------------------------------------------------
; call the routine whose address is in bc  (l_call_bc is not in the library)
;------------------------------------------------------------------------

l_call_bc:

    push    bc
    ret

ENDIF
