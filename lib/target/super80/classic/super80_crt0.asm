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

        EXTERN    _main           ;main() is always external to crt0 code
	EXTERN    asm_im1_handler
	EXTERN    asm_nmi_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)



        defc    TAR__no_ansifont = 1
        defc    CRT_KEY_DEL = 12
        defc    __CPU_CLOCK = 2000000


	defc	CRT_ORG_CODE = 0x0000

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0xbdff

        INCLUDE "crt/classic/crt_rules.inc"

	org	  CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif
	di
	jp	program

	defs	$0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart08

	defs	$0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart10

	defs	$0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart18

	defs	$0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart20

    defs	$0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart28

	defs	$0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart30

	defs	$0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	asm_im1_handler

	defs	$0066 - ASMPC
if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	asm_nmi_handler

; Restart routines, nothing sorted yet
restart10:
restart08:
restart18:
restart20:
restart28:
restart30:
	ret

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
	im	1
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
	ld	c,@00110110
	ld	a,c
	out	($F0),a
	; So we're on the text page
	ld	hl,$f000
	ld	(hl),32
	res	2,a		;Swich to colour
	out	($F0),a
	ld	(hl),0		;Black on black
	set	2,a
	out	($F0),a
	ld	a,(hl)	
	cp	32
	jr	z,is_super80v
	res	2,c		;If bit 2 is zero, indicate we're on super80r
is_super80v:
	ld	a,c
	ld	(PORT_F0_COPY),a
	ld	a,$BE
	out	($F1),a
	ld	(PORT_F1_COPY),a
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	di
	halt
	jp	cleanup


l_dcal: jp      (hl)            ;Used for function pointer calls



        INCLUDE "crt/classic/crt_runtime_selection.asm"

        INCLUDE "crt/classic/crt_section.asm"

	SECTION	bss_crt
	PUBLIC	PORT_F0_COPY
	PUBLIC	PORT_F1_COPY

PORT_F0_COPY:	defb	0
PORT_F1_COPY:	defb	0
