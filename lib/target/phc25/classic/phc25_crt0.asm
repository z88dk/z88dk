;       Startup for Sanyo PHC-25
;



    MODULE  phc25_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    CRT_ORG_CODE  = $c009	 ; RAM

    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 16

    defc    DEFINED_ansicolumns = 1
    defc    ansicolumns = 32

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
IFNDEF TAR__register_sp
    defc	TAR__register_sp = -1
ENDIF
    defc	__CPU_CLOCK = 3800000
    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    ; Undo the silly escaping we had to do in appmake
start:
    ld      hl,real_code
    ld      de,real_code
loop:
    ld      a,(hl)
    inc     hl
    and     a
    jr      z,real_code
    cp      0xff
    jr      nz,copy_byte
    ld      a,(hl)
    inc     hl
copy_byte:
    ld      (de),a
    inc     de
    jr      loop

real_code:

    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE	"crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
noop:
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE	"crt/classic/crt_section.inc"



    INCLUDE  "crt/classic/mc6847/mc6847_mode_disable.inc"
