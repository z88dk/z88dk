;
; exec: function to chain to another C-generated com file, with
;	 text argument passing.
;
; Calling sequence:
;	 exec(prog, args);
;	 char *prog, *args;
;
; where
;	 prog is the name of the program being executed next
;	 args is a pointer to a string of arguments separated by
;	   blanks or tabs.  Embedded blanks within the arguments are
;	   not allowed, unless the called program does not use the
;	   default FCB parameters (and most don't) and can parse the
;	   command line parameter list itself (like C80 programs can).
;


	SECTION code_clib

	PUBLIC    execl
	PUBLIC    _execl


	EXTERN    _parsefcb
	EXTERN    asm_toupper
	EXTERN    l_gint
	EXTERN	__bdos


;
;	CP/M memory pointers
;
DEFC __BASE   =  0000H       ;either 0 or 4200h for CP/M systems
DEFC __FCB    =  __BASE+5CH  ;default file control block
DEFC __TBUFF  =  __BASE+80H  ;sector buffer
DEFC __BDOS   =  __bdos      ;bdos entry point
DEFC __TPA    =  __BASE+100H ;transient program area
DEFC __ERRV   =  255         ;error value returned by bdos calls

;
;	CP/M BDOS CALL MNEMONICS
;
DEFC __OPENC  =  15 ;open a file
DEFC __READS  =  20 ;read a sector (sequential)
DEFC __SDMA  =  26 ;set dma


execl:
_execl:

	LD HL,4
	ADD	HL,SP
	LD  E,(HL)
	INC HL
	LD  D,(HL) 	;DE points to program name now
	
	LD HL,-60
	ADD	HL,SP		; compute &newfcb for use here
	PUSH HL		; save for much later (will pop into bc)
	PUSH HL		;make a few copies for local use below
	PUSH HL
	
	;  CP/M name->FCB routine.  Call with file name address in DE, FCB IN HL.
	;CALL x?fcb	;set up com file for exec-ing
	;push hl
	push de
	call _parsefcb
	pop	de
	;pop	hl
	
	POP HL		;get new fcb addr
	LD BC,9 	;set extension to com
	ADD	HL,BC
	LD  (HL),'C'
	INC HL
	LD  (HL),'O'
	INC HL
	LD  (HL),'M'
	POP DE		;get new fcb addr again
	LD  C,__OPENC	;open the file for reading
	CALL __BDOS
	CP __ERRV
	JP	NZ,__NOERR
	POP HL		;if can't (like it doesn't exist), return -1
	LD HL,-1
	RET


__NOERR:
	LD HL,4 	;get args pointer
	ADD	HL,SP
	CALL l_gint		; CALL h.	;HL = *HL
	CALL __SPARG	;separate them into individual strings
	LD HL,(__ARG1)
	LD  A,H
	OR L
	JP	NZ,__EXCL0
	LD DE,__ARG1	;no arguments -- create a blank FCB
	PUSH DE		;call x?fcb with null string
	LD HL,__FCB
	
	;  CP/M name->FCB routine.  Call with file name address in DE, FCB IN HL.
	;CALL x?fcb

	push hl
	push de
	call _parsefcb
	pop	de
	pop	hl
	
	POP HL
	JP __EXCL6
	

__EXCL0:
	EX	DE,HL
	LD HL,__FCB

	;  CP/M name->FCB routine.  Call with file name address in DE, FCB IN HL.
	;CALL x?fcb	;stick first param into default FCB slot

	push hl
	push de
	call _parsefcb
	pop	de
	pop	hl

	LD HL,(__ARG2)	;and stick second param string
	LD  A,H
	OR L
	JP	NZ,__EXCL6
	LD HL,__ARG2

__EXCL6:
	EX	DE,HL		;into second default fcb slot
	LD HL,__FCB+16

	;  CP/M name->FCB routine.  Call with file name address in DE, FCB IN HL.
	;CALL x?fcb
	push hl
	push de
	call _parsefcb
	pop	de
	pop	hl

	LD DE,__TBUFF+1	 ;now construct command line:
	LD HL,4
	ADD	HL,SP		;HL points to arg string pointer
	CALL l_gint		; CALL h.	;HL points to arg string
	LD  B,0 	;char count for com. line buf.
	LD  A,H 	;are there any arguments?
	OR L
	JP	Z,__EXCL9
	OR (HL)		; (Bug fix 7/83 WB)
	JP	NZ,__EXCL5
__EXCL9:
	LD (DE),A		;no--zero TBUFF and TBUFF+1
	JP __EXCL2
__EXCL5:
	LD  A,' '	;yes--start buffer off with a ' '
	LD (DE),A
	INC DE
	INC B
__EXCL1:
	LD  A,(HL) 	;now copy argument string to command line
	CALL asm_toupper	;make sure they're upper case
	LD (DE),A
	INC DE
	INC HL
	INC B
	OR A
	JP	NZ,__EXCL1
	DEC B

__EXCL2:
	LD HL,__TBUFF	;set length of command line
	LD  (HL),B 	;at location tbuff

	LD DE,__CODE0	;copy loader down to end of tbuff
	LD HL,__TPA-42
	LD  B,42	;length of loader
__EXCL4:
	LD A,(DE)
	LD  (HL),A
	INC DE
	INC HL
	DEC B
	JP	NZ,__EXCL4

	POP BC			;get back working fcb pointer
	LD HL,(__BASE+6)
	LD	SP,HL
	LD HL,__BASE
	PUSH HL			;set base of ram as return addr
	JP __TPA-42		;(go to `CODE0:')
;
; THIS LOADER CODE IS NOW: 42 BYTES LONG.
;
__CODE0:
	LD DE,__TPA		;destination address of new program
__CODE1:
	PUSH DE			;push dma addr
	PUSH BC			;push fcb pointer
	LD  C,__SDMA		;set dma address for new sector
	CALL __BDOS
	POP DE			;get pointer to working fcb in de
	PUSH DE			;and re-push it
	LD  C,__READS		;read a sector
	CALL __BDOS
	POP BC			;restore fcb pointer into bc
	POP DE			;and dma address into de
	OR A			;end of file?
	JP	Z,__TPA-8		;if not, get next sector (goto `CODE2:')
	LD  C,__SDMA		;reset dma pointer
	LD DE,__TBUFF
	CALL __BDOS
	JP __TPA		;and go invoke the program

__CODE2:
	LD HL,80H		; bump dma address
	ADD	HL,DE
	EX	DE,HL
	JP __TPA-39		;and go loop (at CODE1)


;
; this routine takes the string pointed to by HL,
; seperates it into non-white strings,
; and places them contiguously in array ARGST.
; also places pointers to these individual strings in ARGS
;
__SPARG:
	EX	DE,HL		;DE = original string
	LD BC,__ARGST	;BC = new string (w/ each substr 0-terminated)
	LD HL,__ARGS	;HL = pointer to ARGS space
__SEP0:
	DEC DE
__SEP1:
	INC DE		;scan over white space
	LD A,(DE)
	CP ' '
	JP	Z,__SEP1
	CP 9
	JP	Z,__SEP1
	CP 0		; char = 0?
	JP	Z,__SPRET	; yes -- return
	LD  (HL),C 	; no -- store local pointer at proper args
	INC HL
	LD  (HL),B 	;argsn = BC
	INC HL
__TOWSP:
	LD (BC),A		;store non-white
	INC BC
	INC DE		;now scan to next white space
	LD A,(DE)
	CP 0
	JP	Z,__SEP2
	CP ' '
	JP	Z,__SEP2
	CP 9
	JP	NZ,__TOWSP
__SEP2:
	XOR A
	LD (BC),A		;store 0 to terminate this string
	INC BC
	JP __SEP0	; and loop
	
__SPRET:
	LD  (HL),A 	;set last argn to 0 and return
	INC HL
	LD  (HL),A
	RET



SECTION bss_clib

;
;	Argument pointers
;
__ARGS:	DEFS 0
__ARG1:	DEFS 2
__ARG2:	DEFS 2
__ARG3:	DEFS 2
__ARG4:	DEFS 2
__ARG5:	DEFS 2
__ARG6:	DEFS 2
;

__ARGST:
	DEFS 100

