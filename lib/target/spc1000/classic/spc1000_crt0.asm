;	SPC-1000 


    MODULE  spc1000_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)

    defc	CONSOLE_ROWS = 16
    defc	CONSOLE_COLUMNS = 32

    defc	CRT_KEY_DEL = 12

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc	__CPU_CLOCK = 4000000 

IF (!DEFINED_startup | (startup=1))
    ; Called from BASIC (the program is loaded at $7CDD, with BASIC still in RAM below and above it)
    defc	CRT_ORG_CODE = 0x7cdd
    defc    TAR__register_sp = -1
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE
    jp      start

start:
    ld      (__restore_sp_onexit+1),sp   ; Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"

    call	crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main           ; Call user program
__Exit:
    push    hl              ; return code
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0            ;Restore stack to entry value
noop:
    ret
ELSE
    ; All RAM (-subtype=allram): the program is linked at $0000 and takes the whole machine, with the stack at the top of memory and BASIC gone.
    IFNDEF  CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x0000
    ENDIF
    defc    TAR__register_sp = 0x0000
    defc    TAR__crt_enable_rst = $8080
    defc    TAR__crt_on_exit = $10001       ;loop forever
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
    INCLUDE "crt/classic/crt_rules.inc"

    PUBLIC  __spc1000_allram_start

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di
    jp      __spc1000_allram_start

    INCLUDE "crt/classic/crt_z80_rsts.inc"

__spc1000_allram_start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"
    im      1
    ei

    call    _main           ; Call user program
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"
ENDIF


l_dcal: jp      (hl)            ;Used for function pointer calls



IF CRT_ENABLE_VDP
ELSE
    PUBLIC  __tms9918_cls
    PUBLIC  __tms9918_console_vpeek
    PUBLIC  __tms9918_console_ioctl
    PUBLIC  __tms9918_scrollup
    PUBLIC  __tms9918_printc
    PUBLIC  __tms9918_set_ink
    PUBLIC  __tms9918_set_paper
    PUBLIC  __tms9918_set_attribute
    PUBLIC  __tms9918_plotpixel
    PUBLIC  __tms9918_respixel
    PUBLIC  __tms9918_xorpixel
    PUBLIC  __tms9918_pointxy
    PUBLIC  __tms9918_getmaxx
    PUBLIC  __tms9918_getmaxy

    defc    __tms9918_cls = stub
    defc    __tms9918_console_vpeek = stub_scf
    defc    __tms9918_console_ioctl = stub_scf
    defc    __tms9918_scrollup = stub
    defc    __tms9918_printc = stub
    defc    __tms9918_set_ink = stub
    defc    __tms9918_set_paper = stub
    defc    __tms9918_set_attribute = stub
    defc    __tms9918_plotpixel = stub
    defc    __tms9918_xorpixel = stub
    defc    __tms9918_respixel = stub
    defc    __tms9918_pointxy = stub
    defc    __tms9918_getmaxx = stub
    defc    __tms9918_getmaxy = stub

stub_scf:
    scf
stub:
    ret
ENDIF




    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

    INCLUDE "crt/classic/mc6847/mc6847_mode_disable.inc"

IF (DEFINED_startup && startup=2)
    ; The bootstrap BASIC loads, which unpacks the program (a section of its own: <program>_BOOTSTRAP.bin)
    INCLUDE "target/spc1000/classic/bootstrap.asm"
ENDIF
