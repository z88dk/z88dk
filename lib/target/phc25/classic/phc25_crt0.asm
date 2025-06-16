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


    defc    CRT_ORG_CODE  = $c500	 ; RAM

    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 16

    defc    DEFINED_ansicolumns = 1
    defc    ansicolumns = 32

    defc    TAR__fputc_cons_generic = 1
    defc	TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
IFNDEF TAR__register_sp
    defc	TAR__register_sp = -1
ENDIF
    defc	__CPU_CLOCK = 3800000
    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE
start:

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
    ;ei
noop:
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE	"crt/classic/crt_section.inc"


    SECTION bootstrap
    org     $c400



    di
    call    4863h ; 454eh
    call    4775h ; 445fh
    call    44deh ; 41d4h

    call    read_header_byte


    call    read_byte
    ld      h,a
    add     a,c
    ld      c,a
    call    read_byte
    ld      l,a
    add     c
    ld      c,a
    call    read_byte
    add     c
    jr      nz,cksum_error
    push    hl      ;Save entry point

read_block:
    call    read_header_byte
    call    read_byte
    and     a
    jr      z,block_finished
    ld      b,a
    add     a,c
    ld      c,a
read_block_bytes:
    call    read_byte
    ld      (hl),a
    inc     hl
    add     c
    ld      c,a
    djnz    read_block_bytes
    call    read_byte
    add     c
    jr      nz,cksum_error
    jr      read_block

block_finished:
    call    read_byte
    and     a
    jr      nz,cksum_error

    call 486ah; 4555h
    pop     hl      ;Entry point
    jp      (hl)



read_header_byte:
    call    read_byte
    cp      $3a
    jr      nz, read_header_byte
    ret

read_byte:
    push    hl
    push    bc
    call 444bh ; 413eh
    pop     bc
    pop     hl
    ret

cksum_error:
    jr      cksum_error


    EXTERN	vpeek_noop


IF CLIB_DISABLE_MODE1 = 1
    PUBLIC	vpeek_MODE1
    PUBLIC	printc_MODE1
    PUBLIC	plot_MODE1
    PUBLIC	res_MODE1
    PUBLIC	xor_MODE1
    PUBLIC	pointxy_MODE1
    PUBLIC	pixeladdress_MODE1
    defc	vpeek_MODE1 = vpeek_noop
    defc	printc_MODE1 = noop
    defc	plot_MODE1 = noop
    defc	res_MODE1 = noop
    defc	xor_MODE1 = noop
    defc	pointxy_MODE1 = noop
    defc	pixeladdress_MODE1 = noop
ENDIF
IF CLIB_DISABLE_MODE2 = 1
    PUBLIC	vpeek_MODE2
    PUBLIC	printc_MODE2
    PUBLIC	plot_MODE2
    PUBLIC	res_MODE2
    PUBLIC	xor_MODE2
    PUBLIC	pointxy_MODE2
    PUBLIC	pixeladdress_MODE2
    defc	vpeek_MODE2 = vpeek_noop
    defc	printc_MODE2 = noop
    defc	plot_MODE2 = noop
    defc	res_MODE2 = noop
    defc	xor_MODE2 = noop
    defc	pointxy_MODE2 = noop
    defc	pixeladdress_MODE2 = noop
ENDIF
