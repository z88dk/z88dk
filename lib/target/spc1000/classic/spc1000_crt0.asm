;	SPC-1000 


    MODULE  spc1000_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)

    defc	CRT_ORG_CODE = 0x7cdd

    defc	CONSOLE_ROWS = 16
    defc	CONSOLE_COLUMNS = 32

    defc	CRT_KEY_DEL = 12

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = -1
    defc	__CPU_CLOCK = 4000000 
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
