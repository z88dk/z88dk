;
;	Startup for the Вектор-06Ц (Vector 06c)
;


    module vector06c_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler
    EXTERN    asm_load_palette

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

IFNDEF CLIB_FGETC_CONS_DELAY
    defc CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 32768
    defc	CRT_KEY_DEL = 12
    defc	__CPU_CLOCK = 3000000
    defc	CONSOLE_ROWS = 32
    defc	CONSOLE_COLUMNS = 32

    defc    TAR__crt_on_exit = 0x10001      ;Loop forever
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup 

    INCLUDE "crt/classic/crt_rules.inc"

IF startup = 2
    defc CRT_ORG_CODE = 0x80
    org  CRT_ORG_CODE

    defb $00, $00, $00, $00, $10, $00, $00, $01, $01, $01, $03, $01, $05, $00, $50, $00
    defb $28, $00, $04, $0f, $00, $87, $01, $7f, $00, $c0, $00, $20, $00, $08, $00, $fc
    defb $00, $00, $00, $00, $00, $00, $00, $00 ,$00, $00, $00, $00, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00 ,$00, $00, $00, $00, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00 ,$00, $00, $00, $00, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00 ,$00, $00, $00, $00, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00 ,$00, $00, $00, $00, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00 ,$00, $00, $00, $00, $00, $00, $00, $00

ELSE
    defc CRT_ORG_CODE = 0x0100

    org	  CRT_ORG_CODE
ENDIF



program:
    di
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    ld      a,195
    ld      ($38),a
    ld      hl,asm_im1_handler
    ld      ($39),hl
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
    xor     a
    out     ($10),a

    ld      a,$88
    out     ($00),a
    ld      hl,palette
    call    asm_load_palette

    INCLUDE "crt/classic/crt_init_amalloc.asm"
    INCLUDE "crt/classic/crt_start_eidi.inc"
    ld      hl,0
    push    hl
    push    hl
    call    _main
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"



l_dcal: jp      (hl)            ;Used for function pointer calls

;Colours  00   000   000
;         blue green red
palette:
    defb    @00000000	;Black
    defb    @11000000	;Blue
    defb    @00111000	;Green
    defb    @11111000	;Cyan

    defb    @00000111	;Red
    defb    @11000111	;Magenta
    defb    @00001111	;Brown
    defb    @01011011	;Light grey

    defb    @01001001	;Dark gray
    defb    @11001001	;Light blue
    defb    @01111001	;Light green
    defb    @11111001	;Light cyan

    defb    @01001111	;Light red
    defb    @11001111	;Light magenta
    defb    @01111111	;Yellow
    defb    @11111111	;White

    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    INCLUDE	"crt/classic/crt_section.asm"
