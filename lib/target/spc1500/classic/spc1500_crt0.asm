;
;	CRT0 for the Samsung SPC-1500: a cassette started by the IPL's "C:
;	cassette system".
;
;	The program is linked at $0000 and takes the whole machine (the IPL ROM
;	is paged out with ram select, I/O port $1E00),
;	with the stack at the top of memory.  The cassette holds a 128 byte
;	bootstrap (the IPL loads only that much, to $0000) and
;	the program packed with ZX0, which the bootstrap loads with the IPL
;	ROM's own loader and unpacks (see bootstrap.asm).
;
;    $Id: spc1500_crt0.asm $
;

    MODULE  spc1500_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit          ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)

    defc    CONSOLE_ROWS = 25
    defc    CONSOLE_COLUMNS = 40
    defc    CRT_KEY_DEL = 12

    defc    TAR__no_ansifont = 1
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    __CPU_CLOCK = 4000000

    IFNDEF  CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x0000
    ENDIF
    defc    TAR__register_sp = 0x0000
    defc    TAR__crt_enable_rst = $8080
    defc    TAR__crt_on_exit = $10001       ;loop forever
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
    INCLUDE "crt/classic/crt_rules.inc"

    ; -pragma-define:CRT_TRIM_BSS=n (default 1): appmake leaves the
    ; uninitialised data out of the image on the tape.  The start-up zeroes it
    ; (CRT_INITIALIZE_BSS), so it need not
    ; be there, nor count against the room the unpacking needs.  0 keeps it in
    ; (a program that sets CRT_INITIALIZE_BSS=0 and relies on the zeros).
    IFNDEF  CRT_TRIM_BSS
    defc    CRT_TRIM_BSS = 1
    ENDIF
    PUBLIC  __spc1500_trim_bss
    IF CRT_TRIM_BSS && CRT_INITIALIZE_BSS
    defc    __spc1500_trim_bss = 1
    ELSE
    defc    __spc1500_trim_bss = 0
    ENDIF

    PUBLIC  __spc1500_start

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di
    jp      __spc1500_start

    INCLUDE "crt/classic/crt_z80_rsts.inc"

__spc1500_start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"
    ; The machine in its graphics mode (the IPL leaves its text mode, which
    ; nothing here can draw in): after the BSS is cleared, as the palette
    ; shadow is there
    EXTERN  spc1500_gfx_init
    call    spc1500_gfx_init
    im      1
    ei

    call    _main           ; Call user program
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal: jp      (hl)            ;Used for function pointer calls

IF !DEFINED_ansicolumns
    defc DEFINED_ansicolumns = 1
    defc ansicolumns = 40
ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.inc"

IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

    INCLUDE "crt/classic/crt_section.inc"

    ; The 128 byte bootstrap the IPL loads (a section of its own:
    ; <program>_BOOTSTRAP.bin)
    INCLUDE "target/spc1500/classic/bootstrap.asm"
