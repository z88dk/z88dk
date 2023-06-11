;       CRT0 stub for the Jupiter ACE
;
;       Stefano Bodrato - Feb 2001
;
;	$Id: ace_crt0.asm,v 1.26 2016-07-15 21:03:25 dom Exp $
;


    MODULE  ace_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main

    PUBLIC    cleanup
    PUBLIC    l_dcal




IF      !DEFINED_CRT_ORG_CODE
    IF (startup=2)                 ; ROM ?
        defc    CRT_ORG_CODE  = 0
    ELSE
        defc    CRT_ORG_CODE  = $4000
    ENDIF
ENDIF

    defc    CONSOLE_ROWS = 24
    defc    CONSOLE_COLUMNS = 32

    defc    TAR__no_ansifont = 1
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 3250000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
IF (startup=2)
        ;  ROM mode BOOT
    di
    ld      hl,$3c00    ; RAM starts at $4000
    ld      a,$fc
ace_ramtest:
    inc     h           ; step to a higher RAM block
    ld      (hl),a      ; probe it
    cp      (hl)
    jr      z,ace_ramtest
    and     h
    ld      h,a         ; use $fc to mask to the lower 1k boundary
    ld      sp,hl
ELSE
    ld      (__restore_sp_onexit+1),sp
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
ENDIF
    call    crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_CRT_FONT
    defc    CHAR_TABLE = 0x2C00
    EXTERN	ace_set_font
    ld      hl,CRT_FONT
    ld      de,CHAR_TABLE + 256
    ld      bc,768
    ldir
ENDIF

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


IF (startup=2)

    ld      hl,$2c00		; character set RAM
        ; init the first 256 bytes with gfx blocks
gfx_bloop:
    ld      a,l
    and     $bf
    rrca
    rrca
    rrca
    jr      nc,nobit2
    rrca
    rrca

nobit2: rrca
    ld      b,a
    sbc     a,a		; 0 or $FF
    rr      b
    ld      b,a
    sbc     a,a
    xor     b
    and     $f0
    xor     b
    ld      (hl),a
    inc     l
    jr      nz,gfx_bloop

    ; a bit of cleanup (we should load a font, here!)
    xor  a
blankloop:
    ld      (hl),a
    inc     hl
    cp      l
    jr      nz,blankloop
        
    ld      h,$24
    ld      (base_graphics),hl

    EXTERN  cleargraphics
    call    cleargraphics

ELSE

    ld      hl,$2400
    ld      (base_graphics),hl

ENDIF

    call    _main
cleanup:
    push    hl
    call    crt0_exit
    pop     bc
__restore_sp_onexit:
    ld      sp,0
IF (startup=2)
    di
    halt
ELSE
    jp      (iy)    ; To the Jupiter ACE FORTH system
ENDIF

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm"

;---------------------------------------------------------------------------
IF (startup=2) 
;---------------------------------------------------------------------------

; Some extra space is available here
;	defc sysdefvarsaddr = $2800-80   ; Close to the end of "PAD", the Forth interpreter workspace

IF !CRT_ORG_BSS
    defc CRT_ORG_BSS = 24576
    defc DEFINED_CRT_ORG_BSS = 1
ENDIF

; If we were given a model then use it
IF DEFINED_CRT_MODEL
    defc    __crt_model = CRT_MODEL
ELSE
    defc    __crt_model = 1
ENDIF
ENDIF

IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

    INCLUDE	"crt/classic/crt_section.asm"

