;
;	Startup for the Dick Smith Super80
;


    module super80_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  asm_im1_handler
    EXTERN  asm_nmi_handler

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)



    defc    TAR__no_ansifont = 1
    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 2000000


    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xbdff

    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
IFNDEF CRT_ENABLE_NMI
    defc    TAR__crt_enable_nmi = 1
    EXTERN  asm_nmi_handler
    defc    _z80_nmi = asm_nmi_handler
ENDIF

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di
    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.asm"


program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
    im      1
; F0 General Purpose output port
; Bit 0 - cassette output
; Bit 1 - cassette relay control; 0=relay on
; Bit 2 - turns screen on and off;0=screen off	
;		Toggles colour/text on 6845 models
; Bit 3 - Available for user projects [We will use it for sound]
; Bit 4 - Available for user projects [We will use it for video switching]
;		PCG banking?
; Bit 5 - cassette LED; 0=LED on
; Bit 6/7 - not decoded
    ld      c,@00110110
    ld      a,c
    out     ($F0),a
IF CRT_SUPER80_VDUEM
    ; So we're on the text page
    ld      hl,$f000
    ld      (hl),32
    res     2,a     ;Switch to colour
    out     ($F0),a
    ld      (hl),0  ;Black on black
    set     2,a
    out     ($F0),a
    ld      a,(hl)	
    cp      32
    jr      z,is_super80v
    res     2,c     ;If bit 2 is zero, indicate we're on super80r
ENDIF
is_super80v:
    ld      a,c
    ld      (PORT_F0_COPY),a
    ld      a,$BE
    out     ($F1),a
    ld      (PORT_F1_COPY),a
    ei
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
    jp      cleanup


l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE "crt/classic/crt_section.asm"

    SECTION bss_crt
    PUBLIC  PORT_F0_COPY
    PUBLIC  PORT_F1_COPY

PORT_F0_COPY:	defb	0
PORT_F1_COPY:	defb	0
