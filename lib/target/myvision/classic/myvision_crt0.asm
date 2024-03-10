;
;	Startup for Nichibutsu My Vision
;
;	2k of memory 

    module  myvision_crt0 



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)
    PUBLIC	msxbios
    EXTERN	vdp_set_mode
    EXTERN  asm_im1_handler
    EXTERN  nmi_vectors
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler
    EXTERN  __vdp_enable_status
    EXTERN  VDP_STATUS

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF

    defc    CRT_ORG_BSS = 0xa000
    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xa800
    defc    TAR__crt_enable_eidi = $02
    defc    TAR__crt_on_exit = 0x0000   ;jp to 0 for restart
    defc	CRT_KEY_DEL = 127
    defc	__CPU_CLOCK = 3579545

    ; VDP signals delivered to im1
    defc TAR__crt_enable_rst = $8080
    defc _z80_rst_38h = tms9918_interrupt

IF !DEFINED_CLIB_DEFAULT_SCREEN_MODE
    defc    CLIB_DEFAULT_SCREEN_MODE = 2
ENDIF

    INCLUDE "crt/classic/crt_rules.inc"

    org	  CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif

    jp      start

    INCLUDE	"crt/classic/crt_z80_rsts.inc"

    INCLUDE "crt/classic/tms99x8/tms99x8_interrupt.inc"
    ei
    reti

int_VBL:
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    ei
    reti

start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      (exitsp),sp
IF CLIB_DEFAULT_SCREEN_MODE != -1
    ld      hl,CLIB_DEFAULT_SCREEN_MODE
    call    vdp_set_mode
ENDIF
    im      1
 
    ; Configure the AY to enable reading the keys
    ld      a,$07
    out     ($00),a
    in      a,($02)
    set     7,a
    res     6,a
    out     ($01),a

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


; Safe BIOS call
msxbios:
    push    ix
    ret


l_dcal: 
    jp      (hl)            ;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

    defc	__crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE	"crt/classic/crt_section.inc"

