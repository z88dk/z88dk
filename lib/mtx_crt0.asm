;       Memotech MTX CRT0 stub
;
;       $Id: mtx_crt0.asm,v 1.15 2016-07-15 21:03:25 dom Exp $
;


        MODULE  mtx_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)


; SEGA and MSX specific
	PUBLIC	msxbios


;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

        IF !DEFINED_CRT_ORG_CODE
            IF (startup=2)                 ; ROM ?
                defc    CRT_ORG_CODE  = 16384+19
            ELSE
                defc    CRT_ORG_CODE  = 32768+19
            ENDIF
        ENDIF


        org     CRT_ORG_CODE


start:

        ld      (start1+1),sp   ; Save entry stack

        ld      hl,-64
        add     hl,sp
        ld      sp,hl

	call	crt0_init_bss
        ld      (exitsp),sp


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


        call    _main           ; Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl				; return code

IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF


cleanup_exit:

        pop     bc				; return code (still not sure it is teh right one !)

start1: ld      sp,0            ;Restore stack to entry value
        ret


l_dcal: jp      (hl)            ;Used for function pointer calls



; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
msxbios:
	push	ix
	ret


	defm    "Small C+ MTX"   ;Unnecessary file signature
	defb    0
        INCLUDE "crt0_runtime_selection.asm"

        INCLUDE "crt0_section.asm"

	SECTION	bss_crt

	PUBLIC	pixelbyte
pixelbyte:      defb	0

	PUBLIC	fputc_vdp_offs	;Current character pointer
			
	PUBLIC	aPLibMemory_bits;apLib support variable
	PUBLIC	aPLibMemory_byte;apLib support variable
	PUBLIC	aPLibMemory_LWM	;apLib support variable
	PUBLIC	aPLibMemory_R0	;apLib support variable

	PUBLIC	raster_procs	;Raster interrupt handlers
	PUBLIC	pause_procs	;Pause interrupt handlers

	PUBLIC	timer		;This is incremented every time a VBL/HBL interrupt happens
	PUBLIC	_pause_flag	;This alternates between 0 and 1 every time pause is pressed

	PUBLIC	RG0SAV		;keeping track of VDP register values
	PUBLIC	RG1SAV
	PUBLIC	RG2SAV
	PUBLIC	RG3SAV
	PUBLIC	RG4SAV
	PUBLIC	RG5SAV
	PUBLIC	RG6SAV
	PUBLIC	RG7SAV       
; imported form the pre-existing Sega Master System libs
fputc_vdp_offs:		defw	0	;Current character pointer
aPLibMemory_bits:	defb	0	;apLib support variable
aPLibMemory_byte:	defb	0	;apLib support variable
aPLibMemory_LWM:	defb	0	;apLib support variable
aPLibMemory_R0:		defw	0	;apLib support variable
raster_procs:		defw	0	;Raster interrupt handlers
pause_procs:		defs	8	;Pause interrupt handlers
timer:				defw	0	;This is incremented every time a VBL/HBL interrupt happens
_pause_flag:		defb	0	;This alternates between 0 and 1 every time pause is pressed

RG0SAV:		defb	0	;keeping track of VDP register values
RG1SAV:		defb	0
RG2SAV:		defb	0
RG3SAV:		defb	0
RG4SAV:		defb	0
RG5SAV:		defb	0
RG6SAV:		defb	0
RG7SAV:		defb	0




