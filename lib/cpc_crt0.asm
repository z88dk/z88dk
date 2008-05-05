;       CRT0 for the Amstrad CPC family
;
;       Stefano Bodrato 8/6/2000
;
;       $Id: cpc_crt0.asm,v 1.11 2008-05-05 14:14:02 stefano Exp $
;

        MODULE  cpc_crt0


        INCLUDE "zcc_opt.def"


        XREF    _main



        XDEF    cleanup
        XDEF    l_dcal
        XDEF    firmware
        XDEF	_vfprintf
        
        XDEF    _std_seed
        XDEF    exitsp
        XDEF    exitcount

        ;For stdin, stdout, stder

        XDEF    __sgoioblk

;       Graphics stuff
        XDEF	base_graphics
        XDEF	coords

        ; Now, getting to the real stuff now!

        IF      !myzorg
                defc    myzorg  = $6000
        ENDIF   
                org     myzorg


        org     myzorg


.start
        ld	hl,($39)	; Original Interrupt code
        ld	(oldint),hl
        ld	hl,newint
        ld	($39),hl
        
        ld      (start1+1),sp
        ld      hl,-6530
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
        exx
        ld      (firmware_bc),bc
        exx
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19	;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21	;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21	;stderr
ENDIF
ENDIF


; INIT math identify platform
IF NEED_floatpack
        LIB     init_floatpack
        call    init_floatpack
ENDIF

        call    _main
.cleanup
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        LIB     closeall
        call	closeall
ENDIF
ENDIF
	call	firmware
	defw	fmw_retaddr	; foo call to restore registers

	ld	hl,(oldint)
	ld	($39),hl
	
.start1 ld      sp,0
.fmw_retaddr
        ret

.l_dcal jp      (hl)

; Now, define some values for stdin, stdout, stderr

.__sgoioblk
IF DEFINED_ANSIstdio
        INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


; Now, which of the vfprintf routines do we need?


._vfprintf
IF DEFINED_floatstdio
	LIB	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		LIB	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			LIB	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF

; Function to call firmware function
; ix = firmware routine to call
; 
.firmware

;LD IX,faraddr1
;LD HL,readst
;CALL 0BCD4h
        exx                      ; Use alternate registers
        ex      (sp),hl          ; get return address
        ld      c,(hl)
        inc     hl
        ld      b,(hl)           ; BC=BASIC address
        inc     hl
        ex      (sp),hl          ; restore return address
        push    bc		 ; firmware location to jump to first
        ld      bc,(firmware_bc)
        exx                      ; Back to the regular set
        ret                      ; And call the firmware routine

        
._std_seed      defw    0       ;  Default seed
.exitsp         defw    0       ;  atexit       
.exitcount      defb    0
.base_graphics
                defw	$C000
.coords         defw	0
.firmware_bc    defw    0

                defm    "Small C+ CPC"
                defb    0

IF NEED_floatpack
        INCLUDE         "#float.asm"
;.init_floatpack
;	ret

;seed for random number generator - not used yet..
.fp_seed        defb    $80,$80,0,0,0,0
;Floating point registers...
.extra          defs    6
.fa             defs    6
.fasign         defb    0

ENDIF



.newint
	ei
	reti

.oldint
	defw 0




; Initialise serial device and driver
; AF, BC, DE, HL may be corrupted
; Interrupts may be disabled and then reenabled

di

if	INTDRIVEN

INTERRUPT_ENTRY equ	&0038
EXT_INTERRUPT	equ	&003b

NEW_CODE	equ	&bdc4		; 6 unused bytes

; Allow Z80 support chip interrupts to work
; (based on Soft 968 App. XIII.7, but optimised)

ld	hl, (INTERRUPT_ENTRY + 1) ; HL = ADDRESS_X
ld	de, 5
add	hl, de			; HL = ADDRESS_X + 5

ld	de, call_new_code	; Copy the CALL NEW_CODE patch
ex	de, hl			; to ADDRESS_X + 5
ld	bc, 4
ldir

ld	hl, new_code_patch	; Copy the NEW_CODE patch itself
ld	de, NEW_CODE		; to NEW_CODE
ld	bc, 6
ldir

; Patch in external interrupt handler
; Assume sole external interrupt source

ld	hl, ext_interrupt_patch
ld	de, EXT_INTERRUPT
ld	bc, 3
ldir

endif	; INTDRIVEN





if	INTDRIVEN

.ext_interrupt_patch

jp	serial_interrupt_handler

.call_new_code

call	NEW_CODE
nop

.new_code_patch

ld	a, c
scf
ex	af, af'
ei
reti

endif	; INTDRIVEN
