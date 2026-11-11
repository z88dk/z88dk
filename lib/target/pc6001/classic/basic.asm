; Startups 1, 2 and 3: programs BASIC loads from tape (appmake +nec makes the
; .cas)
;     1  16K: at $C437 (the default)
;     2  32K: at $8437 (answer "2" to "How many pages?")
;     3  the mkII's N60m BASIC: at $8037 (the same)
; The original PC-6001's 32x16 text console, drawn by the ROM's character
; generator.

  IF    (startup=2)
    ; PC6001 - 32k (Answer "2" to "How many pages?")
    defc        CRT_ORG_CODE=$8437
  ELIF  (startup=3)
    ; PC6001 - MK2 (Answer "2" to "How many pages?")
    defc        CRT_ORG_CODE=$8037
  ELSE
    defc        CRT_ORG_CODE=$c437      ; PC6001 - 16K
  ENDIF

    defc        __pc6001mk2=0
    defc        CONSOLE_COLUMNS=32
    defc        CONSOLE_ROWS=16

    defc        DEFINED_ansicolumns=1
    defc        ansicolumns=32

    INCLUDE     "target/pc6001/classic/common.inc"

    org         CRT_ORG_CODE

start:
    ld          (__restore_sp_onexit+1), sp
                                        ;Save entry stack
    INCLUDE     "crt/classic/crt_init_sp.inc"
    call        crt0_init
    INCLUDE     "crt/classic/crt_init_atexit.inc"

    INCLUDE     "crt/classic/crt_init_heap.inc"
    INCLUDE     "crt/classic/crt_init_eidi.inc"

  IF    startup!=1
    ld          a, 0
    out         ($B0), a
    ld          a, $C0
    ld          (SYSVAR_screen), a
  ENDIF

    call        _main
__Exit:
    call        crt0_exit
    INCLUDE     "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld          sp, 0
    ;ei
noop:
    ret

l_dcal:
    jp          (hl)
