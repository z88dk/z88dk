;
;       Startup Code for Z88 applications
;
;	The entry point is a dummy function in the DOR which then
;	jumps to routine in this file
;
;       1/4/99 djm
;
;       7/4/99 djm Added function to handle commands - this requires
;       the user to do something for it!
;
;       4/5/99 djm Added in functionality to remove check for expanded
;       machine, not to give those people reluctant to ug something to
;       use, but to save memory in very small apps
;
;	1/4/2000 djm Added in conditionals for:
;		- far heap stuff (Ask GWL for details!)
;		- "ANSI" stdio - i.e. flagged and ungetc'able
;
;	6/10/2001 djm Clean up (after Henk)
;
;	$Id: app_crt0.asm,v 1.4 2001-10-15 22:42:40 dom Exp $


;--------
; Call up some header files (probably too many but...)
;--------
	INCLUDE "#stdio.def"
	INCLUDE "#fileio.def"
	INCLUDE "#memory.def"
	INCLUDE "#error.def"
	INCLUDE "#time.def"
	INCLUDE "#syspar.def"
	INCLUDE "#director.def"

;--------
; Set some scope variables
;--------
        XDEF    app_entrypoint	;Start of execution in this file 
        XREF    applname	;Application name (in DOR)
        XREF    in_dor		;DOR address

;--------
; Set an origin for the application (-zorg=) default to 49152
;--------
        
        IF      !myzorg
                defc    myzorg  = 49152
        ENDIF
                org     myzorg

;--------
; Calculate the required bad memory. If we're using a near heap then the
; compiler sets it to $20+(HEAPSIZE%256)+1
; If we reqpag == 0 or reqpag <> 0 then we don't want to define it else
; default to $20 (8k)
;--------
        IF      (reqpag=0) | (reqpag)
        ELSE 
                defc    reqpag  = $20
        ENDIF

;--------
; We need a safedata def. So if not defined set to 0
;--------
        IF      !safedata
                defc    safedata = 0
        ENDIF


;--------
; Start of execution. We enter with ix pointing to info table about
; memory allocated to us by OZ. 
;--------
.app_entrypoint
;-------
; If we want to debug, then intuition is set, so call $2000
; This assumes several things...no bad memory required, and we've
; been blown onto an EPROM along with Intuition and our app DOR
; has been set appropriately to page in Intuition in segment 0
; Call intuition if that set (assumes no bad memory and DOR is setup)
;-------
IF (intuition <> 0 ) ~ (reqpag=0)
        call    $2000
ENDIF
IF (reqpag <> 0)
        ld      a,(ix+2)	;Check allocated bad memory if needed
        cp      $20+reqpag
        ld      hl,nomemory
; Bit of trickery with conditional assembly here, if we don't need an
; expanded machine, jump on success to init_continue or if failure
; flow into init_error.
; If we need expanded, jump on failure to init_error and flow onto
; check for expanded
  IF (NEED_expanded=0)			
        jr      nc,init_continue
  ELSE
        jr      c,init_error
  ENDIF
ENDIF
IF NEED_expanded <> 0
        ld      ix,-1		;Check for an expanded machine
        ld      a,FA_EOF
        call_oz(os_frm)
        jr      z,init_continue
        ld      hl,need_expanded_text
ENDIF

IF (reqpag<>0) | (NEED_expanded<>0)
.init_error			;Code to deal with an initialisation error
        push    hl		;The text that we are printing
        ld      hl,clrscr	;Clear the screen
        call_oz(gn_sop)
        ld      hl,windini	;Define a small window
        call_oz(gn_sop)
        pop     hl
        call_oz(gn_sop)		;Print text
        ld      bc,500
        call_oz(os_dly)		;Pause
        xor     a
        call_oz(os_bye)		;Exit
ENDIF

.init_continue			;We had enough memory
        ld   a,sc_dis		;Disable escape 
        call_oz(os_esc)
        xor     a		;Setup our error handler
        ld      b,a
        ld      hl,errhan
        call_oz(os_erh)
        ld      (l_errlevel),a	;Save previous values
        ld      (l_erraddr),hl
        ld      hl,applname	;Name application
        call_oz(dc_nam)
        ld      hl,clrscr	;Setup a BASIC sized window
        call_oz(gn_sop)
        ld      hl,clrscr2
        call_oz(gn_sop)
;--------
; Now, set up some very nice variables - stream ids for std*
;--------
IF DEFINED_ANSIstdio
	ld	hl,sgoprotos
	ld	de,__sgoioblk
	ld	bc,4*10		;4*10 FILES
	ldir
ELSE
        ld      hl,-10
        ld      (__sgoioblk+4),hl
        dec     hl
        ld      (__sgoioblk),hl
        dec     hl
        ld      (__sgoioblk+2),hl
ENDIF
        ld      hl,$8080	;Initialise floating point seed
        ld      (fp_seed),hl
        xor     a		;Reset atexit() count
        ld      (exitcount),a
        ld      hl,-64		;Setup atexit() stack
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
IF DEFINED_farheapsz
	call	init_far	;Initialise far memory if required
ENDIF
        call    _main		;Call the users code
        xor     a		;Exit with zero 
.cleanup			;Jump back to here from exit()
IF DEFINED_ANSIstdio
	push	af		;Save exit value
	LIB	closeall
	call	closeall	;Close all files
 IF DEFINED_farheapsz
 	call	freeall_far	;Deallocate far memory
 ENDIF
	pop	af		;Get exit value back
ELSE	;!ANSIstdio
  IF DEFINED_farheapsz
	push	af		;Deallocate far memory
	call	freeall_far
	pop	af
  ENDIF
ENDIF	;ANSIstdio

        call_oz(os_bye)		;Exit back to OZ

.l_dcal	jp	(hl)		;Used by various things

;-------
; Process a <> command, we call the users handlecmds APPFUNC
;-------
.processcmd
IF DEFINED_handlecmds
        XREF    _handlecmds
        ld      l,a
        ld      h,0
        push    hl
        call    _handlecmds
        pop     bc
ENDIF
        ld      hl,0		;dummy return value
        ret


;--------
; Fairly simple error handler
;--------
.errhan	ret	z		;Fatal error - far mem probs?
IF DEFINED_redrawscreen
        XREF    _redrawscreen
        cp      rc_draw		;(Rc_susp for BASIC!)
        jr      nz,errhan2
        push    af		;Call users screen redraw fn if defined
        call    _redrawscreen
        pop     af
ENDIF
.errhan2
        cp      rc_quit		;they don't like us!
        jr      nz,keine_error
IF DEFINED_applicationquit
	XREF	_applicationquit	;Call users routine if defined
	call	_applicationquit
ENDIF
        xor     a		;Standard cleanup
        jr      cleanup

.keine_error
        xor     a
        ret

;--------
; Far memory setup
;--------
IF DEFINED_farheapsz
	LIB	freeall_far
	XDEF	farpages
	XDEF	malloc_table
	XDEF	farmemspec
	XDEF	pool_table
; All far memory variables now in init_far.asm
	INCLUDE	"#init_far.asm"

ENDIF

;--------
; This bit of code allows us to use OZ ptrs transparently
; We copy any data from up far to a near buffer so that OZ
; is happy about it
; Prototype is extern void __FASTCALL__ *cpfar2near(far void *)
;--------
IF DEFINED_farheapsz
	LIB	strcpy_far
._cpfar2near
	pop	bc	;ret address
	pop	hl
	pop	de	;far ptr
	push	bc	;keep ret address
	ld	a,e
	and	a
	ret	z	;already local
	push	ix	;keep ix safe
	ld	bc,0	;local
	push	bc
	ld	bc,copybuff
	push	bc	;dest
	push	de	;source
	push	hl
	call	strcpy_far
	pop	bc	;dump args
	pop	bc
	pop	bc
	pop	bc
	pop	ix	;get ix back
	ld	hl,copybuff
	ret
ELSE
; We have no far code installed so all we have to do is fix the stack
._cpfar2near
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret
ENDIF

;--------
; Which printf core routine do we need?
;--------
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

;-------
; Text to define the BASIC style window
;-------
.clrscr		defb    1,'7','#','1',32,32,32+94,32+8,128,1,'2','C','1',0
.clrscr2		defb    1,'2','+','S',1,'2','+','C',0
          

IF (NEED_expanded <> 0 )  | (reqpag <>0)
.windini
          defb   1,'7','#','3',32+7,32+1,32+34,32+7,131     ;dialogue box
          defb   1,'2','C','3',1,'4','+','T','U','R',1,'2','J','C'
          defb   1,'3','@',32,32  ;reset to (0,0)
          defm   "Small C+ Application"
          defb   1,'3','@',32,32 ,1,'2','A',32+34  ;keep settings for 10
          defb   1,'7','#','3',32+8,32+3,32+32,32+5,128     ;dialogue box
          defb   1,'2','C','3'
          defb   1,'3','@',32,32,1,'2','+','B'
          defb   0
ENDIF

IF reqpag <> 0
.nomemory
        defb    1,'3','@',32,32,1,'2','J','C'
        defm    "Not enough memory allocated to run application"
        defb    13,10,13,10
        defm    "Sorry, please try again later!"
        defb    0
ENDIF

IF (NEED_expanded <> 0 )
.need_expanded_text
        defb    1,'3','@',32,32,1,'2','J','C'
        defm    "Sorry, application needs an expanded machine"
        defb    13,10,13,10
        defm    "Try again when you have expanded your machine"
        defb    0
ENDIF

;--------
; Include the stdio handle defaults if we need them
;--------
IF DEFINED_ANSIstdio
.sgoprotos
	INCLUDE	"#stdio_fp.asm"
ENDIF

;--------
; Variables need by crt0 code and some lib routines are kept in safe workspace
;--------
DEFVARS $1ffD-100-safedata
{
__sgoioblk	ds.b	40	;stdio control block
l_erraddr	ds.w	1	;Not sure if these are used...
l_errlevel	ds.b	1
coords		ds.w	1	;Graphics xy coordinates
base_graphics	ds.w	1	;Address of graphics map
gfx_bank	ds.b	1	;Bank that this is in
int_seed	ds.w	1	;Integer seed
exitsp		ds.w	1	;atexit() stack
exitcount	ds.b	1	;Number of atexit() routines
fp_seed		ds.w	3	;Floating point seed (not used ATM)
extra		ds.w	3	;Floating point spare register
fa		ds.w	3	;Floating point accumulator
fasign		ds.b	1	;Floating point variable
heapblocks	ds.w	1	;Number of free blocks
heaplast	ds.w	1	;Pointer to linked blocks
packintrout	ds.w	1	;User interrupt handler
snd_asave	ds.b	1	;Sound
snd_tick	ds.b	1	;Sound
}

;--------
; Now, include the math routines if needed..
;--------
IF NEED_floatpack
        INCLUDE "#float.asm"
ENDIF

;-------
; If we have no safedata then set up defvars addr to point to bad memory
; If we use safedata then we cn't have far memory
;-------
IF !safedata
	IF !DEFINED_defvarsaddr
		defc defvarsaddr = 8192
	ENDIF

	DEFVARS defvarsaddr
	{
	dummydummy        ds.b    1 
	}

	IF DEFINED_farheapsz
		INCLUDE 	"#app_crt0.as1"
	ENDIF
ENDIF

