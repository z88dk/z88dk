;
;	Startup for Nabu
;

    module  nabu_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF


    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 3570000

    PUBLIC  PSG_AY_REG
    PUBLIC  PSG_AY_DATA
    defc    PSG_AY_REG = $40
    defc    PSG_AY_DATA = $41

    EXTERN  cpm_platform_init
    EXTERN  vdp_set_mode

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = $ff00
    defc    TAR__fputc_cons_generic = 1

    defc    CRT_ORG_CODE = $140d

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    defb    0,0,0

start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    di
    ld      a,$ff
    ld      i,a
    im      2
    call    crt0_init_bss
    ; Code is shared with CP/M. This is a noop, but pulls in code
    ; into crt0_init and crt0_exit
    call    cpm_platform_init 
    ld      (exitsp),sp

     ; Initialise mode 2 by default
    ld      hl,2
    call    vdp_set_mode


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    call    _main
cleanup:
    push    hl
    call    crt0_exit

    pop     bc
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms9918/mode_disable.asm"

    INCLUDE	"crt/classic/crt_section.asm"
    INCLUDE "target/nabu/classic/nabu_hccabuf.asm"

