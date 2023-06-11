;
; Bandai Supervision 8000
;


    module  sv8000_crt0



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  asm_im1_handler

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 16
    PUBLIC  GRAPHICS_CHAR_SET
    PUBLIC  GRAPHICS_CHAR_UNSET
    defc    GRAPHICS_CHAR_SET = 160
    defc    GRAPHICS_CHAR_UNSET = 32

    defc    CRT_ORG_BSS = 0x8000
    defc    CRT_ORG_CODE = 0x0000
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0x83ff
    defc	CRT_KEY_DEL = 127
    defc	__CPU_CLOCK = 3579545

    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

    jp      program
noop:
    ret

    INCLUDE "crt/classic/crt_z80_rsts.asm"

program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
    ei
    ; Enable AY ports
    ld      a,7
    out     ($c1),a
    ld      a,$7f
    out     ($c0),a	
    ; Reset to text mode
    ld      a,14
    out     ($c1),a
    ld      a,0
    out     ($c0),a

    ; Enable keyboard scanning
    ld      a,$92
    out     ($83),a
	
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    call    _main
cleanup:
    di
    halt

l_dcal: jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE "crt/classic/crt_section.asm"

IF CLIB_DISABLE_MODE0 = 1
    PUBLIC  plot_MODE0
    PUBLIC  res_MODE0
    PUBLIC  xor_MODE0
    PUBLIC  pointxy_MODE0
    defc    plot_MODE0 = noop
    defc    res_MODE0 = noop
    defc    xor_MODE0 = noop
    defc    pointxy_MODE0 = noop
ENDIF

IF CLIB_DISABLE_MODE1 = 1
    PUBLIC  vpeek_MODE1
    PUBLIC  printc_MODE1
    PUBLIC  plot_MODE1
    PUBLIC  res_MODE1
    PUBLIC  xor_MODE1
    PUBLIC  pointxy_MODE1
    PUBLIC  pixeladdress_MODE1
    EXTERN	vpeek_noop
    defc    vpeek_MODE1 = vpeek_noop
    defc    printc_MODE1 = noop
    defc    plot_MODE1 = noop
    defc    res_MODE1 = noop
    defc    xor_MODE1 = noop
    defc    pointxy_MODE1 = noop
    defc    pixeladdress_MODE1 = noop
ENDIF
