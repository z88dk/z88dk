;------------------------------------------------------------------------------
;     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
;   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
;                ZZZZZ      888           888  0000         0000
;              ZZZZZ        88888888888888888  0000         0000
;            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
;          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
;        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
;      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
;    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
;  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
;
; Input data for tests, to be parsed by build_opcodes.pl
;
; Copyright (C) Paulo Custodio, 2011-2014
;
; $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/build_opcodes.asm,v 1.17 2015-01-11 23:49:25 pauloscustodio Exp $
;------------------------------------------------------------------------------

	org	0100h

	extern ZERO							;;ZERO    equ 0

	defc N   =	20h						;;N		equ	20h 
	defc NN  =  30h						;;NN	equ 30h 
	defc DIS =	40h						;;DIS	equ	40h 

;------------------------------------------------------------------------------
; Value ranges
; z80pack is less permissive than z80asm in out of range
;------------------------------------------------------------------------------

	ldx									;; error: syntax error
	ld									;; error: syntax error
	ld a,1+								;; error: syntax error

; Byte
	ld a,{-128 -1 0 1 127 255}
	ld a,{-129 256}						;; defb 03Eh, {1}	;; warn 2: integer '{1}' out of range

; SignedByte
	ld	a,({ix iy}{-129 +128})			;; defb {1@} ;; ld a,(hl) ;; defb {2}	;; warn 2: integer '{2-+}' out of range
	ld	a,({ix iy}-128)					;; defb {1@} ;; ld a,(hl) ;; defb 080h
	ld	a,({ix iy})						;; defb {1@} ;; ld a,(hl) ;; defb 0
	ld	a,({ix iy}+{0 127})

; Word
	ld bc,{-32768 -1 0 1 32767 65535}
	ld bc,{-32769 65536}				;; warn 2: integer '{1}' out of range

; 32-bit arithmetic, long range is not tested on a 32bit long
	defl 0xFFFFFFFF						;; defw 0FFFFh, 0FFFFh
	defl 0xFFFFFFFF+1					;; defw 0, 0

; call out of range
	call {-32768 -1 0 1 65535}
	call {-32769 65536}					;; warn 2: integer '{1}' out of range

;------------------------------------------------------------------------------
; Strings
;------------------------------------------------------------------------------

	defb 1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,'!'
	defw 1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,'!'
	defm "ABCDEFGHIJKLMNOPQRSTUVWXYZ"	;; defm 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

	defm "								;; error: unclosed quoted string
	defm "hello							;; error: unclosed quoted string

	defb '								;; error: invalid single quoted character
	defb 'x								;; error: invalid single quoted character
	defb ''								;; error: invalid single quoted character
	defb 'he'							;; error: invalid single quoted character

;------------------------------------------------------------------------------
; Expressions
;------------------------------------------------------------------------------

	ld a,'a'
	ld a,"a"							;; error: syntax error

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
ELSE
	ld	{b c d e ixh ixl a},{ixh ixl}	;; error: illegal identifier
	ld	{ixh ixl},{b c d e ixh ixl a}	;; error: illegal identifier
	ld	{ixh ixl},N						;; error: illegal identifier
	
	ld	{b c d e iyh iyl a},{iyh iyl}	;; error: illegal identifier
	ld	{iyh iyl},{b c d e iyh iyl a}	;; error: illegal identifier
	ld	{iyh iyl},N						;; error: illegal identifier
ENDIF

	ld	{b c d e h l a},(hl)
;	ldi	{b c d e h l a},(hl)			;; 	ld	{1},(hl) ;; inc hl
;	ldd	{b c d e h l a},(hl)			;; 	ld	{1},(hl) ;; dec hl

	ld	{b c d e h l a},({ix iy}+DIS)
;	ldi	{b c d e h l a},({ix iy}+DIS)	;;	ld	{1},({2}+DIS) ;; inc {2}
;	ldd	{b c d e h l a},({ix iy}+DIS)	;;	ld	{1},({2}+DIS) ;; dec {2}

	ld	(hl),{b c d e h l a}
;	ldi	(hl),{b c d e h l a}			;; 	ld	(hl),{1} ;; inc hl
;	ldd	(hl),{b c d e h l a}			;; 	ld	(hl),{1} ;; dec hl

	ld	({ix iy}+DIS),{b c d e h l a}
;	ldi	({ix iy}+DIS),{b c d e h l a}	;;	ld	({1}+DIS),{2} ;; inc {1}
;	ldd	({ix iy}+DIS),{b c d e h l a}	;;	ld	({1}+DIS),{2} ;; dec {1}

	ld	(hl),N
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

	ld	({ix iy}+DIS),N
;	ldi	({ix iy}+DIS),N					;;	ld	({1}+DIS),N ;; inc {1}
;	ldd	({ix iy}+DIS),N					;;	ld	({1}+DIS),N ;; dec {1}

	ld	a,({bc de})
;	ldi	a,({bc de})						;;	ld	a,({1}) ;; inc {1}
;	ldd	a,({bc de})						;;	ld	a,({1}) ;; dec {1}

	ld	({bc de}),a
;	ldi	({bc de}),a						;;	ld	({1}),a ;; inc {1}
;	ldd	({bc de}),a						;;	ld	({1}),a ;; dec {1}

	ld	a,(NN)
	ld	(NN),a

	ld ({bc de}),{b c d e h l (hl) (ix+DIS) (iy+DIS) N}	;; error: syntax error

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
	{add adc sbc} a,{ix iy}{h l}		;;	defb {2@} ;; {1} a,{3}
	{add adc sbc}   {ix iy}{h l}		;;	defb {2@} ;; {1} a,{3}
	{sub and xor or cp}   {ix iy}{h l}	;;	defb {2@} ;; {1}   {3}
	{sub and xor or cp} a,{ix iy}{h l}	;;	defb {2@} ;; {1}   {3}
	{inc dec}             {ix iy}{h l}	;;	defb {2@} ;; {1}   {3}
ELSE
	{add adc sbc} a,{ix iy}{h l}		;; error: illegal identifier
	{add adc sbc}   {ix iy}{h l}		;; error: illegal identifier
	{sub and xor or cp}   {ix iy}{h l}	;; error: illegal identifier
	{sub and xor or cp} a,{ix iy}{h l}	;; error: illegal identifier
	{inc dec}             {ix iy}{h l}	;; error: illegal identifier
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
	
	im 	{-1 3}							;; error: integer '{1}' out of range
	im 	undefined						;; error: symbol not defined
ELSE
	{daa di ei halt}					;; error: illegal identifier
	im {0 1 2} 							;; error: illegal identifier
ENDIF

;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

	{bit res set} {0 1 2 3 4 5 6 7},{b c d e h l a (hl) (ix+DIS) (iy+DIS)}
	
	{bit res set} {-1 8},a				;; error: integer '{2}' out of range
	{bit res set} undefined,a			;; error: symbol not defined
	
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
		
	defb 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
	defb 26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50
	defb 51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75
	defb 76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101
	
jr2:
	defb 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
	defb 26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50
	defb 51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75
	defb 76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100
	defb 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122
	
	jr	 jr2
	jr	 jr2
										; max backward jump - z80pack does not accept -128
	jr	 jr2							;;	defb 18h, 80h
	

;	jr {po pe p m},NN
	
	djnz ASMPC-0x7F						;; error 2: integer '-129' out of range
	djnz ASMPC+0x82						;; error 2: integer '128' out of range
	jr ASMPC-0x7F						;; error 2: integer '-129' out of range
	jr ASMPC+0x82						;; error 2: integer '128' out of range
	jr nz,ASMPC-0x7F					;; error 2: integer '-129' out of range
	jr nz,ASMPC+0x82					;; error 2: integer '128' out of range
	jr  z,ASMPC-0x7F					;; error 2: integer '-129' out of range
	jr  z,ASMPC+0x82					;; error 2: integer '128' out of range
	jr nc,ASMPC-0x7F					;; error 2: integer '-129' out of range
	jr nc,ASMPC+0x82					;; error 2: integer '128' out of range
	jr  c,ASMPC-0x7F					;; error 2: integer '-129' out of range
	jr  c,ASMPC+0x82					;; error 2: integer '128' out of range

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
	
	retn								;; error: illegal identifier
	
	rst {        10h 18h 20h 28h     38h}
	rst {00h 08h                 30h    } ;; error: illegal identifier
ENDIF

	rst	undefined		   								;; error: symbol not defined
	rst {-1 1 7 9 15 17 23 25 31 33 39 41 47 49 55 57}	;; error: integer '{1}' out of range

;------------------------------------------------------------------------------
; Input and Output Group
;------------------------------------------------------------------------------

IF !RABBIT
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
ELSE
	in a,(0)							;; error: illegal identifier
	in {b c d e h l a},(c)				;; error: illegal identifier
	{ini inir ind indr}					;; error: illegal identifier
	out (0),a							;; error: illegal identifier
	out (c),{b c d e h l a}				;; error: illegal identifier
	{outi otir outd otdr}				;; error: illegal identifier
ENDIF

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
; IFDEF ELSE ENDIF
;------------------------------------------------------------------------------
	ifdef 								;; error: syntax error
	endif								;;
	
	ifdef 1								;; error: syntax error
	endif								;;

	defc   ifdef_1 = 0					;;
	define ifdef_2						;;

	ifdef ZERO							;;
	  defb 1							;;	defb 1
	else								;;
	  defb 2							;;
	endif								;;
	
	ifdef undefined						;;
	  defb 3							;;
	else								;;
	  defb 4							;;	defb 4
	endif								;;

	ifdef ifdef_1						;;
	  defb 5							;;	defb 5
	else								;;
	  defb 6							;;
	endif								;;
	
	ifdef ifdef_2						;;
	  defb 7							;;	defb 7
	else								;;
	  defb 8							;;
	endif								;;
	
	ifdef ifdef_3						;;
	  defb 9							;;
	else								;;
	  defb 10							;;	defb 10
	endif								;;
	
;------------------------------------------------------------------------------
; IFNDEF ELSE ENDIF
;------------------------------------------------------------------------------
	ifndef 								;; error: syntax error
	endif								;;
	
	ifndef 1								;; error: syntax error
	endif								;;

	defc   ifndef_1 = 0					;;
	define ifndef_2						;;

	ifndef ZERO							;;
	  defb 1							;;
	else								;;
	  defb 2							;;	defb 2
	endif								;;
	
	ifndef undefined					;;
	  defb 3							;;	defb 3
	else								;;
	  defb 4							;;
	endif								;;

	ifndef ifndef_1						;;
	  defb 5							;;
	else								;;
	  defb 6							;;	defb 6
	endif								;;
	
	ifndef ifndef_2						;;
	  defb 7							;;
	else								;;
	  defb 8							;;	defb 8
	endif								;;
	
	ifndef ifndef_3						;;
	  defb 9							;;	defb 9
	else								;;
	  defb 10							;;
	endif								;;
	
;------------------------------------------------------------------------------
; DEFGROUP
;------------------------------------------------------------------------------
	defgroup 							;;	
	{ 									;;
		f0, f1  						;;	
		f2, f3,  						;;	
		f10 = 10,  						;;	
		f11,  							;;	
		f20 = 20, f21					;;	
		rl								;; ; opcode can be used as constant
	} 									;;	
	defb f0,f1,f2,f3,f10,f11,f20,f21,rl	;; defb 0,1,2,3,10,11,20,21,22

	defgroup 							;;	
	{ 									;;
		dg1, dg2 = 3					;;	
		dg3 = 7,						;;
	}			  						;;	
	defb dg1,dg2,dg3					;; defb 0,3,7

	; check with conditional assembly
	if 1								;;	
		defgroup 						;;	
		{ 								;;	
			ff = 1						;;	
		}								;;	
	else								;;	
		defgroup 						;;	
		{								;;	
			ff = 2						;;	
		}								;;	
	endif								;;	
	if 0								;;	
		defgroup 						;;	
		{ 								;;	
			fg = 1						;;	
		}								;;	
	else								;;	
		defgroup 						;;	
		{								;;	
			fg = 2						;;	
		}								;;	
	endif								;;		
	defb ff, fg							;; defb 1, 2

;------------------------------------------------------------------------------
; DEFS
;------------------------------------------------------------------------------
ds:	defs not_defined	; BUG_0007		;; error: symbol not defined
	defs -1								;; error: integer '-1' out of range
	defs 0								;;
	defs 1								;; defb 0
	defs 2								;; defb 0,0
	defs 3								;; defb 0,0,0
	defs 4								;; defb 0,0,0,0
	defs 65537							;; error: integer '65537' out of range
	
	defs 2,not_defined					;; error: symbol not defined
	defs 2,-129							;; error: integer '-129' out of range
	defs 2,-128							;; defb 80h,80h
	defs 2,-127							;; defb 81h,81h
	defs 2,0							;; defb 0,0
	defs 2,255							;; defb 0FFh,0FFh
	defs 2,256							;; error: integer '256' out of range
	
	if 0								;;
		defs 2,0						;;
	else								;;
		defs 2,2						;; defb 2,2
	endif								;;

;------------------------------------------------------------------------------
; DEFVARS
;------------------------------------------------------------------------------
	defc defvars_base = 0x80			;;
	defvars defvars_base				;;
										;;
	{									;;
		df1 ds.b 4;						;; ; df1 = 0x80
		df2 ds.w 2;						;; ; df2 = 0x80 + 4 = 0x84
		df3 ds.p 2;						;; ; df3 = 0x84 + 2*2 = 0x88
		df4 ds.l 2;						;; ; df4 = 0x88 + 2*3 = 0x8E
		df5 							;; ; df5 = 0x8E + 2*4 = 0x96
		rr								;; ; opcode can be used as constant
										;;
	}									;;
	defb df1, df2, df3, df4, df5, rr	;; defb 80h, 84h, 88h, 8Eh, 96h, 96h
	
	defvars 0 {							;;
		df6 ds.b 1						;; ; df6 = 0
		df7 ds.b 1						;; ; df7 = 1
		df8 							;; ; df8 = 2
	}									;;
	defb df6, df7, df8					;; defb 0, 1, 2
	
	defvars -1 ; continue after df5		;;
	{									;;
		df9  ds.b 1						;; ; df9 = 0x96
		df10 ds.b 1						;; ; df10 = 0x97
		df11							;; ; df11 = 0x98
		df12							;; ; df12 = 0x98
	}									;;
	defb df9, df10, df11, df12			;; defb 96h, 97h, 98h, 98h

	defvars 0 {							;;
		df13 ds.b 1						;; ; df13 = 0
		df14 ds.b 1						;; ; df14 = 1
		df15 							;; ; df15 = 2
	}									;;
	defb df13, df14, df15				;; defb 0, 1, 2
	
	defvars -1 ; continue after df12	;;
	{									;;
		df16 ds.b 1						;; ; df16 = 0x98
		df17 ds.b 1						;; ; df17 = 0x99
		df18 ds.b 0						;; ; df18 = 0x9A
		df19							;; ; df19 = 0x9A
	}									;;
	defb df16, df17, df18, df19			;; defb 98h, 99h, 9Ah, 9Ah

	; check with conditional assembly
	if 1								;;
		defvars 0 						;;
		{								;;
			df20 ds.b 1					;;
			df21						;;
		}								;;
	else								;;
		defvars 0						;;
		{								;;
			df20 ds.w 1					;;
			df21						;;
		}								;;
	endif								;;
	defb df20, df21						;; defb 0, 1
	
	if 0								;;
		defvars 0 						;;
		{								;;
			df30 ds.b 1					;;
			df31						;;
		}								;;
	else								;;
		defvars 0						;;
		{								;;
			df30 ds.w 1					;;
			df31						;;
		}								;;
	endif								;;
	defb df30, df31						;; defb 0, 2
	
;------------------------------------------------------------------------------
; Allow labels with names of opcodes
;------------------------------------------------------------------------------

	lib ld								;;

	nop
	jr nop
nop:

IF !RABBIT
	di
	jr di
di:
	ei
	jr ei
ei:
ENDIF

;------------------------------------------------------------------------------
; Test parsing of expressions with parentheses inside parentheses
;------------------------------------------------------------------------------
IF !RABBIT
		out	 N,a						;; error: syntax error
        out  (N),a
        out  ((N)),a
        out  (N+2*(3-3)),a
ENDIF

;------------------------------------------------------------------------------
; Z88DK specific opcodes
;------------------------------------------------------------------------------
	{call_oz oz} {1 255}				;; 	rst 20h ;; defb {2}
	{call_oz oz} {256 65535}			;; 	rst 20h ;; defw {2}
	{call_oz oz} {0 65536}				;; error: integer '{2}' out of range

	call_pkg {0 1 65535}				;; 	rst 08h ;; defw {1}
	call_pkg {-1 65536} 				;; error: integer '{1}' out of range
	
	fpp {1 254}							;; 	rst 18h ;; defb {1}
	fpp {0 255 256}				 		;; error: integer '{1}' out of range

	invoke {0 1 65535}					;;	call {1}
	invoke {-1 65536}			 		;; error: integer '{1}' out of range
