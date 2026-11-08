; fgetc_cons for the all-RAM console: waits for a key.  getk returns a key for as long as it is down (a poll takes about 2.6 ms: 380 a second), so a key is
; returned once when it goes down, then again after REPEAT_FIRST polls and every REPEAT_RATE polls while it is held.  It counts as released after RELEASE
; polls without it (contact bounce).

    MODULE  fp1100_allram_fgetc_cons
    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons
    EXTERN  getk

IFNDEF REPEAT_FIRST
    defc    REPEAT_FIRST = 150          ; about 0.4 s
ENDIF
IFNDEF REPEAT_RATE
    defc    REPEAT_RATE = 35            ; about 11 a second
ENDIF
IFNDEF RELEASE
    defc    RELEASE = 3
ENDIF

fgetc_cons:
_fgetc_cons:
    call    getk
    ld      a, l
    and     a
    jr      nz, fc_key
    ld      a, (fc_empty)               ; no key
    inc     a
    ld      (fc_empty), a
    cp      RELEASE
    jr      c, fgetc_cons
    xor     a
    ld      (fc_last), a                ; released
    ld      (fc_empty), a
    jr      fgetc_cons
fc_key:
    ld      b, a
    xor     a
    ld      (fc_empty), a
    ld      a, (fc_last)
    cp      b
    jr      z, fc_held
    ld      a, b                        ; a new key
    ld      (fc_last), a
    ld      a, REPEAT_FIRST
    ld      (fc_wait), a
    jr      fc_ret
fc_held:
    ld      a, (fc_wait)
    dec     a
    ld      (fc_wait), a
    jr      nz, fgetc_cons
    ld      a, REPEAT_RATE
    ld      (fc_wait), a
fc_ret:
    ld      l, b
    ld      h, 0
    ret

    SECTION bss_clib
fc_last:
    defb    0
fc_empty:
    defb    0
fc_wait:
    defb    0
