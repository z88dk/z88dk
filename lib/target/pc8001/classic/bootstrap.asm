;       NEC PC-8001mkII bootstrap for a program that runs with the ROM switched out
;
;       This is the first file on the tape. N-BASIC loads it (MON, L, then G E000).
;       The second file is the program, built for $0000. The monitor's own tape
;       routine reads it, so it has to be called with the ROM still in place. The
;       mkII lets the RAM under the ROM be written to while the ROM is read, so
;       the program goes straight over the ROM. Then the RAM is switched in and
;       the program runs.
;
;       The routines are the ROM's own, see def/pc8001.def.

    INCLUDE "target/pc8001/def/pc8001.def"

    SECTION BOOTSTRAP

    PUBLIC  __pc8001_bootstrap_built

    defc    __pc8001_bootstrap_built = 1

    org     $e000

bootstrap:
    di
    ld      hl, intro_string
    call    print_string

    ld      a, EXRAM_WRITE              ;Writes go to the RAM under the ROM, reads
    out     (EXRAM_CTL), a              ;still go to the ROM, which has the loader
    xor     a
    ld      (MON_VERIFY), a             ;Load, not verify
    ld      a, (WS_PORT30)              ;Cassette motor on, as the monitor's L does it
    and     $07
    or      $0c
    ld      (WS_PORT30), a
    out     ($30), a

    call    TAPE_READ_FILE
    jr      c, failed
    call    TAPE_MOTOR_OFF

    ld      a, EXRAM_READ|EXRAM_WRITE   ;The RAM is what is at $0000 now
    out     (EXRAM_CTL), a
    jp      $0000

failed:
    call    TAPE_MOTOR_OFF
    xor     a
    out     (EXRAM_CTL), a              ;The ROM is back
    ld      hl, failed_string
    call    print_string
    jp      MON_PROMPT

print_string:
    ld      a, (hl)
    and     a
    ret     z
    call    PRINT_CHAR
    inc     hl
    jr      print_string

intro_string:
    defm    "z88dk PC-8001 bootstrap: loading"
    defb    13, 10, 0
failed_string:
    defm    "Loading failed"
    defb    13, 10, 0
