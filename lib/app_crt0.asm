;
;
;       Startup Code for Z88 applications
;
;       Problems:
;       - Doesn't OZ only allow entry in sector 3 of the memory map?
;       - Cirumvented by haveing the thing link with the application
;         header as the last file...neat <grin>
;
;       Anyway, on we go!
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


; Off we go on our voyage into the unknown...


; First of all, set a good old fashioned org address, you can specify this
; my using -zorg= to the compiler
;
; Done this way, because I'm sure in the past I've had problems with
; ELSE in z80asm, this way works, so use it!

        
        IF      !myzorg
                defc    myzorg  = 49152
        ENDIF

                org     myzorg

;
;       Required bad memory, if we're using a near heap, then this
;       will be set to $20+HEAPSIZE in 256 byte chunks
;
;       If reqpag == 0 or reqpag<>0 then we don't want to anything
;       if there's no reqpag then we want to define it!

        IF      (reqpag=0) | (reqpag)
        ELSE 
                defc    reqpag  = $20
        ENDIF

        IF      !safedata
                defc    safedata = 0
        ENDIF

        XDEF    app_entrypoint
        XREF    applname
        XREF    in_dor

; Include some files, probably have too many here, but I can't be
; bothered to weed ATM

                INCLUDE "#stdio.def"
                INCLUDE "#fileio.def"
                INCLUDE "#memory.def"
                INCLUDE "#error.def"
                INCLUDE "#time.def"
                INCLUDE "#syspar.def"
                INCLUDE "#director.def"

;
; Startup enters here, first thing we have to do is to check that we
; got the memory we wanted, hopefully you haven't got shedloads of
; static vars, so we must have at least 8k given to us, if you've
; used a near heap then we may have problems...


; Entry point..ix points to info table, if reqpag < 32 doesn't matter
; becaus of carry condition..neat!

.app_entrypoint
;
; If we want to debug, then intuition is set, so call $2000
; This assumes several things...no bad memory required, and we've
; been blown onto an EPROM along with Intuition and our app DOR
; has been set appropriately to page in Intuition in segment 0
;
IF (intuition <> 0 ) ~ (reqpag=0)
        call    $2000
ENDIF
IF (reqpag <> 0)
        ld      a,(ix+2)
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

;Now find out if we have an expanded machine or not...
IF NEED_expanded <> 0
        ld      ix,-1
        ld      a,FA_EOF
        call_oz(os_frm)
        jr      z,init_continue
        ld      hl,need_expanded_text
ENDIF

IF (reqpag<>0) | (NEED_expanded<>0)
.init_error
        push    hl
;Now define windows...
        ld      hl,clrscr
        call_oz(gn_sop)
        ld      hl,windini
        call_oz(gn_sop)
        pop     hl
        call_oz(gn_sop)
        ld      bc,500
        call_oz(os_dly)
        xor     a
        call_oz(os_bye)
ENDIF

.init_continue
        ld   a,sc_dis
        call_oz(os_esc)
        xor     a
        ld      b,a
        ld      hl,errhan
        call_oz(os_erh)
        ld      (l_errlevel),a
        ld      (l_erraddr),hl
        ld      hl,applname
        call_oz(dc_nam)
; Give the user a window which they know and love - BASIC shaped
; window...
        ld      hl,clrscr
        call_oz(gn_sop)
        ld      hl,clrscr2
        call_oz(gn_sop)


;
; Now, set up some very nice variables - stream ids for std*
;
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
        ld      hl,$8080
        ld      (fp_seed),hl
        xor     a
        ld      (exitcount),a

; Now handle the atexit() stack..
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
; Initialise far memory
IF DEFINED_farheapsz
	call	init_far
ENDIF
; Entry to the user code
        call    _main
        xor     a	;exit with zero unless explicit exit(nn)
.cleanup
; Close all files if necessary & dealloc memory
; Done this confusing way to save a push/pop pair
IF DEFINED_ANSIstdio
	push	af
	LIB	closeall
	call	closeall
; Deallocate memory here
 IF DEFINED_farheapsz
 	call	freeall_far
 ENDIF
	pop	af
ELSE	;!ANSIstdio
; Just need need to dealloc memory if had some
  IF DEFINED_farheapsz
	push	af
	call	freeall_far
	pop	af
  ENDIF
ENDIF	;ANSIstdio



        call_oz(os_bye)         ; See ya later, nice knowing ya...
.l_dcal
        jp      (hl)

;
;       Process a command - this again calls on the user to add a
;       function via __APPFUNC__ calling via C method

.processcmd
IF DEFINED_handlecmds
        XREF    _handlecmds
        ld      l,a
        ld      h,0
        push    hl
        call    _handlecmds
        pop     bc
ENDIF
        ld      hl,0    ;dummy return value
        ret


;
; Almost forgot this, an error handler..laughable again!
;

.errhan
        ret     z       ;fatal error - this may louse up allocated mem
IF DEFINED_redrawscreen
        XREF    _redrawscreen
        cp      rc_draw         ;rc_susp        (Rc_susp for BASIC!)
        jr      nz,errhan2
        push    af
        call    _redrawscreen
        pop     af
ENDIF
;This is to handle all errors
;Needs to be changed!
.errhan2
        cp      rc_quit                 ;they don't like us!
        jr      nz,keine_error
IF DEFINED_applicationquit
	XREF	_applicationquit
	call	_applicationquit
ENDIF
        xor     a
        jr      cleanup

.keine_error
        xor     a
        ret

; Far memory setup

IF DEFINED_farheapsz
	LIB	freeall_far
	XDEF	farpages
	XDEF	malloc_table
	XDEF	farmemspec
	XDEF	pool_table

; All far memory variables now in init_far.asm

	INCLUDE	"#init_far.asm"

ENDIF

; This bit of code allows us to use OZ ptrs transparently
; We copy any data from up far to a near buffer so that OZ
; is happy about it
; Prototype is extern void __FASTCALL__ *cpfar2near(far void *)

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
; We have no far code installed so all we have to do is fix the
; stack
._cpfar2near
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret
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

; Definition for the big window - BASIC style

.clrscr
        defb    1,'7','#','1',32,32,32+94,32+8,128,1,'2','C','1',0
.clrscr2
        defb    1,'2','+','S',1,'2','+','C',0
          

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






;
; Static Variables that we all need <sigh> -now kept in Safe Workspace
; so we can make good applications
;
; Rounded up to 55 bytes (to be safe and allow expansion
;
; Current count is 53 + 40 for ANSIstdio
;
; Also skip down to allow our safe data to insert itself, this is so
; we can write apps that use static data and still be good!
; (this *WILL* cause a problem if we have any libraries that access
; this data though - eg stdio fns)
;

IF DEFINED_ANSIstdio
; If ANSIstdio then we want to include our handles and
; reserve space for them

.sgoprotos
	INCLUDE	"#stdio_fp.asm"
ENDIF


DEFVARS $1ffD-100-safedata
{
__sgoioblk
	ds.b	40	;4 bytes * 10 handles
; Are these next two actually used?
l_erraddr
        ds.w    1
l_errlevel
        ds.w    1
coords
        ds.w    1
base_graphics
        ds.w    1
gfx_bank
        ds.w    1
int_seed
        ds.w    1
exitsp
        ds.w    1
exitcount
        ds.b    1
fp_seed
        ds.w    3       ;not used ATM
extra
        ds.w    3
fa
        ds.w    3
fasign
        ds.b    1
heapblocks
	ds.w	1
heaplast
	ds.w	1
packintrout
	ds.w	1
}

;
; Now, include the math routines if needed..
;

IF NEED_floatpack
        INCLUDE "#float.asm"
ENDIF

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

