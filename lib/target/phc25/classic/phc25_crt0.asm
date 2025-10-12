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

    EXTERN      asm_im1_handler


IFNDEF CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $c009	 ; RAM
ENDIF

    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 16

    defc    DEFINED_ansicolumns = 1
    defc    ansicolumns = 32

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xfdfd       ;Must be below interrupt table
    defc    TAR__crt_enable_eidi = 2        ;Enable interrupts
    defc	__CPU_CLOCK = 4000000
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
    di
    INCLUDE	"crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

IF (__crt_enable_eidi & 0x02)
    ; Setup im2 since im1 is broken for our purposes
    ld      de,$fe00        ;im table
    ld      hl,$fdfd        ;jump address
    ld      a,d
    ld      i,a
    ld      a,h
imloop:
    ld      (de),a
    inc     e
    jr      nz,imloop
    inc     d
    ld      (de),a
    ld      (hl),0xc3
    inc     hl
    ld      de,asm_im1_handler
    ld      (hl),e
    inc     l
    ld      (hl),d
    im      2
ENDIF
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main
__Exit:
    call    crt0_exit

    ; We've probably broken all the basic variables, just restart if we get here
    rst 0
    
noop:
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE	"crt/classic/crt_section.inc"



    INCLUDE  "crt/classic/mc6847/mc6847_mode_disable.inc"
