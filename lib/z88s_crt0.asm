;
;       Startup stub for z88 Shell programs
;
;       Created 12/2/2002 djm
;
;	$Id: z88s_crt0.asm,v 1.11 2013-06-18 06:11:23 stefano Exp $



	INCLUDE	"stdio.def"
	INCLUDE "error.def"

	INCLUDE	"shellapi.def"

	org	shell_loadaddr-shell_headerlen

header_start:
	defm    "!bin"
	defb	shell_verh
	defb	shell_verm
	defb	shell_verl
	defb	13
shell_length:
	defw    0		; Fill in by make program
	defw    start


;-----------
; Code starts executing from here
;-----------
start:
	push	bc		; Preserve registers that need to be
	push	de	
	ld	(saveix),ix
	ld	(saveiy),iy
	ld	(start1+1),sp	;Save starting stack
	ld	hl,(shell_cmdlen)
	ld	de,(shell_cmdaddr)
	add	hl,de
	ld	(hl),0		; terminate command line
	ld	hl,-100		; atexit stack (64) + argv space
	add	hl,sp
	ld      sp,hl
	ld      (exitsp),sp	

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

	call    doerrhan	;Initialise a laughable error handler

		
;-----------
; Initialise the (ANSI) stdio descriptors so we can be called agin
;-----------
IF DEFINED_ANSIstdio
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
	;; Read in argc/argv
	ld	hl,0		; NULL pointer at end just in case
	push	hl
	;; Try and work out the length available
	ld	hl,(shell_cmdlen)
	ld	de,(shell_cmdaddr)
	add	hl,de		; points to end
	ex	de,hl		; end now in de, hl=cmdaddr
	ld	bc,(shell_cmdptr)
	add	hl,bc		; start in hl
	push	de		; save end
	ex	de,hl		; hl = end, de = start
	and	a
	sbc	hl,de		; hl is length available
	ex	de,hl		; is now in de
	pop	hl		; points to terminator
	ld	c,0		; number of arguments
	ld	a,d
	or	e
	jr	z,argv_none
	dec	hl
	dec	de		; available length
argv_loop:
	ld	a,d
	or	e
	jr	z,argv_exit
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop2
	ld	(hl),0		; terminate previous one
	inc	hl
	inc	c
	push	hl
	dec	hl
argv_loop2:
	dec	hl
	dec	de
	jr	argv_loop
argv_exit:
	push	hl		; first real argument
	inc	c
argv_none:
	ld	hl,end		; program name
	inc	c
	push	hl		
	ld	hl,0
	add	hl,sp		; address of argv
	ld	b,0
	push	bc		; argc
	push	hl		; argv
	ld	hl,(shell_cmdlen)
	ld	(shell_cmdptr),hl
	call_oz(gn_nln)		; Start a new line...
IF DEFINED_farheapsz
        call    init_far        ;Initialise far memory if required
ENDIF
        call    _main		;Run the program
IF DEFINED_farheapsz
        call    freeall_far        ;Initialise far memory if required
ENDIF
	pop	bc		; kill argv
	pop	bc		; kill argc
	
cleanup:			;Jump back here from exit() if needed
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall	;Close any open files (fopen)
ENDIF
        call    resterrhan	;Restore the original error handler
	
start1:	ld	sp,0		;Restore stack to entry value
	ld	ix,(saveix)	;Get back those registers
	ld	iy,(saveiy)
	pop	de
	pop	bc
	jp	shell_next	; phew! back to Forth at last.

;-----------
; Install the error handler
;-----------
doerrhan:
        xor     a
        ld      (exitcount),a
        ld      b,0
        ld      hl,errhand
        call_oz(os_erh)
        ld      (l_erraddr),hl
        ld      (l_errlevel),a
        ret

;-----------
; Restore BASICs error handler
;-----------
resterrhan:
        ld      hl,(l_erraddr)
        ld      a,(l_errlevel)
        ld      b,0
        call_oz(os_erh)
processcmd:			;processcmd is called after os_tin
        ld      hl,0
        ret


;-----------
; The error handler
;-----------
errhand:
        ret     z   		;Fatal error
        cp      rc_esc
        jr     z,errescpressed
        ld      hl,(l_erraddr)	;Pass everything to BASIC's handler
        scf
l_dcal:	jp	(hl)		;Used for function pointer calls also

errescpressed:
        call_oz(os_esc)		;Acknowledge escape pressed
        jr      cleanup		;Exit the program


;-----------
; Select which vfprintf routine is needed
;-----------
_vfprintf:
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


;--------
; Far memory setup
;--------
IF DEFINED_farheapsz
        LIB     freeall_far
        XDEF    farpages
        XDEF    malloc_table
        XDEF    farmemspec
        XDEF    pool_table
        INCLUDE "init_far.asm"

; Variables that can't be place in the normal defvars
copybuff:	defs	258
actual_malloc-table:
		defs	((farheapsz/256)+1)*2

; Now some memory shared with Forth - same as application setup
DEFVARS 8192
{
        pool_table      ds.b    224
        malloc_table    ds.w    1
        farpages        ds.w    1
        farmemspec      ds.b    1
}
ENDIF

;--------
; This bit of code allows us to use OZ ptrs transparently
; We copy any data from up far to a near buffer so that OZ
; is happy about it
; Prototype is extern void __FASTCALL__ *cpfar2near(far void *)
;--------
IF DEFINED_farheapsz
        LIB     strcpy_far
_cpfar2near:
        pop     bc      ;ret address
        pop     hl
        pop     de      ;far ptr
        push    bc      ;keep ret address
        ld      a,e
        and     a
        ret     z       ;already local
        push    ix      ;keep ix safe
        ld      bc,0    ;local
        push    bc
        ld      bc,copybuff
        push    bc      ;dest
        push    de      ;source
        push    hl
        call    strcpy_far
        pop     bc      ;dump args
        pop     bc
        pop     bc
        pop     bc
        pop     ix      ;get ix back
        ld      hl,copybuff
        ret
ELSE
; We have no far code installed so all we have to do is fix the stack
_cpfar2near:
        pop     bc
        pop     hl
        pop     de
        push    bc
        ret
ENDIF


;----------
; The system() function for the shell 
;----------
	XDEF	_system
_system:
	pop	de		; DE=return address
	pop	bc		; BC=command address
	push	bc
	push	de
	push	bc		; Forth stack: addr--
	ld	hl,system_forthcode
	call	_shellapi
				; Forth stack: flag--
	pop	hl		; HL=0 or error code
	ret

system_forthcode:
	defw	shell_also,shell_internal,shell_ztos,shell_eval,shell_previous
	defw	shellapi_back

;----------
; The shellapi() interface
;----------
	XDEF	_shellapi

_shellapi:
	push	hl
	call	resterrhan	;restore forth error handler
	pop	de		; DE=Forth's IP
	ld	iy,(saveiy)	; IY=Forth's UP
	ld	ix,(saveix)	; IX=Forth's RSP
	pop	hl
	dec	ix
	ld	(ix+0),h	; save return address on Forth's return stack
	dec	ix
	ld	(ix+0),l
	pop	bc		; BC=TOS
	jp	shell_next	; execute Forth code
shellapi_back:
	push	bc		; stack TOS
	ld	e,(ix+0)
	ld	d,(ix+1)
	push	de		; stack return address
	call	doerrhan	;put c error hander back
	ret


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


;-----------
; Now some variables
;-----------
l_erraddr:	defw	0	; BASIC error handler address
l_errlevel:	defb	0	; And error level


coords:         defw	0	; Current graphics xy coordinates
base_graphics:  defw	0	; Address of the Graphics map
gfx_bank:       defb    0	; And the bank

_std_seed:       defw    0	; Seed for integer rand() routines

exitsp:		defw	0	; Address of where the atexit() stack is
exitcount:	defb	0	; How many routines on the atexit() stack

IF DEFINED_NEED1bitsound
snd_asave:      defb    0	; Sound variable
snd_tick:       defb    0	;  "      "
ENDIF


heaplast:	defw	0	; Address of last block on heap
heapblocks:	defw 	0	; Number of blocks

IF DEFINED_USING_amalloc
XREF ASMTAIL
XDEF _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF


packintrout:	defw	0	; Address of user interrupt routine

saveix:		defw	0	; Save ix for system() calls
saveiy:		defw	0	; Save iy for system() calls


;-----------
; Unnecessary file signature
;-----------
		defm	"Small C+ z88shell"
end:		defb	0

;-----------
; Floating point
;-----------
IF NEED_floatpack
        INCLUDE         "float.asm"

fp_seed:        defb    $80,$80,0,0,0,0	; FP seed (unused ATM)
extra:          defs    6		; Extra register temp store
fa:             defs    6		; ""
fasign:         defb    0		; ""

ENDIF

