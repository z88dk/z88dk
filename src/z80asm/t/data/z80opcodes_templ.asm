;------------------------------------------------------------------------------
; Z80 reference opcodes parsed by build_z80opcodes.pl
; 		z80asm-code ;; z80pack-code ;; code ;; code
; The code is assembled by z80pack and transformed into code and binary form:
;		z80asm-code ;; addr hh hh hh hh
; This is file used to test the assembly of z80asm
; 
; Copyright (C) Paulo Custodio, 2011-2014
; 
; $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/data/Attic/z80opcodes_templ.asm,v 1.5 2014-05-05 21:40:25 pauloscustodio Exp $
;
;------------------------------------------------------------------------------

	org	0100h

	defc IND =	05h						;;IND	equ	05h 
	defc M   =	10h						;;M		equ	10h 
	defc N   =	20h						;;N		equ	20h 
	defc NN  =  30h						;;NN	equ 30h 
	defc DIS =	40h						;;DIS	equ	40h 
	
;------------------------------------------------------------------------------
; Value ranges
;------------------------------------------------------------------------------

										; z80pack does not allow negative indexes
	ld	a,(ix-128)						;; 	defb 0DDh ;; ld a,(hl) ;; defb -128
	ld	a,(iy-128)						;; 	defb 0FDh ;; ld a,(hl) ;; defb -128
	ld	a,(ix)							;; 	defb 0DDh ;; ld a,(hl) ;; defb 0
	ld	a,(iy)							;; 	defb 0FDh ;; ld a,(hl) ;; defb 0
	ld	a,({ix iy}+{0 127})

	ld	a,{-128 0 255}
	ld 	bc,{-32768 -1 0 65535}
	jp	{-32768 -1 0 65535}

;------------------------------------------------------------------------------
; Regression tests
;------------------------------------------------------------------------------

; BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
bug0047a:
	defw	ASMPC,ASMPC,ASMPC			;;	defw bug0047a,bug0047a,bug0047a
bug0047b:	
	jp		ASMPC						;;	jp bug0047b

;------------------------------------------------------------------------------
; IF ELSE ENDIF
;------------------------------------------------------------------------------
	if	1								;;
	  defb 1							;;	defb 1
	  if 1								;;
		defb 2							;;	defb 2
	  else								;;
	    defb 3							;;
	  endif								;;
	else								;;
	  defb 4							;;
	  if 1								;;
	    defb 5							;;
      else								;;
	    defb 6							;;
	  endif								;;
	endif								;;

	if 0								;;
	  defb 7							;;
	endif								;;
	
	if 1								;;
	  defb 8							;; 	defb 8
	endif								;;
	
	if 0								;;
	  defb 9							;;
	else								;;
	  defb 10							;;	defb 10
	endif								;;
	
	if undefined						;;
	  defb 11							;;
	else								;;
	  defb 12							;;	defb 12
	endif								;;

	if undefined | 1					;;
	  defb 13							;;	defb 13
	else								;;
	  defb 14							;;
	endif								;;

;------------------------------------------------------------------------------
; Z88DK specific opcodes
;------------------------------------------------------------------------------
	call_oz	1							;; 	rst 20h ;; defb 1
	call_oz	255							;; 	rst 20h ;; defb 255
	call_oz	256							;; 	rst 20h ;; defw 256
	call_oz	65535						;; 	rst 20h ;; defw 65535

	call_pkg 0							;; 	rst 08h ;; defw 0
	call_pkg 1							;; 	rst 08h ;; defw 1
	call_pkg 65535						;; 	rst 08h ;; defw 65535
	
	fpp 1								;; 	rst 18h ;; defb 1
	fpp 254								;; 	rst 18h ;; defb 254

	invoke 0							;;	call 0
	invoke 1							;;	call 1
	invoke 65535						;;	call 65535
	
;------------------------------------------------------------------------------
; 8 bit load group
;------------------------------------------------------------------------------

	ld	{b c d e h l a},{b c d e h l a}
	ld	{b c d e h l a},N

IF !RABBIT
	ld	{b c d e ixh ixl a},{ixh ixl}	;;	defb 0DDh ;; ld	{1-ix},{2-ix}
	ld	{ixh ixl},{b c d e ixh ixl a}	;;	defb 0DDh ;; ld	{1-ix},{2-ix}
	ld	{ixh ixl},N						;;	defb 0DDh ;; ld {1-ix},N
	
	ld	{b c d e iyh iyl a},{iyh iyl}	;;	defb 0FDh ;; ld	{1-iy},{2-iy}
	ld	{iyh iyl},{b c d e iyh iyl a}	;;	defb 0FDh ;; ld	{1-iy},{2-iy}
	ld	{iyh iyl},N						;;	defb 0FDh ;; ld {1-iy},N
ENDIF

	ld	{b c d e h l a},(hl)
;	ldi	{b c d e h l a},(hl)			;; 	ld	{1},(hl) ;; inc hl
;	ldd	{b c d e h l a},(hl)			;; 	ld	{1},(hl) ;; dec hl

	ld	{b c d e h l a},(ix+DIS)
;	ldi	{b c d e h l a},(ix+DIS)		;;	ld	{1},(ix+DIS) ;; inc ix
;	ldd	{b c d e h l a},(ix+DIS)		;;	ld	{1},(ix+DIS) ;; dec ix

	ld	{b c d e h l a},(iy+DIS)
;	ldi	{b c d e h l a},(iy+DIS)		;;	ld	{1},(iy+DIS) ;; inc iy
;	ldd	{b c d e h l a},(iy+DIS)		;;	ld	{1},(iy+DIS) ;; dec iy

	ld	(hl),{b c d e h l a}
;	ldi	(hl),{b c d e h l a}			;; 	ld	(hl),{1} ;; inc hl
;	ldd	(hl),{b c d e h l a}			;; 	ld	(hl),{1} ;; dec hl

	ld	(ix+DIS),{b c d e h l a}
;	ldi	(ix+DIS),{b c d e h l a}		;;	ld	(ix+DIS),{1} ;; inc ix
;	ldd	(ix+DIS),{b c d e h l a}		;;	ld	(ix+DIS),{1} ;; dec ix

	ld	(iy+DIS),{b c d e h l a}
;	ldi	(iy+DIS),{b c d e h l a}		;;	ld	(iy+DIS),{1} ;; inc iy
;	ldd	(iy+DIS),{b c d e h l a}		;;	ld	(iy+DIS),{1} ;; dec iy

	ld	(hl),N
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

	ld	(ix+DIS),N
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

	ld	(iy+DIS),N
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

	ld	a,({bc de})
;	ldi	a,({bc de})						;;	ld	a,({1}) ;; inc {1}
;	ldd	a,({bc de})						;;	ld	a,({1}) ;; dec {1}

	ld	({bc de}),a
;	ldi	({bc de}),a						;;	ld	({1}),a ;; inc {1}
;	ldd	({bc de}),a						;;	ld	({1}),a ;; dec {1}

	ld	a,(NN)
	ld	(NN),a

IF !RABBIT
	ld	a,{i r}
	ld	{i r},a
ELSE
 	ld	a,iir							;; 	ld	a,i
 	ld	a,eir							;; 	ld	a,r
 	ld	iir,a							;; 	ld	i,a
 	ld	eir,a							;; 	ld	r,a
ENDIF

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

	ld	{bc de hl ix iy sp},NN
	ld	{bc de hl ix iy sp},(NN)
	ld	(NN),{bc de hl ix iy sp}
	ld	sp,{hl ix iy}
	push {bc de hl ix iy af}
	pop  {bc de hl ix iy af}

;	ld	{bc  de  hl},{bc  de  hl}	=}      0x40+{<1:3>}+{<2>}      0x49+{<1:3>}+{<2>}
;	ld	{bc  de  },ix				=} 0xDD 0x44+{<1:3>}     0xDD 0x4D+{<1:3>}
;	ld	{bc  de  },iy				=} 0xFD 0x44+{<1:3>}     0xFD 0x4D+{<1:3>}
;	
;	ld	{bc  de  },(hl)				=}      0x4E+{<1:3>} 0x23     0x46+{<1:3>} 0x2B
;	ldi	{bc  de  },(hl)				=}      0x4E+{<1:3>} 0x23     0x46+{<1:3>} 0x23
;	
;	ld	{bc  de  hl},(ix+DIS)		=} 0xDD 0x4E+{<1:3>} DIS           0xDD 0x46+{<1:3>} DIS+1
;	ldi	{bc  de  hl},(ix+DIS)		=} 0xDD 0x4E+{<1:3>} DIS 0xDD 0x23 0xDD 0x46+{<1:3>} DIS 0xDD 0x23 
;	
;	ld	{bc  de  hl},(iy+DIS)		=} 0xFD 0x4E+{<1:3>} DIS           0xFD 0x46+{<1:3>} DIS+1
;	ldi	{bc  de  hl},(iy+DIS)		=} 0xFD 0x4E+{<1:3>} DIS 0xFD 0x23 0xFD 0x46+{<1:3>} DIS 0xFD 0x23
;	
;	ld 	(hl),{bc  de}				=}      0x71+{<2>} 0x23     0x70+{<2>} 0x2B
;	ldi	(hl),{bc  de}				=}      0x71+{<2>} 0x23     0x70+{<2>} 0x23
;	
;	ld 	(ix+DIS),{bc  de  hl}		=} 0xDD 0x71+{<2>} DIS           0xDD 0x70+{<2>} DIS+1
;	ldi	(ix+DIS),{bc  de  hl}		=} 0xDD 0x71+{<2>} DIS 0xDD 0x23 0xDD 0x70+{<2>} DIS 0xDD 0x23
;	
;	ld 	(iy+DIS),{bc  de  hl}		=} 0xFD 0x71+{<2>} DIS 0xFD 0x70+{<2>} DIS+1
;	ldi	(iy+DIS),{bc  de  hl}		=} 0xFD 0x71+{<2>} DIS 0xFD 0x23 0xFD 0x70+{<2>} DIS 0xFD 0x23
;	
;	ld 	hl,ix						=} 0xDD 0xE5 0xE1
;	ld 	hl,iy						=} 0xFD 0xE5 0xE1
;	
;	ld	ix,{bc  de  }				=} 0xDD 0x69+{<2>}       0xDD 0x60+{<2>}
;	ld	iy,{bc  de  }				=} 0xFD 0x69+{<2>}       0xFD 0x60+{<2>}
;	
;	ld ix,hl						=} 0xE5 0xDD 0xE1
;	ld iy,hl						=} 0xE5 0xFD 0xE1
;	
;	ld ix,ix						=} 0xDD 0x6D 0xDD 0x64
;	ld ix,iy						=} 0xFD 0xE5 0xDD 0xE1
;	
;	ld iy,iy						=} 0xFD 0x6D 0xFD 0x64
;	ld iy,ix						=} 0xDD 0xE5 0xFD 0xE1


;------------------------------------------------------------------------------
; Exchange, block transfer, search group
;------------------------------------------------------------------------------

	ex	de,hl
	ex	af,af							;;		ex	af,af'
	ex	af,af'
	exx
	
IF !RABBIT
	ex	(sp),hl
ELSE
	ex	(sp),hl							;;	defb 0EDh, 054h
ENDIF
	ex	(sp),{ix iy}

	ldi
	ldir
	ldd
	lddr

IF !RABBIT
	cpi
	cpir
	cpd	
	cpdr
ELSE
	cpi									;;	call rcmx_cpi
	cpir								;;	call rcmx_cpir
	cpd									;;	call rcmx_cpd
	cpdr								;;	call rcmx_cpdr
ENDIF

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

	{add adc sbc}       a,{b c d e h l a (hl) (ix+DIS) (iy+DIS) N}
	{add adc sbc}         {b c d e h l a (hl) (ix+DIS) (iy+DIS) N}	;; {1} a,{2}
	
	{sub and xor or cp}	  {b c d e h l a (hl) (ix+DIS) (iy+DIS) N}
	{sub and xor or cp}	a,{b c d e h l a (hl) (ix+DIS) (iy+DIS) N}	;; {1}   {2}
	
	{inc dec}             {b c d e h l a (hl) (ix+DIS) (iy+DIS)}
	
IF !RABBIT
	{add adc sbc} a,{ixh ixl}				;;	defb 0DDh ;; {1} a,{2-ix}
	{add adc sbc} a,{iyh iyl}				;;	defb 0FDh ;; {1} a,{2-iy}
	{sub and xor or cp inc dec} {ixh ixl}	;;	defb 0DDh ;; {1} {2-ix}
	{sub and xor or cp inc dec} {iyh iyl}	;;	defb 0FDh ;; {1} {2-iy}
ENDIF

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

	add hl,{bc de hl sp}
	add ix,{bc de ix sp}
	add iy,{bc de iy sp}

	{sbc adc} hl,{bc de hl sp}
;	sub       hl,{bc de hl sp}						=} 0xB7 0xED 0x42+{<2:4>}

	{inc dec} {bc de hl ix iy sp}

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

	{rlca rrca rla rra}

	{rlc rrc rl rr sla sra srl} {b c d e h l a (hl) (ix+DIS) (iy+DIS)}
;	{rlc rrc rl rr sla sra srl} (ix+DIS),{b c d e h l a}	=} 0xDD 0xCB DIS 0x00+{<0:3}+{<2}
;	{rlc rrc rl rr sla sra srl} (iy+DIS),{b c d e h l a}	=} 0xFD 0xCB DIS 0x00+{<0:3}+{<2}
;	{sll sli} ...

IF !RABBIT
	rld
	rrd
ELSE
	rld									;;	call rcmx_rld
	rrd									;;	call rcmx_rrd
ENDIF

;	# rotate 16 bits
;
;	rl {bc  de  hl}					=} 0xCB 0x11+{<1} 0xCB 0x10+{<1}
;	rr {bc  de  hl}					=} 0xCB 0x18+{<1} 0xCB 0x19+{<1}
;
;	sla hl							=} 0x29			# special case: add hl,hl
;	sla {bc  de  hl}				=} 0xCB 0x21+{<1} 0xCB 0x10+{<1}
;	sll {bc  de  hl}				=} 0xCB 0x31+{<1} 0xCB 0x10+{<1}
;	sli {bc  de  hl}				=} 0xCB 0x31+{<1} 0xCB 0x10+{<1}
;
;	sra {bc  de  hl}				=} 0xCB 0x28+{<1} 0xCB 0x19+{<1}
;	srl {bc  de  hl}				=} 0xCB 0x38+{<1} 0xCB 0x19+{<1}

;------------------------------------------------------------------------------
; General purpose arithmetic and CPU control group
;------------------------------------------------------------------------------

	cpl 	
	neg 	
	ccf 	
	scf 	
	nop 	

IF !RABBIT
	daa 	
	di 		
	ei	 	
	halt	
	im	0 	
	im	1 	
	im	2 	
ENDIF

;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

	{bit res set} {0 1 2 3 4 5 6 7},{b c d e h l a (hl) (ix+DIS) (iy+DIS)}
;	{res set}     {0 1 2 3 4 5 6 7},(ix+DIS),{b c d e h l  a}	=} 0xDD 0xCB DIS {<0:6}+{<1:3}+{<3}
;	{res set}     {0 1 2 3 4 5 6 7},(iy+DIS),{b c d e h l  a}	=} 0xFD 0xCB DIS {<0:6}+{<1:3}+{<3}

;------------------------------------------------------------------------------
; Jump Group
;------------------------------------------------------------------------------
	jp {NN (hl) (ix) (iy)}	
	jp {nz z nc c po pe p m},NN

										; max forward jump
	jr	 jr2
	jr	 jr2
	jr	 jr2
	
	djnz ASMPC							;;	defb 10h, 0FEh
	djnz ASMPC+0x81						;;	defb 10h, 07Fh
	jr	 ASMPC							;;	defb 18h, 0FEh
	jr	 ASMPC-0x7E						;;	defb 18h, 080h
	
	djnz jr1		; 10 00       
jr1:
	jr jr1
	djnz jr1
	jr {nz z nc c},jr1
		
	defs 127-26, 0FFh					;;	defs 127-26
jr2:
	defs 122, 0FFh						;; 	defs 122
	jr	 jr2
	jr	 jr2
										; max backward jump - z80pack does not accept -128
	jr	 jr2							;;	defb 18h, 80h
	

;	jr {po pe p m},NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

	call NN
	ret
	ret {nz z nc c po pe p m}
	reti
;	rst {0 1 2 3 4 5 6 7}


IF !RABBIT
	call {nz z nc c po pe p m},NN
	retn
	rst {00h 08h 10h 18h 20h 28h 30h 38h}
ELSE
	call {nz z nc c},NN					;;	jr {1!},$+5 ;; call NN
	call {po pe p m},NN					;;	jp {1!},$+6 ;; call NN
	rst {        10h 18h 20h 28h     38h}
ENDIF


IF !RABBIT
;------------------------------------------------------------------------------
; Input and Output Group
;------------------------------------------------------------------------------

	in a,(N)
	in {b c d e h l a},(c)
;	in f,(c)

	ini
	inir
	ind
	indr

	out (N),a
	out (c),{b c d e h l a}
;	out (c),0

	outi
	otir
	outd
	otdr
ENDIF

;------------------------------------------------------------------------------
; $Log: z80opcodes_templ.asm,v $
; Revision 1.5  2014-05-05 21:40:25  pauloscustodio
; Move tests of BUG_0011 to bugfixes.t
;
; Revision 1.4  2014/04/28 22:07:03  pauloscustodio
; Extend tests
;
; Revision 1.3  2014/04/26 08:34:18  pauloscustodio
; No RCS keywords in generated files
;
; Revision 1.2  2014/04/26 08:14:01  pauloscustodio
; ws
;
; Revision 1.1  2014/04/25 23:52:17  pauloscustodio
; Rename input file for z80opcodes generation
;
;
