;       Startup for NEC PC6001 computers
;
;       Stefano Bodrato - Jan 2013
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: pc6001_crt0.asm,v 1.11 2016/07/11 21:19:38 dom Exp $
;



    MODULE  pc6001_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)



IF (startup=2)
    defc    CRT_ORG_CODE  = $8437  ; PC6001 - 32k (Answer "2" to "How many pages?")
ENDIF

IF (startup=3)
    defc    CRT_ORG_CODE  = $8037	 ; PC6001 - MK2 (Answer "2" to "How many pages?")
ENDIF

IF (startup=4)
    defc    CRT_ORG_CODE  = $4000	 ; ROM
  IF !DEFINED_CRT_ORG_BSS
    defc    CRT_ORG_BSS =  $da00   ; Static variables are kept in RAM above max VRAM
    defc    DEFINED_CRT_ORG_BSS = 1
  ENDIF
    defc    __crt_org_bss = CRT_ORG_BSS

    ; In ROM mode we MUST setup the stack
    defc	TAR__register_sp = 0xffff
; If we were given a model then use it
  IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
  ELSE
    defc __crt_model = 1
  ENDIF
ENDIF

IF (startup=1)
    defc    CRT_ORG_CODE  = $c437  ; PC6001 - 16K
ENDIF

    INCLUDE	"target/pc6001/def/pc6001.def"

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

IF (startup=4)
    defb    $41
    defb    $42
    defw    start
ENDIF

start:
		;di

		;ld	a,$DD
		;out	($F0),a
		;out	($F1),a

		; on entry HL holds the current location
;IF (CRT_ORG_CODE=$c437)
;	; if we built a 16K program and we run in a 32k environment, then let's relocate it.
;		ld	a,$c4
;		cp	h
;		jr	z,noreloc
;		; if we're still here, then HL should be = $8437
;		ld	de,$c437
;		ld	bc,$3700	; This works for programs smaller than 14k
;		ldir
;		jp	$c437+17
;noreloc:
;ENDIF

		
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

IF startup != 1
    ld      a,0
    out     ($B0),a
    ld      a,$C0
    ld      (SYSVAR_screen),a
ENDIF

    call    _main
cleanup:
    call    crt0_exit
__restore_sp_onexit:
    ld      sp,0
    ;ei
noop:
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE	"crt/classic/crt_section.asm"

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
