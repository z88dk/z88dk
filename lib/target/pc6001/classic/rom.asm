; Startup 4: a cartridge (-subtype=rom): the ROM at $4000 with the "AB" header
; and the address of the program, the variables in RAM above the video RAM, the
; stack at the top.
; The data is copied from the ROM (model 1).  The mkII cartridge is the same:
; with -clib=mk2 (which defines CRT_PC6001MK2) the program has the mkII's
; 320x200 console and graphics, the screen's 16 KB at $8000 (mk2.inc), and the
; rest of the layout is as it is.

    defc        CRT_ORG_CODE=$4000      ; ROM
  IF    !DEFINED_CRT_ORG_BSS
    ; Static variables are kept in RAM above max VRAM
    defc        CRT_ORG_BSS=$da00
    defc        DEFINED_CRT_ORG_BSS=1
  ENDIF
    defc        __crt_org_bss=CRT_ORG_BSS

    ; In ROM mode we MUST setup the stack
    defc        TAR__register_sp=0xffff
; If we were given a model then use it
  IF    DEFINED_CRT_MODEL
    defc        __crt_model=CRT_MODEL
  ELSE
    defc        __crt_model=1
  ENDIF

  IF    DEFINED_CRT_PC6001MK2
    INCLUDE     "target/pc6001/classic/mk2.inc"
  ELSE
    defc        __pc6001mk2=0
    defc        CONSOLE_COLUMNS=32
    defc        CONSOLE_ROWS=16

    defc        DEFINED_ansicolumns=1
    defc        ansicolumns=32
  ENDIF

    INCLUDE     "target/pc6001/classic/common.inc"

    org         CRT_ORG_CODE

    defb        $41
    defb        $42
    defw        start

start:
    ld          (__restore_sp_onexit+1), sp
                                        ;Save entry stack
    INCLUDE     "crt/classic/crt_init_sp.inc"
    call        crt0_init
  IF    __pc6001mk2
    IF  !DEFINED_CRT_PC6001MK2_NO_MODE
    EXTERN      __pc6001mk2_init
    ; the 320x200 mode and its console (-pragma-define:CRT_PC6001MK2_NO_MODE=1:
    ; the program does its own)
    call        __pc6001mk2_init
    ENDIF
  ENDIF
    INCLUDE     "crt/classic/crt_init_atexit.inc"

    INCLUDE     "crt/classic/crt_init_heap.inc"
    INCLUDE     "crt/classic/crt_init_eidi.inc"

; (the mkII's own mode is set by __pc6001mk2_init)
  IF    !__pc6001mk2
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
