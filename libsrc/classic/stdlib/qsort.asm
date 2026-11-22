
;
; void qsort(void *base, size_t nel, size_t width, int (*compar)(const void *, const void *))
;
; sccz80 entry + sccz80 comparator thunk.
;
; The classic C library is a SINGLE library shared by both sccz80- and
; sdcc-compiled programs, so the comparator calling convention cannot be
; resolved at library build time.  Instead each compiler links a distinct
; entry symbol (sccz80 -> qsort_sccz80, sdcc -> _qsort_sdcc) which builds a
; small closure on the stack and passes its address in ix:
;
;     ix+0 : jp l_cmp_sccz80     ; per-compiler comparator thunk
;     ix+3 : jp <user comparator>
;
; The shared sort core (stdlib/z80/sort/asm_*sort.asm) just does
; "call l_jpix" (= jp (ix)) to compare; that lands on the thunk, which
; marshals the two operands in the compiler's argument order, calls the
; user comparator, and returns the result exactly as l_compare_de_hl would
; (sign flags, a = low byte, de/hl/bc/ix preserved).
;
; This keeps ONE sort core for both compilers, is re-entrant (the closure
; lives on the caller's stack, not in static storage) and lets a single
; executable mix sccz80 and sdcc translation units.
;

    SECTION code_clib

; The closure lives in ix, so this implementation is Z80-family only.
; 8080/8085/gbz80 (no ix) need a memory-indirect fallback -- TODO.
IF !__CPU_INTEL__ && !__CPU_GBZ80__

    PUBLIC  qsort                       ; sccz80 links the bare name (__LIB__)
    PUBLIC  l_cmp_sccz80                ; comparator thunk (closure slot target)

    EXTERN  asm_qsort

;------------------------------------------------------------------------
; qsort(base, nel, width, compar)  __smallc  (caller cleans arguments)
;
; __smallc pushes left-to-right; after preserving the caller's ix:
;   sp -> ix, ret, compar, width, nel, base
;------------------------------------------------------------------------

qsort:

    push    ix                          ; preserve caller's ix (frame pointer)

    ld      hl,4
    add     hl,sp
    ld      e,(hl)                      ; de = compar (user comparator address)
    inc     hl
    ld      d,(hl)

    ; build the closure by pushing it, low..high:
    ;   C3 lo(thunk) hi(thunk)  = jp l_cmp_sccz80
    ;   C3 lo(user)  hi(user)   = jp compar   (only its address is read)

    push    de                          ; bytes 4,5 = user comparator address
    ld      hl,0C300h + (l_cmp_sccz80 >> 8)
    push    hl                          ; bytes 2,3 = hi(thunk), C3
    ld      hl,0C3h + ((l_cmp_sccz80 & 0FFh) << 8)
    push    hl                          ; bytes 0,1 = C3, lo(thunk)

    ld      ix,0
    add     ix,sp                       ; ix -> closure (slot0 = jp l_cmp_sccz80)

    ; asm_qsort wants: ix = comparator handle, bc = base, hl = nmemb, de = size
    ; saved-ix + ret + args sit just above the 6-byte closure

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
    ret                                 ; caller cleans the arguments

;------------------------------------------------------------------------
; sccz80 comparator thunk
;
; enter : ix -> closure ; de = left ; hl = right ; (sp) = return to core
; exit  : sign flags of (*compar)(left,right), a = low byte, carry reset,
;         de/hl/bc/ix preserved (mirrors l_compare_de_hl)
;
; The two argument pushes double as the de/hl operand saves, so only bc and
; ix need saving separately.
;------------------------------------------------------------------------

l_cmp_sccz80:

    push    bc                          ; core needs bc (size) preserved
    push    ix                          ; core needs ix (closure) preserved

    push    de                          ; arg0 = left  (deeper); restores de later
    push    hl                          ; arg1 = right (top);    restores hl later

    ld      c,(ix+4)                    ; bc = user comparator address
    ld      b,(ix+5)
    call    l_call_bc                   ; (*compar)(left, right) -> hl

    ld      a,h
    or      a
    ld      a,l                         ; sign flags + a = low byte, carry reset

    pop     hl                          ; hl = right (restored)
    pop     de                          ; de = left  (restored)
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
