;
;       Startup stub for z88 Shell programs
;
;       Created 12/2/2002 djm
;
;	$Id: z88s_crt0.asm,v 1.21 2016-07-15 21:38:08 dom Exp $



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
        push    hl      ;argv
        push    bc      ;argc
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
IF !DEFINED_nostreams
	EXTERN	closeall
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
        cp      RC_Esc
        jr     z,errescpressed
        ld      hl,(l_erraddr)	;Pass everything to BASIC's handler
        scf
l_dcal:	jp	(hl)		;Used for function pointer calls also

errescpressed:
        call_oz(Os_Esc)		;Acknowledge escape pressed
        jr      cleanup		;Exit the program


        INCLUDE "crt0_runtime_selection.asm"

;--------
; Far memory setup
;--------
IF DEFINED_farheapsz
        EXTERN     freeall_far
        PUBLIC    farpages
        PUBLIC    malloc_table
        PUBLIC    farmemspec
        PUBLIC    pool_table
        INCLUDE "init_far.asm"


;--------
; This bit of code allows us to use OZ ptrs transparently
; We copy any data from up far to a near buffer so that OZ
; is happy about it
; Prototype is extern void __FASTCALL__ *cpfar2near(far void *)
;--------
IF DEFINED_farheapsz
        EXTERN     strcpy_far
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
	PUBLIC	_system
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
	PUBLIC	_shellapi

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


;--------
; Which printf core routine do we need?
;--------
        INCLUDE "crt0_runtime_selection.asm"




IF DEFINED_farheapsz
	defc	__crt_org_bss_fardata_start = 8192
	defc	__crt_org_bss_compiler_start = ASMTAIL_bss_crt
ENDIF

	INCLUDE	"crt0_section.asm"


IF DEFINED_farheapsz
	SECTION	crt0_init_bss
	INCLUDE	"init_far.asm"

        SECTION bss_fardata
	PUBLIC		pool_table
	PUBLIC		malloc_table
	PUBLIC		farpages
	PUBLIC		farmemspec
        pool_table:     defs    224
        malloc_table:   defw    0
        farpages:       defw    1
        farmemspec:     defb    1
        copybuff:       defs    258
        actual_malloc_table: defs ((farheapsz/256)+1)*2
ENDIF

