;       CRT0 for the Amstrad CPC family
;
;       Stefano Bodrato 8/6/2000
;
;       $Id: cpc_crt0.asm,v 1.9 2007-07-21 21:27:23 dom Exp $
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
        di
        ld      (start1+1),sp
        ld      hl,-6530
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
        exx
        ld      (firmware_bc),bc
        push    af
        pop     hl
        ld      (firmware_af),hl
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

.start1 ld      sp,0
        ei
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
        exx                      ; Use alternate registers
        ex      (sp),hl          ; get return address
        ld      c,(hl)
        inc     hl
        ld      b,(hl)           ; BC=BASIC address
        inc     hl
        ex      (sp),hl          ; restore return address
        push    bc
        ld      bc,(firmware_bc)
        ld      hl,(firmware_af)
        push    hl
        pop     af
        exx                      ; Back to the regular set
        ret                      ; And call the firmware routine 

        
._std_seed      defw    0       ;  Default seed
.exitsp         defw    0       ;  atexit       
.exitcount      defb    0
.base_graphics
                defw	$C000
.coords         defw	0
.firmware_bc    defw    0
.firmware_af    defw    0

                defm    "Small C+ CPC"
                defb    0

IF NEED_floatpack
        INCLUDE         "#float.asm"

;seed for random number generator - not used yet..
.fp_seed        defb    $80,$80,0,0,0,0
;Floating point registers...
.extra          defs    6
.fa             defs    6
.fasign         defb    0

ENDIF

