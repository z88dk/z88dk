;
;       Spectrum C Library
;
;	Print character to the screen in either 32/64 col mode
;
;       We will corrupt any register
;
;	Scrolling is now achieved by calling ROM3 routine 3582
;
;       We print over 24 lines at 64 columns
;
;       djm 3/3/2000
;
;
;	$Id: fputc_cons.asm,v 1.18 2016-05-15 20:15:46 dom Exp $
;


	SECTION	code_clib
          PUBLIC  fputc_cons_native


	  EXTERN  call_rom3
;
; Entry:        a= char to print
;

defc attr = 23693

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
        ex      af,af'
        ld      a,(flags)
        and     a
        jp      z,putit_out1    ;no parameters pending
; Set up so dump into params so first param is at highest posn
        ld      l,a
        ld      h,0
        ld      de,params-1
        add     hl,de
        dec     a
        ld      (flags),a
        ex      af,af'
        ld      (hl),a
	ex	af,af'
	and	a
	ret	nz
	ld	hl,(flagrout)
	jp	(hl)

.putit_out1
        ex      af,af'
	bit	7,a
	jr	z,putit_out2
; deal with UDGs here
	sub	128
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
.udgaddr	ld	de,65368
	add	hl,de
	jp	print32_entry
.putit_out2
        cp      32
.print1
        jp      nc,print64
; Control characters
        and     31
        add     a,a       ;x2
        ld      l,a
        ld      h,0
        ld      de,code_table
        add     hl,de
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      hl,(chrloc)     ;most of them will need the position
        push    de
        ret


;Normal print routine...
;Exit with carry set if OK..
          
.print64
          ld    l,a  
          ld    h,0  
          add   hl,hl  
          add   hl,hl  
          add   hl,hl  
          ld    de,font-256
          add   hl,de  
          exx   
;Get screen address in hl from
;64 column position in bc
          ld    bc,(chrloc)
	ld	a,b
	cp	24
	jr	c,noscroll
	call	scrollup
	ld	bc,23*256
	ld  (chrloc),bc
noscroll:
	  srl   c  
          ex    af,af'  
          ld    a,b  
          and   248  
          add   a,64  
          ld    h,a  
          ld    a,b  
          and   7  
          rrca  
          rrca  
          rrca  
          add   a,c  
          ld    l,a  
          ex    af,af'  
          ld    a,240  
          jr    c,gotpos  
          ld    a,15  
.gotpos   ld    c,a  
          exx   
          cpl   
          ld    c,a  
;c=char mask, hl=char addr
;c'=scr mask, hl'=scr addr
          ld    b,8  
.char1    ld    a,(hl)  
.invers1  defb    0  
          and   c  
          inc   hl  
          exx   ; screen  
          ld    b,a  
          ld    a,(hl)  
          and   c  
          or    b  
          ld    (hl),a  
          inc   h  
          exx   
          djnz  char1  
          exx   
          ld    a,h  
	  dec   a
          rrca  
          rrca  
          rrca  
          and   3  
          or    88  
          ld    h,a  
	  ld    a,(attr)
	  ld    (hl),a

.cbak     ld    hl,(chrloc)  
          inc   l  
.posncheck
          bit   6,l  
          jr    z,char4
.cbak1    ld    l,0  
          inc   h  
;	ld	a,h
;	cp	24
;	jr	nz,char4
;	call	scrollup
;	ld	hl,23*256
.char4    ld    (chrloc),hl  
          ret   

; 32 column print routine..quick 'n' dirty..we take
; x posn and divide by two to get our real position

.print32
	sub	32	;subtract 32 to get space = 0
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
.fontaddr
	ld	bc,15616
	add	hl,bc
.print32_entry
          ld    bc,(chrloc)  
	ld	a,b
	cp	24
	jr	c,noscroll2
	call	scrollup
	ld	bc,23*256
	ld  (chrloc),bc
noscroll2:
	  srl   c  
          ld    a,b  
          and   248  
          add   a,64  
          ld    d,a  
          ld    a,b  
          and   7  
          rrca  
          rrca  
          rrca  
          add   a,c  
          ld	e,a		;de = screen posn, hl = character

          ld	b,8
.loop32
          ld	a,(hl)
.invers2 defb	0
          ld	(de),a
          inc	d	;down screen row
          inc	hl
          djnz	loop32
          ld      a,d  
          dec     a
          rrca  
          rrca  
          rrca  
        and 3  
        or  88  
        ld  d,a  
        ld  a,(attr)
        ld  (de),a
        ld	hl,(chrloc)
        inc	l
        inc	l
        jp	posncheck

; Ooops..ain't written this yet!
; We should scroll the screen up one character here
; Blanking the bottom row..
.scrollup
 	push   hl
	ld	a,($dff)
	cp	$17
	jr	nz,ts2068_rom
	call   call_rom3
	defw	3582	;scrollup
     	pop    hl
	ret
.ts2068_rom
	 call   call_rom3
     defw	$939	; TS2068 scrollup
     pop    hl
     ret

; This nastily inefficient table is the code table for the routines
; Done this way for future! Expansion

.code_table
        defw    noop      ; 0 - NUL
        defw    switch    ; 1 - SOH
        defw    setfont32 ; 2
        defw    setudg    ; 3
        defw    noop    ; 4
        defw    noop    ; 5
        defw    noop    ; 6
        defw    noop    ; 7 - BEL
        defw    left    ; 8 - BS
        defw    right   ; 9 - HT
IF STANDARDESCAPECHARS
        defw    cr      ;13 - CR (+NL)
ELSE
        defw    down    ;10 - LF
ENDIF
        defw    up      ;11 - UP
        defw    cls     ;12 = FF (and HOME)
IF STANDARDESCAPECHARS
        defw    down    ;10 - LF
ELSE
        defw    cr      ;13 - CR (+NL)
ENDIF
        defw    noop    ;14
        defw    noop    ;15
        defw    setink     ;16  - ink
        defw    setpaper   ;17  - paper
        defw    setflash   ;18  - flash
        defw    setbright  ;19  - bright
        defw    setinverse ;20  - inverse
        defw    noop    ;21  - over
        defw    setposn ;22
        defw    noop    ;23
        defw    noop    ;24
        defw    noop    ;25
        defw    noop    ;26
        defw    noop    ;27
        defw    noop    ;28
        defw    noop    ;29
        defw    noop    ;30
        defw    noop    ;31

; And now the magic routines

; No operation

.noop
        ret

; Move print position left
.left
        ld      a,l
        and     a
        jr		nz,doleft
        ld		l,63
        jr		up
.doleft
        dec     l
.left2  nop
        ld      (chrloc),hl
        ret

;Move print position right
.right
        ld      a,l
        cp      63
        ret     z
        inc     l
.right2 nop
        ld      (chrloc),hl
        ret

;Move print position up
.up
        ld      a,h
        and     a
        ret     z
        dec     h
        ld      (chrloc),hl
        ret

;Move print position down
.down
        ld      a,h
        cp      23
        ret     z
        inc     h
        ld      (chrloc),hl
        ret

; Clear screen and move to home

.cls
        ld      hl,16384
        ld      de,16385
        ld      bc,6144
        ld      (hl),l
        ldir
        ld	a,(attr)
        ld	(hl),a
        ld	bc,767
        ldir
        ld      hl,0
        ld      (chrloc),hl
        ret

;Move to new line

.cr
        ld      a,h
        cp      23
        jr	nz,cr_1
        call	scrollup
        ld	h,22
.cr_1
        inc     h
        ld      l,0
        ld      (chrloc),hl
        ret

; Set attributes etc
.doinverse
	ld	a,(params)
	ld	b,47	;cpl
	rrca
	jr	c,doinverse1
	ld	b,0	;nop
.doinverse1
	ld	a,b
	ld	(invers1),a
	ld	(invers2),a
	ret


.dobright
	ld	hl,attr
	ld	a,(params)
	rrca
	jr	c,dobright1
	res	6,(hl)
	ret
.dobright1
	set	6,(hl)
	ret


.doflash
	ld	hl,attr
	ld	a,(params)
	rrca
	jr	c,doflash1
	res	7,(hl)
	ret
.doflash1
	set	7,(hl)
	ret

.dopaper
	ld	hl,attr
	ld	a,(hl)	
	and	@11000111
	ld	c,a
	ld	a,(params)
	rlca
	rlca
	rlca
	and	@00111000
	or	c
	ld	(hl),a
	ret
	
.doink
	ld	hl,attr
	ld	a,(hl)
	and	@11111000
	ld	c,a
	ld	a,(params)
	and	7		;doesn't matter what chars were used..
	or	c
	ld	(hl),a
	ret

.dofont	ld	hl,(params)
	ld	(fontaddr+1),hl
	ret

.doudg	ld	hl,(params)
	ld	(udgaddr+1),hl
	ret

.setfont32
	ld	hl,dofont
	ld	a,2
	jr	setparams

.setudg
	ld	hl,doudg
	ld	a,2
	jr 	setparams
	

.setinverse
	ld	hl,doinverse
	jr	setink1
.setbright
	ld	hl,dobright
	jr	setink1
.setflash
	ld	hl,doflash
	jr	setink1
.setpaper
	ld	hl,dopaper
	jr	setink1
.setink	ld	hl,doink
.setink1
	ld	a,1	;number to expect
.setparams
	ld	(flags),a
	ld	(flagrout),hl
	ret

; Set xy position
; Code 22,y,x (as per ZX)

.setposn
        ld      a,2     ;number to expect
        ld      hl,doposn
        jr	setparams

; Setting the position
; We only care 

.doposn
        ld      hl,(params)
        ld	de,$2020
        and	a
        sbc	hl,de
        ld      a,(left2)
        and     a			; are we in 32 columns mode ?
        jr      z,nomult	; if not, do not double
        rl		l
.nomult
        ld      a,h     ;y position
        cp      24
        ret     nc
        bit     6,l     ;is x > 64
        ret     nz
        ld      (chrloc),hl
        ret

; Switch between 64 & 32 column text

.switch
	ld	a,1
	ld	(flags),a
	ld	hl,doswitch
	ld	(flagrout),hl
	ret

.doswitch
	xor	a
	ld	(left2),a
	ld	(right2),a
	ld	a,(params)
	ld	hl,print64
	ld	(print1+1),hl
	cp	64
	ret	z
	ld	a,$2d
	ld	(left2),a
	dec	a
	ld	(right2),a
	ld	hl,print32
	ld	(print1+1),hl
	ret




	SECTION	bss_clib
; Variables
; Because we're on a Spectrum we can scatter statics all over the place!

.chrloc
        defw    0

; Attribute to use
;.attr	defb	56

; Flags..used for incoming bit sequences
.flags
        defb    0

; Routine to jump to when we have all the parameters

.flagrout
        defw    0

; Buffer for reading in parameters - 5 should be enuff ATM?

.params
        defs    5


	SECTION	rodata_clib
; The font

.font
        BINARY  "stdio/spectrum/font64.bin"

