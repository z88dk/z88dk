;------------------------------------------------------------------------------
; Z80 reference opcodes parsed by build_z80opcodes.pl
; 		z80asm-code ;; z80pack-code ;; code ;; code
; The code is assembled by z80pack and transformed into code and binary form:
;		z80asm-code ;; addr hh hh hh hh
; This is file used to test the assembly of z80asm
; 
; Copyright (C) Paulo Custodio, 2011-2014
; 
; $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/data/Attic/z80opcodes.asm,v 1.2 2014-04-25 23:52:17 pauloscustodio Exp $
;
;------------------------------------------------------------------------------

        org  0100h

        defc IND = 05h 
        defc M = 10h 
        defc N = 20h 
        defc NN = 30h 
        defc DIS = 40h 
        
;------------------------------------------------------------------------------
; 8 bit load group
;------------------------------------------------------------------------------

        ld   b,b                        ;=> 0100  40
        ld   c,b                        ;=> 0101  48
        ld   d,b                        ;=> 0102  50
        ld   e,b                        ;=> 0103  58
        ld   h,b                        ;=> 0104  60
        ld   l,b                        ;=> 0105  68
        ld   a,b                        ;=> 0106  78
        ld   b,c                        ;=> 0107  41
        ld   c,c                        ;=> 0108  49
        ld   d,c                        ;=> 0109  51
        ld   e,c                        ;=> 010A  59
        ld   h,c                        ;=> 010B  61
        ld   l,c                        ;=> 010C  69
        ld   a,c                        ;=> 010D  79
        ld   b,d                        ;=> 010E  42
        ld   c,d                        ;=> 010F  4A
        ld   d,d                        ;=> 0110  52
        ld   e,d                        ;=> 0111  5A
        ld   h,d                        ;=> 0112  62
        ld   l,d                        ;=> 0113  6A
        ld   a,d                        ;=> 0114  7A
        ld   b,e                        ;=> 0115  43
        ld   c,e                        ;=> 0116  4B
        ld   d,e                        ;=> 0117  53
        ld   e,e                        ;=> 0118  5B
        ld   h,e                        ;=> 0119  63
        ld   l,e                        ;=> 011A  6B
        ld   a,e                        ;=> 011B  7B
        ld   b,h                        ;=> 011C  44
        ld   c,h                        ;=> 011D  4C
        ld   d,h                        ;=> 011E  54
        ld   e,h                        ;=> 011F  5C
        ld   h,h                        ;=> 0120  64
        ld   l,h                        ;=> 0121  6C
        ld   a,h                        ;=> 0122  7C
        ld   b,l                        ;=> 0123  45
        ld   c,l                        ;=> 0124  4D
        ld   d,l                        ;=> 0125  55
        ld   e,l                        ;=> 0126  5D
        ld   h,l                        ;=> 0127  65
        ld   l,l                        ;=> 0128  6D
        ld   a,l                        ;=> 0129  7D
        ld   b,a                        ;=> 012A  47
        ld   c,a                        ;=> 012B  4F
        ld   d,a                        ;=> 012C  57
        ld   e,a                        ;=> 012D  5F
        ld   h,a                        ;=> 012E  67
        ld   l,a                        ;=> 012F  6F
        ld   a,a                        ;=> 0130  7F
        ld   b,N                        ;=> 0131  06 20
        ld   c,N                        ;=> 0133  0E 20
        ld   d,N                        ;=> 0135  16 20
        ld   e,N                        ;=> 0137  1E 20
        ld   h,N                        ;=> 0139  26 20
        ld   l,N                        ;=> 013B  2E 20
        ld   a,N                        ;=> 013D  3E 20

        ld   b,ixh                      ;=> 013F  DD 44
        ld   c,ixh                      ;=> 0141  DD 4C
        ld   d,ixh                      ;=> 0143  DD 54
        ld   e,ixh                      ;=> 0145  DD 5C
        ld   ixh,ixh                    ;=> 0147  DD 64
        ld   ixl,ixh                    ;=> 0149  DD 6C
        ld   a,ixh                      ;=> 014B  DD 7C
        ld   b,ixl                      ;=> 014D  DD 45
        ld   c,ixl                      ;=> 014F  DD 4D
        ld   d,ixl                      ;=> 0151  DD 55
        ld   e,ixl                      ;=> 0153  DD 5D
        ld   ixh,ixl                    ;=> 0155  DD 65
        ld   ixl,ixl                    ;=> 0157  DD 6D
        ld   a,ixl                      ;=> 0159  DD 7D
        ld   ixh,b                      ;=> 015B  DD 60
        ld   ixl,b                      ;=> 015D  DD 68
        ld   ixh,c                      ;=> 015F  DD 61
        ld   ixl,c                      ;=> 0161  DD 69
        ld   ixh,d                      ;=> 0163  DD 62
        ld   ixl,d                      ;=> 0165  DD 6A
        ld   ixh,e                      ;=> 0167  DD 63
        ld   ixl,e                      ;=> 0169  DD 6B
        ld   ixh,ixh                    ;=> 016B  DD 64
        ld   ixl,ixh                    ;=> 016D  DD 6C
        ld   ixh,ixl                    ;=> 016F  DD 65
        ld   ixl,ixl                    ;=> 0171  DD 6D
        ld   ixh,a                      ;=> 0173  DD 67
        ld   ixl,a                      ;=> 0175  DD 6F
        ld   ixh,N                      ;=> 0177  DD 26 20
        ld   ixl,N                      ;=> 017A  DD 2E 20
        
        ld   b,iyh                      ;=> 017D  FD 44
        ld   c,iyh                      ;=> 017F  FD 4C
        ld   d,iyh                      ;=> 0181  FD 54
        ld   e,iyh                      ;=> 0183  FD 5C
        ld   iyh,iyh                    ;=> 0185  FD 64
        ld   iyl,iyh                    ;=> 0187  FD 6C
        ld   a,iyh                      ;=> 0189  FD 7C
        ld   b,iyl                      ;=> 018B  FD 45
        ld   c,iyl                      ;=> 018D  FD 4D
        ld   d,iyl                      ;=> 018F  FD 55
        ld   e,iyl                      ;=> 0191  FD 5D
        ld   iyh,iyl                    ;=> 0193  FD 65
        ld   iyl,iyl                    ;=> 0195  FD 6D
        ld   a,iyl                      ;=> 0197  FD 7D
        ld   iyh,b                      ;=> 0199  FD 60
        ld   iyl,b                      ;=> 019B  FD 68
        ld   iyh,c                      ;=> 019D  FD 61
        ld   iyl,c                      ;=> 019F  FD 69
        ld   iyh,d                      ;=> 01A1  FD 62
        ld   iyl,d                      ;=> 01A3  FD 6A
        ld   iyh,e                      ;=> 01A5  FD 63
        ld   iyl,e                      ;=> 01A7  FD 6B
        ld   iyh,iyh                    ;=> 01A9  FD 64
        ld   iyl,iyh                    ;=> 01AB  FD 6C
        ld   iyh,iyl                    ;=> 01AD  FD 65
        ld   iyl,iyl                    ;=> 01AF  FD 6D
        ld   iyh,a                      ;=> 01B1  FD 67
        ld   iyl,a                      ;=> 01B3  FD 6F
        ld   iyh,N                      ;=> 01B5  FD 26 20
        ld   iyl,N                      ;=> 01B8  FD 2E 20

        ld   b,(hl)                     ;=> 01BB  46
        ld   c,(hl)                     ;=> 01BC  4E
        ld   d,(hl)                     ;=> 01BD  56
        ld   e,(hl)                     ;=> 01BE  5E
        ld   h,(hl)                     ;=> 01BF  66
        ld   l,(hl)                     ;=> 01C0  6E
        ld   a,(hl)                     ;=> 01C1  7E
;	ldi	b,(hl)			;; 	ld	b,(hl) ;; inc hl
;	ldi	c,(hl)			;; 	ld	c,(hl) ;; inc hl
;	ldi	d,(hl)			;; 	ld	d,(hl) ;; inc hl
;	ldi	e,(hl)			;; 	ld	e,(hl) ;; inc hl
;	ldi	h,(hl)			;; 	ld	h,(hl) ;; inc hl
;	ldi	l,(hl)			;; 	ld	l,(hl) ;; inc hl
;	ldi	a,(hl)			;; 	ld	a,(hl) ;; inc hl
;	ldd	b,(hl)			;; 	ld	b,(hl) ;; dec hl
;	ldd	c,(hl)			;; 	ld	c,(hl) ;; dec hl
;	ldd	d,(hl)			;; 	ld	d,(hl) ;; dec hl
;	ldd	e,(hl)			;; 	ld	e,(hl) ;; dec hl
;	ldd	h,(hl)			;; 	ld	h,(hl) ;; dec hl
;	ldd	l,(hl)			;; 	ld	l,(hl) ;; dec hl
;	ldd	a,(hl)			;; 	ld	a,(hl) ;; dec hl

        ld   b,(ix+DIS)                 ;=> 01C2  DD 46 40
        ld   c,(ix+DIS)                 ;=> 01C5  DD 4E 40
        ld   d,(ix+DIS)                 ;=> 01C8  DD 56 40
        ld   e,(ix+DIS)                 ;=> 01CB  DD 5E 40
        ld   h,(ix+DIS)                 ;=> 01CE  DD 66 40
        ld   l,(ix+DIS)                 ;=> 01D1  DD 6E 40
        ld   a,(ix+DIS)                 ;=> 01D4  DD 7E 40
;	ldi	b,(ix+DIS)		;;	ld	b,(ix+DIS) ;; inc ix
;	ldi	c,(ix+DIS)		;;	ld	c,(ix+DIS) ;; inc ix
;	ldi	d,(ix+DIS)		;;	ld	d,(ix+DIS) ;; inc ix
;	ldi	e,(ix+DIS)		;;	ld	e,(ix+DIS) ;; inc ix
;	ldi	h,(ix+DIS)		;;	ld	h,(ix+DIS) ;; inc ix
;	ldi	l,(ix+DIS)		;;	ld	l,(ix+DIS) ;; inc ix
;	ldi	a,(ix+DIS)		;;	ld	a,(ix+DIS) ;; inc ix
;	ldd	b,(ix+DIS)		;;	ld	b,(ix+DIS) ;; dec ix
;	ldd	c,(ix+DIS)		;;	ld	c,(ix+DIS) ;; dec ix
;	ldd	d,(ix+DIS)		;;	ld	d,(ix+DIS) ;; dec ix
;	ldd	e,(ix+DIS)		;;	ld	e,(ix+DIS) ;; dec ix
;	ldd	h,(ix+DIS)		;;	ld	h,(ix+DIS) ;; dec ix
;	ldd	l,(ix+DIS)		;;	ld	l,(ix+DIS) ;; dec ix
;	ldd	a,(ix+DIS)		;;	ld	a,(ix+DIS) ;; dec ix

        ld   b,(iy+DIS)                 ;=> 01D7  FD 46 40
        ld   c,(iy+DIS)                 ;=> 01DA  FD 4E 40
        ld   d,(iy+DIS)                 ;=> 01DD  FD 56 40
        ld   e,(iy+DIS)                 ;=> 01E0  FD 5E 40
        ld   h,(iy+DIS)                 ;=> 01E3  FD 66 40
        ld   l,(iy+DIS)                 ;=> 01E6  FD 6E 40
        ld   a,(iy+DIS)                 ;=> 01E9  FD 7E 40
;	ldi	b,(iy+DIS)		;;	ld	b,(iy+DIS) ;; inc iy
;	ldi	c,(iy+DIS)		;;	ld	c,(iy+DIS) ;; inc iy
;	ldi	d,(iy+DIS)		;;	ld	d,(iy+DIS) ;; inc iy
;	ldi	e,(iy+DIS)		;;	ld	e,(iy+DIS) ;; inc iy
;	ldi	h,(iy+DIS)		;;	ld	h,(iy+DIS) ;; inc iy
;	ldi	l,(iy+DIS)		;;	ld	l,(iy+DIS) ;; inc iy
;	ldi	a,(iy+DIS)		;;	ld	a,(iy+DIS) ;; inc iy
;	ldd	b,(iy+DIS)		;;	ld	b,(iy+DIS) ;; dec iy
;	ldd	c,(iy+DIS)		;;	ld	c,(iy+DIS) ;; dec iy
;	ldd	d,(iy+DIS)		;;	ld	d,(iy+DIS) ;; dec iy
;	ldd	e,(iy+DIS)		;;	ld	e,(iy+DIS) ;; dec iy
;	ldd	h,(iy+DIS)		;;	ld	h,(iy+DIS) ;; dec iy
;	ldd	l,(iy+DIS)		;;	ld	l,(iy+DIS) ;; dec iy
;	ldd	a,(iy+DIS)		;;	ld	a,(iy+DIS) ;; dec iy

        ld   (hl),b                     ;=> 01EC  70
        ld   (hl),c                     ;=> 01ED  71
        ld   (hl),d                     ;=> 01EE  72
        ld   (hl),e                     ;=> 01EF  73
        ld   (hl),h                     ;=> 01F0  74
        ld   (hl),l                     ;=> 01F1  75
        ld   (hl),a                     ;=> 01F2  77
;	ldi	(hl),b			;; 	ld	(hl),b ;; inc hl
;	ldi	(hl),c			;; 	ld	(hl),c ;; inc hl
;	ldi	(hl),d			;; 	ld	(hl),d ;; inc hl
;	ldi	(hl),e			;; 	ld	(hl),e ;; inc hl
;	ldi	(hl),h			;; 	ld	(hl),h ;; inc hl
;	ldi	(hl),l			;; 	ld	(hl),l ;; inc hl
;	ldi	(hl),a			;; 	ld	(hl),a ;; inc hl
;	ldd	(hl),b			;; 	ld	(hl),b ;; dec hl
;	ldd	(hl),c			;; 	ld	(hl),c ;; dec hl
;	ldd	(hl),d			;; 	ld	(hl),d ;; dec hl
;	ldd	(hl),e			;; 	ld	(hl),e ;; dec hl
;	ldd	(hl),h			;; 	ld	(hl),h ;; dec hl
;	ldd	(hl),l			;; 	ld	(hl),l ;; dec hl
;	ldd	(hl),a			;; 	ld	(hl),a ;; dec hl

        ld   (ix+DIS),b                 ;=> 01F3  DD 70 40
        ld   (ix+DIS),c                 ;=> 01F6  DD 71 40
        ld   (ix+DIS),d                 ;=> 01F9  DD 72 40
        ld   (ix+DIS),e                 ;=> 01FC  DD 73 40
        ld   (ix+DIS),h                 ;=> 01FF  DD 74 40
        ld   (ix+DIS),l                 ;=> 0202  DD 75 40
        ld   (ix+DIS),a                 ;=> 0205  DD 77 40
;	ldi	(ix+DIS),b		;;	ld	(ix+DIS),b ;; inc ix
;	ldi	(ix+DIS),c		;;	ld	(ix+DIS),c ;; inc ix
;	ldi	(ix+DIS),d		;;	ld	(ix+DIS),d ;; inc ix
;	ldi	(ix+DIS),e		;;	ld	(ix+DIS),e ;; inc ix
;	ldi	(ix+DIS),h		;;	ld	(ix+DIS),h ;; inc ix
;	ldi	(ix+DIS),l		;;	ld	(ix+DIS),l ;; inc ix
;	ldi	(ix+DIS),a		;;	ld	(ix+DIS),a ;; inc ix
;	ldd	(ix+DIS),b		;;	ld	(ix+DIS),b ;; dec ix
;	ldd	(ix+DIS),c		;;	ld	(ix+DIS),c ;; dec ix
;	ldd	(ix+DIS),d		;;	ld	(ix+DIS),d ;; dec ix
;	ldd	(ix+DIS),e		;;	ld	(ix+DIS),e ;; dec ix
;	ldd	(ix+DIS),h		;;	ld	(ix+DIS),h ;; dec ix
;	ldd	(ix+DIS),l		;;	ld	(ix+DIS),l ;; dec ix
;	ldd	(ix+DIS),a		;;	ld	(ix+DIS),a ;; dec ix

        ld   (iy+DIS),b                 ;=> 0208  FD 70 40
        ld   (iy+DIS),c                 ;=> 020B  FD 71 40
        ld   (iy+DIS),d                 ;=> 020E  FD 72 40
        ld   (iy+DIS),e                 ;=> 0211  FD 73 40
        ld   (iy+DIS),h                 ;=> 0214  FD 74 40
        ld   (iy+DIS),l                 ;=> 0217  FD 75 40
        ld   (iy+DIS),a                 ;=> 021A  FD 77 40
;	ldi	(iy+DIS),b		;;	ld	(iy+DIS),b ;; inc iy
;	ldi	(iy+DIS),c		;;	ld	(iy+DIS),c ;; inc iy
;	ldi	(iy+DIS),d		;;	ld	(iy+DIS),d ;; inc iy
;	ldi	(iy+DIS),e		;;	ld	(iy+DIS),e ;; inc iy
;	ldi	(iy+DIS),h		;;	ld	(iy+DIS),h ;; inc iy
;	ldi	(iy+DIS),l		;;	ld	(iy+DIS),l ;; inc iy
;	ldi	(iy+DIS),a		;;	ld	(iy+DIS),a ;; inc iy
;	ldd	(iy+DIS),b		;;	ld	(iy+DIS),b ;; dec iy
;	ldd	(iy+DIS),c		;;	ld	(iy+DIS),c ;; dec iy
;	ldd	(iy+DIS),d		;;	ld	(iy+DIS),d ;; dec iy
;	ldd	(iy+DIS),e		;;	ld	(iy+DIS),e ;; dec iy
;	ldd	(iy+DIS),h		;;	ld	(iy+DIS),h ;; dec iy
;	ldd	(iy+DIS),l		;;	ld	(iy+DIS),l ;; dec iy
;	ldd	(iy+DIS),a		;;	ld	(iy+DIS),a ;; dec iy

        ld   (hl),N                     ;=> 021D  36 20
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

        ld   (ix+DIS),N                 ;=> 021F  DD 36 40 20
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

        ld   (iy+DIS),N                 ;=> 0223  FD 36 40 20
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

        ld   a,(bc)                     ;=> 0227  0A
        ld   a,(de)                     ;=> 0228  1A
;	ldi	a,(bc)						;;	ld	a,(bc) ;; inc bc
;	ldi	a,(de)						;;	ld	a,(de) ;; inc de
;	ldd	a,(bc)						;;	ld	a,(bc) ;; dec bc
;	ldd	a,(de)						;;	ld	a,(de) ;; dec de

        ld   (bc),a                     ;=> 0229  02
        ld   (de),a                     ;=> 022A  12
;	ldi	(bc),a						;;	ld	(bc),a ;; inc bc
;	ldi	(de),a						;;	ld	(de),a ;; inc de
;	ldd	(bc),a						;;	ld	(bc),a ;; dec bc
;	ldd	(de),a						;;	ld	(de),a ;; dec de

        ld   a,(NN)                     ;=> 022B  3A 30 00
        ld   (NN),a                     ;=> 022E  32 30 00

        ld   a,i                        ;=> 0231  ED 57
        ld   a,r                        ;=> 0233  ED 5F
        ld   i,a                        ;=> 0235  ED 47
        ld   r,a                        ;=> 0237  ED 4F

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

        ld   bc,NN                      ;=> 0239  01 30 00
        ld   de,NN                      ;=> 023C  11 30 00
        ld   hl,NN                      ;=> 023F  21 30 00
        ld   ix,NN                      ;=> 0242  DD 21 30 00
        ld   iy,NN                      ;=> 0246  FD 21 30 00
        ld   sp,NN                      ;=> 024A  31 30 00
        ld   bc,(NN)                    ;=> 024D  ED 4B 30 00
        ld   de,(NN)                    ;=> 0251  ED 5B 30 00
        ld   hl,(NN)                    ;=> 0255  2A 30 00
        ld   ix,(NN)                    ;=> 0258  DD 2A 30 00
        ld   iy,(NN)                    ;=> 025C  FD 2A 30 00
        ld   sp,(NN)                    ;=> 0260  ED 7B 30 00
        ld   (NN),bc                    ;=> 0264  ED 43 30 00
        ld   (NN),de                    ;=> 0268  ED 53 30 00
        ld   (NN),hl                    ;=> 026C  22 30 00
        ld   (NN),ix                    ;=> 026F  DD 22 30 00
        ld   (NN),iy                    ;=> 0273  FD 22 30 00
        ld   (NN),sp                    ;=> 0277  ED 73 30 00
        ld   sp,hl                      ;=> 027B  F9
        ld   sp,ix                      ;=> 027C  DD F9
        ld   sp,iy                      ;=> 027E  FD F9
        push bc                         ;=> 0280  C5
        push de                         ;=> 0281  D5
        push hl                         ;=> 0282  E5
        push ix                         ;=> 0283  DD E5
        push iy                         ;=> 0285  FD E5
        push af                         ;=> 0287  F5
        pop  bc                         ;=> 0288  C1
        pop  de                         ;=> 0289  D1
        pop  hl                         ;=> 028A  E1
        pop  ix                         ;=> 028B  DD E1
        pop  iy                         ;=> 028D  FD E1
        pop  af                         ;=> 028F  F1

;	ld	bc,bc	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	de,bc	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	hl,bc	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	bc,de	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	de,de	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	hl,de	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	bc,hl	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	de,hl	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	hl,hl	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	bc,ix				=} 0xDD 0x44+<1:3>     0xDD 0x4D+<1:3>
;	ld	de,ix				=} 0xDD 0x44+<1:3>     0xDD 0x4D+<1:3>
;	ld	bc,iy				=} 0xFD 0x44+<1:3>     0xFD 0x4D+<1:3>
;	ld	de,iy				=} 0xFD 0x44+<1:3>     0xFD 0x4D+<1:3>
;	
;	ld	bc,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x2B
;	ld	de,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x2B
;	ldi	bc,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x23
;	ldi	de,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x23
;	
;	ld	bc,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS           0xDD 0x46+<1:3> DIS+1
;	ld	de,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS           0xDD 0x46+<1:3> DIS+1
;	ld	hl,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS           0xDD 0x46+<1:3> DIS+1
;	ldi	bc,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS 0xDD 0x23 0xDD 0x46+<1:3> DIS 0xDD 0x23 
;	ldi	de,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS 0xDD 0x23 0xDD 0x46+<1:3> DIS 0xDD 0x23 
;	ldi	hl,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS 0xDD 0x23 0xDD 0x46+<1:3> DIS 0xDD 0x23 
;	
;	ld	bc,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS           0xFD 0x46+<1:3> DIS+1
;	ld	de,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS           0xFD 0x46+<1:3> DIS+1
;	ld	hl,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS           0xFD 0x46+<1:3> DIS+1
;	ldi	bc,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS 0xFD 0x23 0xFD 0x46+<1:3> DIS 0xFD 0x23
;	ldi	de,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS 0xFD 0x23 0xFD 0x46+<1:3> DIS 0xFD 0x23
;	ldi	hl,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS 0xFD 0x23 0xFD 0x46+<1:3> DIS 0xFD 0x23
;	
;	ld 	(hl),bc				=}      0x71+<2> 0x23     0x70+<2> 0x2B
;	ld 	(hl),de				=}      0x71+<2> 0x23     0x70+<2> 0x2B
;	ldi	(hl),bc				=}      0x71+<2> 0x23     0x70+<2> 0x23
;	ldi	(hl),de				=}      0x71+<2> 0x23     0x70+<2> 0x23
;	
;	ld 	(ix+DIS),bc		=} 0xDD 0x71+<2> DIS           0xDD 0x70+<2> DIS+1
;	ld 	(ix+DIS),de		=} 0xDD 0x71+<2> DIS           0xDD 0x70+<2> DIS+1
;	ld 	(ix+DIS),hl		=} 0xDD 0x71+<2> DIS           0xDD 0x70+<2> DIS+1
;	ldi	(ix+DIS),bc		=} 0xDD 0x71+<2> DIS 0xDD 0x23 0xDD 0x70+<2> DIS 0xDD 0x23
;	ldi	(ix+DIS),de		=} 0xDD 0x71+<2> DIS 0xDD 0x23 0xDD 0x70+<2> DIS 0xDD 0x23
;	ldi	(ix+DIS),hl		=} 0xDD 0x71+<2> DIS 0xDD 0x23 0xDD 0x70+<2> DIS 0xDD 0x23
;	
;	ld 	(iy+DIS),bc		=} 0xFD 0x71+<2> DIS 0xFD 0x70+<2> DIS+1
;	ld 	(iy+DIS),de		=} 0xFD 0x71+<2> DIS 0xFD 0x70+<2> DIS+1
;	ld 	(iy+DIS),hl		=} 0xFD 0x71+<2> DIS 0xFD 0x70+<2> DIS+1
;	ldi	(iy+DIS),bc		=} 0xFD 0x71+<2> DIS 0xFD 0x23 0xFD 0x70+<2> DIS 0xFD 0x23
;	ldi	(iy+DIS),de		=} 0xFD 0x71+<2> DIS 0xFD 0x23 0xFD 0x70+<2> DIS 0xFD 0x23
;	ldi	(iy+DIS),hl		=} 0xFD 0x71+<2> DIS 0xFD 0x23 0xFD 0x70+<2> DIS 0xFD 0x23
;	
;	ld 	hl,ix						=} 0xDD 0xE5 0xE1
;	ld 	hl,iy						=} 0xFD 0xE5 0xE1
;	
;	ld	ix,bc				=} 0xDD 0x69+<2>       0xDD 0x60+<2>
;	ld	ix,de				=} 0xDD 0x69+<2>       0xDD 0x60+<2>
;	ld	iy,bc				=} 0xFD 0x69+<2>       0xFD 0x60+<2>
;	ld	iy,de				=} 0xFD 0x69+<2>       0xFD 0x60+<2>
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

        ex   de,hl                      ;=> 0290  EB
        ex   af,af                      ;=> 0291  08
        ex   af,af'                     ;=> 0292  08
        exx                             ;=> 0293  D9
        
        ex   (sp),hl                    ;=> 0294  E3
        ex   (sp),ix                    ;=> 0295  DD E3
        ex   (sp),iy                    ;=> 0297  FD E3

        ldi                             ;=> 0299  ED A0
        ldir                            ;=> 029B  ED B0
        ldd                             ;=> 029D  ED A8
        lddr                            ;=> 029F  ED B8

        cpi                             ;=> 02A1  ED A1
        cpir                            ;=> 02A3  ED B1
        cpd                             ;=> 02A5  ED A9
        cpdr                            ;=> 02A7  ED B9

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  a,b                        ;=> 02A9  80
        adc  a,b                        ;=> 02AA  88
        sbc  a,b                        ;=> 02AB  98
        add  a,c                        ;=> 02AC  81
        adc  a,c                        ;=> 02AD  89
        sbc  a,c                        ;=> 02AE  99
        add  a,d                        ;=> 02AF  82
        adc  a,d                        ;=> 02B0  8A
        sbc  a,d                        ;=> 02B1  9A
        add  a,e                        ;=> 02B2  83
        adc  a,e                        ;=> 02B3  8B
        sbc  a,e                        ;=> 02B4  9B
        add  a,h                        ;=> 02B5  84
        adc  a,h                        ;=> 02B6  8C
        sbc  a,h                        ;=> 02B7  9C
        add  a,l                        ;=> 02B8  85
        adc  a,l                        ;=> 02B9  8D
        sbc  a,l                        ;=> 02BA  9D
        add  a,a                        ;=> 02BB  87
        adc  a,a                        ;=> 02BC  8F
        sbc  a,a                        ;=> 02BD  9F
        add  a,(hl)                     ;=> 02BE  86
        adc  a,(hl)                     ;=> 02BF  8E
        sbc  a,(hl)                     ;=> 02C0  9E
        add  a,(ix+DIS)                 ;=> 02C1  DD 86 40
        adc  a,(ix+DIS)                 ;=> 02C4  DD 8E 40
        sbc  a,(ix+DIS)                 ;=> 02C7  DD 9E 40
        add  a,(iy+DIS)                 ;=> 02CA  FD 86 40
        adc  a,(iy+DIS)                 ;=> 02CD  FD 8E 40
        sbc  a,(iy+DIS)                 ;=> 02D0  FD 9E 40
        add  a,N                        ;=> 02D3  C6 20
        adc  a,N                        ;=> 02D5  CE 20
        sbc  a,N                        ;=> 02D7  DE 20
        sub  b                          ;=> 02D9  90
        and  b                          ;=> 02DA  A0
        xor  b                          ;=> 02DB  A8
        or   b                          ;=> 02DC  B0
        cp   b                          ;=> 02DD  B8
        sub  c                          ;=> 02DE  91
        and  c                          ;=> 02DF  A1
        xor  c                          ;=> 02E0  A9
        or   c                          ;=> 02E1  B1
        cp   c                          ;=> 02E2  B9
        sub  d                          ;=> 02E3  92
        and  d                          ;=> 02E4  A2
        xor  d                          ;=> 02E5  AA
        or   d                          ;=> 02E6  B2
        cp   d                          ;=> 02E7  BA
        sub  e                          ;=> 02E8  93
        and  e                          ;=> 02E9  A3
        xor  e                          ;=> 02EA  AB
        or   e                          ;=> 02EB  B3
        cp   e                          ;=> 02EC  BB
        sub  h                          ;=> 02ED  94
        and  h                          ;=> 02EE  A4
        xor  h                          ;=> 02EF  AC
        or   h                          ;=> 02F0  B4
        cp   h                          ;=> 02F1  BC
        sub  l                          ;=> 02F2  95
        and  l                          ;=> 02F3  A5
        xor  l                          ;=> 02F4  AD
        or   l                          ;=> 02F5  B5
        cp   l                          ;=> 02F6  BD
        sub  a                          ;=> 02F7  97
        and  a                          ;=> 02F8  A7
        xor  a                          ;=> 02F9  AF
        or   a                          ;=> 02FA  B7
        cp   a                          ;=> 02FB  BF
        sub  (hl)                       ;=> 02FC  96
        and  (hl)                       ;=> 02FD  A6
        xor  (hl)                       ;=> 02FE  AE
        or   (hl)                       ;=> 02FF  B6
        cp   (hl)                       ;=> 0300  BE
        sub  (ix+DIS)                   ;=> 0301  DD 96 40
        and  (ix+DIS)                   ;=> 0304  DD A6 40
        xor  (ix+DIS)                   ;=> 0307  DD AE 40
        or   (ix+DIS)                   ;=> 030A  DD B6 40
        cp   (ix+DIS)                   ;=> 030D  DD BE 40
        sub  (iy+DIS)                   ;=> 0310  FD 96 40
        and  (iy+DIS)                   ;=> 0313  FD A6 40
        xor  (iy+DIS)                   ;=> 0316  FD AE 40
        or   (iy+DIS)                   ;=> 0319  FD B6 40
        cp   (iy+DIS)                   ;=> 031C  FD BE 40
        sub  N                          ;=> 031F  D6 20
        and  N                          ;=> 0321  E6 20
        xor  N                          ;=> 0323  EE 20
        or   N                          ;=> 0325  F6 20
        cp   N                          ;=> 0327  FE 20
        inc  b                          ;=> 0329  04
        dec  b                          ;=> 032A  05
        inc  c                          ;=> 032B  0C
        dec  c                          ;=> 032C  0D
        inc  d                          ;=> 032D  14
        dec  d                          ;=> 032E  15
        inc  e                          ;=> 032F  1C
        dec  e                          ;=> 0330  1D
        inc  h                          ;=> 0331  24
        dec  h                          ;=> 0332  25
        inc  l                          ;=> 0333  2C
        dec  l                          ;=> 0334  2D
        inc  a                          ;=> 0335  3C
        dec  a                          ;=> 0336  3D
        inc  (hl)                       ;=> 0337  34
        dec  (hl)                       ;=> 0338  35
        inc  (ix+DIS)                   ;=> 0339  DD 34 40
        dec  (ix+DIS)                   ;=> 033C  DD 35 40
        inc  (iy+DIS)                   ;=> 033F  FD 34 40
        dec  (iy+DIS)                   ;=> 0342  FD 35 40
        
        add  a,ixh                      ;=> 0345  DD 84
        adc  a,ixh                      ;=> 0347  DD 8C
        sbc  a,ixh                      ;=> 0349  DD 9C
        add  a,ixl                      ;=> 034B  DD 85
        adc  a,ixl                      ;=> 034D  DD 8D
        sbc  a,ixl                      ;=> 034F  DD 9D
        add  a,iyh                      ;=> 0351  FD 84
        adc  a,iyh                      ;=> 0353  FD 8C
        sbc  a,iyh                      ;=> 0355  FD 9C
        add  a,iyl                      ;=> 0357  FD 85
        adc  a,iyl                      ;=> 0359  FD 8D
        sbc  a,iyl                      ;=> 035B  FD 9D
        sub  ixh                        ;=> 035D  DD 94
        and  ixh                        ;=> 035F  DD A4
        xor  ixh                        ;=> 0361  DD AC
        or   ixh                        ;=> 0363  DD B4
        cp   ixh                        ;=> 0365  DD BC
        inc  ixh                        ;=> 0367  DD 24
        dec  ixh                        ;=> 0369  DD 25
        sub  ixl                        ;=> 036B  DD 95
        and  ixl                        ;=> 036D  DD A5
        xor  ixl                        ;=> 036F  DD AD
        or   ixl                        ;=> 0371  DD B5
        cp   ixl                        ;=> 0373  DD BD
        inc  ixl                        ;=> 0375  DD 2C
        dec  ixl                        ;=> 0377  DD 2D
        sub  iyh                        ;=> 0379  FD 94
        and  iyh                        ;=> 037B  FD A4
        xor  iyh                        ;=> 037D  FD AC
        or   iyh                        ;=> 037F  FD B4
        cp   iyh                        ;=> 0381  FD BC
        inc  iyh                        ;=> 0383  FD 24
        dec  iyh                        ;=> 0385  FD 25
        sub  iyl                        ;=> 0387  FD 95
        and  iyl                        ;=> 0389  FD A5
        xor  iyl                        ;=> 038B  FD AD
        or   iyl                        ;=> 038D  FD B5
        cp   iyl                        ;=> 038F  FD BD
        inc  iyl                        ;=> 0391  FD 2C
        dec  iyl                        ;=> 0393  FD 2D

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  hl,bc                      ;=> 0395  09
        add  hl,de                      ;=> 0396  19
        add  hl,hl                      ;=> 0397  29
        add  hl,sp                      ;=> 0398  39
        add  ix,bc                      ;=> 0399  DD 09
        add  ix,de                      ;=> 039B  DD 19
        add  ix,ix                      ;=> 039D  DD 29
        add  ix,sp                      ;=> 039F  DD 39
        add  iy,bc                      ;=> 03A1  FD 09
        add  iy,de                      ;=> 03A3  FD 19
        add  iy,iy                      ;=> 03A5  FD 29
        add  iy,sp                      ;=> 03A7  FD 39

        sbc  hl,bc                      ;=> 03A9  ED 42
        adc  hl,bc                      ;=> 03AB  ED 4A
        sbc  hl,de                      ;=> 03AD  ED 52
        adc  hl,de                      ;=> 03AF  ED 5A
        sbc  hl,hl                      ;=> 03B1  ED 62
        adc  hl,hl                      ;=> 03B3  ED 6A
        sbc  hl,sp                      ;=> 03B5  ED 72
        adc  hl,sp                      ;=> 03B7  ED 7A
;	sub       hl,bc						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,de						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,hl						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,sp						=} 0xB7 0xED 0x42+<2:4>

        inc  bc                         ;=> 03B9  03
        dec  bc                         ;=> 03BA  0B
        inc  de                         ;=> 03BB  13
        dec  de                         ;=> 03BC  1B
        inc  hl                         ;=> 03BD  23
        dec  hl                         ;=> 03BE  2B
        inc  ix                         ;=> 03BF  DD 23
        dec  ix                         ;=> 03C1  DD 2B
        inc  iy                         ;=> 03C3  FD 23
        dec  iy                         ;=> 03C5  FD 2B
        inc  sp                         ;=> 03C7  33
        dec  sp                         ;=> 03C8  3B

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

        rlca                            ;=> 03C9  07
        rrca                            ;=> 03CA  0F
        rla                             ;=> 03CB  17
        rra                             ;=> 03CC  1F

        rlc  b                          ;=> 03CD  CB 00
        rrc  b                          ;=> 03CF  CB 08
        rl   b                          ;=> 03D1  CB 10
        rr   b                          ;=> 03D3  CB 18
        sla  b                          ;=> 03D5  CB 20
        sra  b                          ;=> 03D7  CB 28
        srl  b                          ;=> 03D9  CB 38
        rlc  c                          ;=> 03DB  CB 01
        rrc  c                          ;=> 03DD  CB 09
        rl   c                          ;=> 03DF  CB 11
        rr   c                          ;=> 03E1  CB 19
        sla  c                          ;=> 03E3  CB 21
        sra  c                          ;=> 03E5  CB 29
        srl  c                          ;=> 03E7  CB 39
        rlc  d                          ;=> 03E9  CB 02
        rrc  d                          ;=> 03EB  CB 0A
        rl   d                          ;=> 03ED  CB 12
        rr   d                          ;=> 03EF  CB 1A
        sla  d                          ;=> 03F1  CB 22
        sra  d                          ;=> 03F3  CB 2A
        srl  d                          ;=> 03F5  CB 3A
        rlc  e                          ;=> 03F7  CB 03
        rrc  e                          ;=> 03F9  CB 0B
        rl   e                          ;=> 03FB  CB 13
        rr   e                          ;=> 03FD  CB 1B
        sla  e                          ;=> 03FF  CB 23
        sra  e                          ;=> 0401  CB 2B
        srl  e                          ;=> 0403  CB 3B
        rlc  h                          ;=> 0405  CB 04
        rrc  h                          ;=> 0407  CB 0C
        rl   h                          ;=> 0409  CB 14
        rr   h                          ;=> 040B  CB 1C
        sla  h                          ;=> 040D  CB 24
        sra  h                          ;=> 040F  CB 2C
        srl  h                          ;=> 0411  CB 3C
        rlc  l                          ;=> 0413  CB 05
        rrc  l                          ;=> 0415  CB 0D
        rl   l                          ;=> 0417  CB 15
        rr   l                          ;=> 0419  CB 1D
        sla  l                          ;=> 041B  CB 25
        sra  l                          ;=> 041D  CB 2D
        srl  l                          ;=> 041F  CB 3D
        rlc  a                          ;=> 0421  CB 07
        rrc  a                          ;=> 0423  CB 0F
        rl   a                          ;=> 0425  CB 17
        rr   a                          ;=> 0427  CB 1F
        sla  a                          ;=> 0429  CB 27
        sra  a                          ;=> 042B  CB 2F
        srl  a                          ;=> 042D  CB 3F
        rlc  (hl)                       ;=> 042F  CB 06
        rrc  (hl)                       ;=> 0431  CB 0E
        rl   (hl)                       ;=> 0433  CB 16
        rr   (hl)                       ;=> 0435  CB 1E
        sla  (hl)                       ;=> 0437  CB 26
        sra  (hl)                       ;=> 0439  CB 2E
        srl  (hl)                       ;=> 043B  CB 3E
        rlc  (ix+DIS)                   ;=> 043D  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 0441  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 0445  DD CB 40 16
        rr   (ix+DIS)                   ;=> 0449  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 044D  DD CB 40 26
        sra  (ix+DIS)                   ;=> 0451  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 0455  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 0459  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 045D  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 0461  FD CB 40 16
        rr   (iy+DIS)                   ;=> 0465  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 0469  FD CB 40 26
        sra  (iy+DIS)                   ;=> 046D  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 0471  FD CB 40 3E
        rlc  b                          ;=> 0475  CB 00
        rrc  b                          ;=> 0477  CB 08
        rl   b                          ;=> 0479  CB 10
        rr   b                          ;=> 047B  CB 18
        sla  b                          ;=> 047D  CB 20
        sra  b                          ;=> 047F  CB 28
        srl  b                          ;=> 0481  CB 38
        rlc  c                          ;=> 0483  CB 01
        rrc  c                          ;=> 0485  CB 09
        rl   c                          ;=> 0487  CB 11
        rr   c                          ;=> 0489  CB 19
        sla  c                          ;=> 048B  CB 21
        sra  c                          ;=> 048D  CB 29
        srl  c                          ;=> 048F  CB 39
        rlc  d                          ;=> 0491  CB 02
        rrc  d                          ;=> 0493  CB 0A
        rl   d                          ;=> 0495  CB 12
        rr   d                          ;=> 0497  CB 1A
        sla  d                          ;=> 0499  CB 22
        sra  d                          ;=> 049B  CB 2A
        srl  d                          ;=> 049D  CB 3A
        rlc  e                          ;=> 049F  CB 03
        rrc  e                          ;=> 04A1  CB 0B
        rl   e                          ;=> 04A3  CB 13
        rr   e                          ;=> 04A5  CB 1B
        sla  e                          ;=> 04A7  CB 23
        sra  e                          ;=> 04A9  CB 2B
        srl  e                          ;=> 04AB  CB 3B
        rlc  h                          ;=> 04AD  CB 04
        rrc  h                          ;=> 04AF  CB 0C
        rl   h                          ;=> 04B1  CB 14
        rr   h                          ;=> 04B3  CB 1C
        sla  h                          ;=> 04B5  CB 24
        sra  h                          ;=> 04B7  CB 2C
        srl  h                          ;=> 04B9  CB 3C
        rlc  l                          ;=> 04BB  CB 05
        rrc  l                          ;=> 04BD  CB 0D
        rl   l                          ;=> 04BF  CB 15
        rr   l                          ;=> 04C1  CB 1D
        sla  l                          ;=> 04C3  CB 25
        sra  l                          ;=> 04C5  CB 2D
        srl  l                          ;=> 04C7  CB 3D
        rlc  a                          ;=> 04C9  CB 07
        rrc  a                          ;=> 04CB  CB 0F
        rl   a                          ;=> 04CD  CB 17
        rr   a                          ;=> 04CF  CB 1F
        sla  a                          ;=> 04D1  CB 27
        sra  a                          ;=> 04D3  CB 2F
        srl  a                          ;=> 04D5  CB 3F
        rlc  (hl)                       ;=> 04D7  CB 06
        rrc  (hl)                       ;=> 04D9  CB 0E
        rl   (hl)                       ;=> 04DB  CB 16
        rr   (hl)                       ;=> 04DD  CB 1E
        sla  (hl)                       ;=> 04DF  CB 26
        sra  (hl)                       ;=> 04E1  CB 2E
        srl  (hl)                       ;=> 04E3  CB 3E
        rlc  (ix+DIS)                   ;=> 04E5  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 04E9  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 04ED  DD CB 40 16
        rr   (ix+DIS)                   ;=> 04F1  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 04F5  DD CB 40 26
        sra  (ix+DIS)                   ;=> 04F9  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 04FD  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 0501  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 0505  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 0509  FD CB 40 16
        rr   (iy+DIS)                   ;=> 050D  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 0511  FD CB 40 26
        sra  (iy+DIS)                   ;=> 0515  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 0519  FD CB 40 3E
;	rlc (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sll ...
;	sli ...

        rld                             ;=> 051D  ED 6F
        rrd                             ;=> 051F  ED 67

;	# rotate 16 bits
;
;	rl bc					=} 0xCB 0x11+<1 0xCB 0x10+<1
;	rl de					=} 0xCB 0x11+<1 0xCB 0x10+<1
;	rl hl					=} 0xCB 0x11+<1 0xCB 0x10+<1
;	rr bc					=} 0xCB 0x18+<1 0xCB 0x19+<1
;	rr de					=} 0xCB 0x18+<1 0xCB 0x19+<1
;	rr hl					=} 0xCB 0x18+<1 0xCB 0x19+<1
;
;	sla hl							=} 0x29			# special case: add hl,hl
;	sla bc				=} 0xCB 0x21+<1 0xCB 0x10+<1
;	sla de				=} 0xCB 0x21+<1 0xCB 0x10+<1
;	sla hl				=} 0xCB 0x21+<1 0xCB 0x10+<1
;	sll bc				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sll de				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sll hl				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sli bc				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sli de				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sli hl				=} 0xCB 0x31+<1 0xCB 0x10+<1
;
;	sra bc				=} 0xCB 0x28+<1 0xCB 0x19+<1
;	sra de				=} 0xCB 0x28+<1 0xCB 0x19+<1
;	sra hl				=} 0xCB 0x28+<1 0xCB 0x19+<1
;	srl bc				=} 0xCB 0x38+<1 0xCB 0x19+<1
;	srl de				=} 0xCB 0x38+<1 0xCB 0x19+<1
;	srl hl				=} 0xCB 0x38+<1 0xCB 0x19+<1


;------------------------------------------------------------------------------
; General purpose arithmetic and CPU control group
;------------------------------------------------------------------------------

        cpl                             ;=> 0521  2F
        neg                             ;=> 0522  ED 44
        ccf                             ;=> 0524  3F
        scf                             ;=> 0525  37
        nop                             ;=> 0526  00

        daa                             ;=> 0527  27
        di                              ;=> 0528  F3
        ei                              ;=> 0529  FB
        halt                            ;=> 052A  76
        im   0                          ;=> 052B  ED 46
        im   1                          ;=> 052D  ED 56
        im   2                          ;=> 052F  ED 5E

;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

        bit  0,b                        ;=> 0531  CB 40
        res  0,b                        ;=> 0533  CB 80
        set  0,b                        ;=> 0535  CB C0
        bit  1,b                        ;=> 0537  CB 48
        res  1,b                        ;=> 0539  CB 88
        set  1,b                        ;=> 053B  CB C8
        bit  2,b                        ;=> 053D  CB 50
        res  2,b                        ;=> 053F  CB 90
        set  2,b                        ;=> 0541  CB D0
        bit  3,b                        ;=> 0543  CB 58
        res  3,b                        ;=> 0545  CB 98
        set  3,b                        ;=> 0547  CB D8
        bit  4,b                        ;=> 0549  CB 60
        res  4,b                        ;=> 054B  CB A0
        set  4,b                        ;=> 054D  CB E0
        bit  5,b                        ;=> 054F  CB 68
        res  5,b                        ;=> 0551  CB A8
        set  5,b                        ;=> 0553  CB E8
        bit  6,b                        ;=> 0555  CB 70
        res  6,b                        ;=> 0557  CB B0
        set  6,b                        ;=> 0559  CB F0
        bit  7,b                        ;=> 055B  CB 78
        res  7,b                        ;=> 055D  CB B8
        set  7,b                        ;=> 055F  CB F8
        bit  0,c                        ;=> 0561  CB 41
        res  0,c                        ;=> 0563  CB 81
        set  0,c                        ;=> 0565  CB C1
        bit  1,c                        ;=> 0567  CB 49
        res  1,c                        ;=> 0569  CB 89
        set  1,c                        ;=> 056B  CB C9
        bit  2,c                        ;=> 056D  CB 51
        res  2,c                        ;=> 056F  CB 91
        set  2,c                        ;=> 0571  CB D1
        bit  3,c                        ;=> 0573  CB 59
        res  3,c                        ;=> 0575  CB 99
        set  3,c                        ;=> 0577  CB D9
        bit  4,c                        ;=> 0579  CB 61
        res  4,c                        ;=> 057B  CB A1
        set  4,c                        ;=> 057D  CB E1
        bit  5,c                        ;=> 057F  CB 69
        res  5,c                        ;=> 0581  CB A9
        set  5,c                        ;=> 0583  CB E9
        bit  6,c                        ;=> 0585  CB 71
        res  6,c                        ;=> 0587  CB B1
        set  6,c                        ;=> 0589  CB F1
        bit  7,c                        ;=> 058B  CB 79
        res  7,c                        ;=> 058D  CB B9
        set  7,c                        ;=> 058F  CB F9
        bit  0,d                        ;=> 0591  CB 42
        res  0,d                        ;=> 0593  CB 82
        set  0,d                        ;=> 0595  CB C2
        bit  1,d                        ;=> 0597  CB 4A
        res  1,d                        ;=> 0599  CB 8A
        set  1,d                        ;=> 059B  CB CA
        bit  2,d                        ;=> 059D  CB 52
        res  2,d                        ;=> 059F  CB 92
        set  2,d                        ;=> 05A1  CB D2
        bit  3,d                        ;=> 05A3  CB 5A
        res  3,d                        ;=> 05A5  CB 9A
        set  3,d                        ;=> 05A7  CB DA
        bit  4,d                        ;=> 05A9  CB 62
        res  4,d                        ;=> 05AB  CB A2
        set  4,d                        ;=> 05AD  CB E2
        bit  5,d                        ;=> 05AF  CB 6A
        res  5,d                        ;=> 05B1  CB AA
        set  5,d                        ;=> 05B3  CB EA
        bit  6,d                        ;=> 05B5  CB 72
        res  6,d                        ;=> 05B7  CB B2
        set  6,d                        ;=> 05B9  CB F2
        bit  7,d                        ;=> 05BB  CB 7A
        res  7,d                        ;=> 05BD  CB BA
        set  7,d                        ;=> 05BF  CB FA
        bit  0,e                        ;=> 05C1  CB 43
        res  0,e                        ;=> 05C3  CB 83
        set  0,e                        ;=> 05C5  CB C3
        bit  1,e                        ;=> 05C7  CB 4B
        res  1,e                        ;=> 05C9  CB 8B
        set  1,e                        ;=> 05CB  CB CB
        bit  2,e                        ;=> 05CD  CB 53
        res  2,e                        ;=> 05CF  CB 93
        set  2,e                        ;=> 05D1  CB D3
        bit  3,e                        ;=> 05D3  CB 5B
        res  3,e                        ;=> 05D5  CB 9B
        set  3,e                        ;=> 05D7  CB DB
        bit  4,e                        ;=> 05D9  CB 63
        res  4,e                        ;=> 05DB  CB A3
        set  4,e                        ;=> 05DD  CB E3
        bit  5,e                        ;=> 05DF  CB 6B
        res  5,e                        ;=> 05E1  CB AB
        set  5,e                        ;=> 05E3  CB EB
        bit  6,e                        ;=> 05E5  CB 73
        res  6,e                        ;=> 05E7  CB B3
        set  6,e                        ;=> 05E9  CB F3
        bit  7,e                        ;=> 05EB  CB 7B
        res  7,e                        ;=> 05ED  CB BB
        set  7,e                        ;=> 05EF  CB FB
        bit  0,h                        ;=> 05F1  CB 44
        res  0,h                        ;=> 05F3  CB 84
        set  0,h                        ;=> 05F5  CB C4
        bit  1,h                        ;=> 05F7  CB 4C
        res  1,h                        ;=> 05F9  CB 8C
        set  1,h                        ;=> 05FB  CB CC
        bit  2,h                        ;=> 05FD  CB 54
        res  2,h                        ;=> 05FF  CB 94
        set  2,h                        ;=> 0601  CB D4
        bit  3,h                        ;=> 0603  CB 5C
        res  3,h                        ;=> 0605  CB 9C
        set  3,h                        ;=> 0607  CB DC
        bit  4,h                        ;=> 0609  CB 64
        res  4,h                        ;=> 060B  CB A4
        set  4,h                        ;=> 060D  CB E4
        bit  5,h                        ;=> 060F  CB 6C
        res  5,h                        ;=> 0611  CB AC
        set  5,h                        ;=> 0613  CB EC
        bit  6,h                        ;=> 0615  CB 74
        res  6,h                        ;=> 0617  CB B4
        set  6,h                        ;=> 0619  CB F4
        bit  7,h                        ;=> 061B  CB 7C
        res  7,h                        ;=> 061D  CB BC
        set  7,h                        ;=> 061F  CB FC
        bit  0,l                        ;=> 0621  CB 45
        res  0,l                        ;=> 0623  CB 85
        set  0,l                        ;=> 0625  CB C5
        bit  1,l                        ;=> 0627  CB 4D
        res  1,l                        ;=> 0629  CB 8D
        set  1,l                        ;=> 062B  CB CD
        bit  2,l                        ;=> 062D  CB 55
        res  2,l                        ;=> 062F  CB 95
        set  2,l                        ;=> 0631  CB D5
        bit  3,l                        ;=> 0633  CB 5D
        res  3,l                        ;=> 0635  CB 9D
        set  3,l                        ;=> 0637  CB DD
        bit  4,l                        ;=> 0639  CB 65
        res  4,l                        ;=> 063B  CB A5
        set  4,l                        ;=> 063D  CB E5
        bit  5,l                        ;=> 063F  CB 6D
        res  5,l                        ;=> 0641  CB AD
        set  5,l                        ;=> 0643  CB ED
        bit  6,l                        ;=> 0645  CB 75
        res  6,l                        ;=> 0647  CB B5
        set  6,l                        ;=> 0649  CB F5
        bit  7,l                        ;=> 064B  CB 7D
        res  7,l                        ;=> 064D  CB BD
        set  7,l                        ;=> 064F  CB FD
        bit  0,a                        ;=> 0651  CB 47
        res  0,a                        ;=> 0653  CB 87
        set  0,a                        ;=> 0655  CB C7
        bit  1,a                        ;=> 0657  CB 4F
        res  1,a                        ;=> 0659  CB 8F
        set  1,a                        ;=> 065B  CB CF
        bit  2,a                        ;=> 065D  CB 57
        res  2,a                        ;=> 065F  CB 97
        set  2,a                        ;=> 0661  CB D7
        bit  3,a                        ;=> 0663  CB 5F
        res  3,a                        ;=> 0665  CB 9F
        set  3,a                        ;=> 0667  CB DF
        bit  4,a                        ;=> 0669  CB 67
        res  4,a                        ;=> 066B  CB A7
        set  4,a                        ;=> 066D  CB E7
        bit  5,a                        ;=> 066F  CB 6F
        res  5,a                        ;=> 0671  CB AF
        set  5,a                        ;=> 0673  CB EF
        bit  6,a                        ;=> 0675  CB 77
        res  6,a                        ;=> 0677  CB B7
        set  6,a                        ;=> 0679  CB F7
        bit  7,a                        ;=> 067B  CB 7F
        res  7,a                        ;=> 067D  CB BF
        set  7,a                        ;=> 067F  CB FF
        bit  0,(hl)                     ;=> 0681  CB 46
        res  0,(hl)                     ;=> 0683  CB 86
        set  0,(hl)                     ;=> 0685  CB C6
        bit  1,(hl)                     ;=> 0687  CB 4E
        res  1,(hl)                     ;=> 0689  CB 8E
        set  1,(hl)                     ;=> 068B  CB CE
        bit  2,(hl)                     ;=> 068D  CB 56
        res  2,(hl)                     ;=> 068F  CB 96
        set  2,(hl)                     ;=> 0691  CB D6
        bit  3,(hl)                     ;=> 0693  CB 5E
        res  3,(hl)                     ;=> 0695  CB 9E
        set  3,(hl)                     ;=> 0697  CB DE
        bit  4,(hl)                     ;=> 0699  CB 66
        res  4,(hl)                     ;=> 069B  CB A6
        set  4,(hl)                     ;=> 069D  CB E6
        bit  5,(hl)                     ;=> 069F  CB 6E
        res  5,(hl)                     ;=> 06A1  CB AE
        set  5,(hl)                     ;=> 06A3  CB EE
        bit  6,(hl)                     ;=> 06A5  CB 76
        res  6,(hl)                     ;=> 06A7  CB B6
        set  6,(hl)                     ;=> 06A9  CB F6
        bit  7,(hl)                     ;=> 06AB  CB 7E
        res  7,(hl)                     ;=> 06AD  CB BE
        set  7,(hl)                     ;=> 06AF  CB FE
        bit  0,(ix+DIS)                 ;=> 06B1  DD CB 40 46
        res  0,(ix+DIS)                 ;=> 06B5  DD CB 40 86
        set  0,(ix+DIS)                 ;=> 06B9  DD CB 40 C6
        bit  1,(ix+DIS)                 ;=> 06BD  DD CB 40 4E
        res  1,(ix+DIS)                 ;=> 06C1  DD CB 40 8E
        set  1,(ix+DIS)                 ;=> 06C5  DD CB 40 CE
        bit  2,(ix+DIS)                 ;=> 06C9  DD CB 40 56
        res  2,(ix+DIS)                 ;=> 06CD  DD CB 40 96
        set  2,(ix+DIS)                 ;=> 06D1  DD CB 40 D6
        bit  3,(ix+DIS)                 ;=> 06D5  DD CB 40 5E
        res  3,(ix+DIS)                 ;=> 06D9  DD CB 40 9E
        set  3,(ix+DIS)                 ;=> 06DD  DD CB 40 DE
        bit  4,(ix+DIS)                 ;=> 06E1  DD CB 40 66
        res  4,(ix+DIS)                 ;=> 06E5  DD CB 40 A6
        set  4,(ix+DIS)                 ;=> 06E9  DD CB 40 E6
        bit  5,(ix+DIS)                 ;=> 06ED  DD CB 40 6E
        res  5,(ix+DIS)                 ;=> 06F1  DD CB 40 AE
        set  5,(ix+DIS)                 ;=> 06F5  DD CB 40 EE
        bit  6,(ix+DIS)                 ;=> 06F9  DD CB 40 76
        res  6,(ix+DIS)                 ;=> 06FD  DD CB 40 B6
        set  6,(ix+DIS)                 ;=> 0701  DD CB 40 F6
        bit  7,(ix+DIS)                 ;=> 0705  DD CB 40 7E
        res  7,(ix+DIS)                 ;=> 0709  DD CB 40 BE
        set  7,(ix+DIS)                 ;=> 070D  DD CB 40 FE
        bit  0,(iy+DIS)                 ;=> 0711  FD CB 40 46
        res  0,(iy+DIS)                 ;=> 0715  FD CB 40 86
        set  0,(iy+DIS)                 ;=> 0719  FD CB 40 C6
        bit  1,(iy+DIS)                 ;=> 071D  FD CB 40 4E
        res  1,(iy+DIS)                 ;=> 0721  FD CB 40 8E
        set  1,(iy+DIS)                 ;=> 0725  FD CB 40 CE
        bit  2,(iy+DIS)                 ;=> 0729  FD CB 40 56
        res  2,(iy+DIS)                 ;=> 072D  FD CB 40 96
        set  2,(iy+DIS)                 ;=> 0731  FD CB 40 D6
        bit  3,(iy+DIS)                 ;=> 0735  FD CB 40 5E
        res  3,(iy+DIS)                 ;=> 0739  FD CB 40 9E
        set  3,(iy+DIS)                 ;=> 073D  FD CB 40 DE
        bit  4,(iy+DIS)                 ;=> 0741  FD CB 40 66
        res  4,(iy+DIS)                 ;=> 0745  FD CB 40 A6
        set  4,(iy+DIS)                 ;=> 0749  FD CB 40 E6
        bit  5,(iy+DIS)                 ;=> 074D  FD CB 40 6E
        res  5,(iy+DIS)                 ;=> 0751  FD CB 40 AE
        set  5,(iy+DIS)                 ;=> 0755  FD CB 40 EE
        bit  6,(iy+DIS)                 ;=> 0759  FD CB 40 76
        res  6,(iy+DIS)                 ;=> 075D  FD CB 40 B6
        set  6,(iy+DIS)                 ;=> 0761  FD CB 40 F6
        bit  7,(iy+DIS)                 ;=> 0765  FD CB 40 7E
        res  7,(iy+DIS)                 ;=> 0769  FD CB 40 BE
        set  7,(iy+DIS)                 ;=> 076D  FD CB 40 FE
;	res     0,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3

;------------------------------------------------------------------------------
; Jump Group
;------------------------------------------------------------------------------
jr1:
        jp   NN                         ;=> 0771  C3 30 00
        jp   (hl)                       ;=> 0774  E9
        jp   (ix)                       ;=> 0775  DD E9
        jp   (iy)                       ;=> 0777  FD E9
        jp   nz,NN                      ;=> 0779  C2 30 00
        jp   z,NN                       ;=> 077C  CA 30 00
        jp   nc,NN                      ;=> 077F  D2 30 00
        jp   c,NN                       ;=> 0782  DA 30 00
        jp   po,NN                      ;=> 0785  E2 30 00
        jp   pe,NN                      ;=> 0788  EA 30 00
        jp   p,NN                       ;=> 078B  F2 30 00
        jp   m,NN                       ;=> 078E  FA 30 00

        jr   jr1                        ;=> 0791  18 DE
        djnz jr1                        ;=> 0793  10 DC
        jr   nz,jr1                     ;=> 0795  20 DA
        jr   z,jr1                      ;=> 0797  28 D8
        jr   nc,jr1                     ;=> 0799  30 D6
        jr   c,jr1                      ;=> 079B  38 D4
;	jr po,NN
;	jr pe,NN
;	jr p,NN
;	jr m,NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

        call NN                         ;=> 079D  CD 30 00
        ret                             ;=> 07A0  C9
        ret  nz                         ;=> 07A1  C0
        ret  z                          ;=> 07A2  C8
        ret  nc                         ;=> 07A3  D0
        ret  c                          ;=> 07A4  D8
        ret  po                         ;=> 07A5  E0
        ret  pe                         ;=> 07A6  E8
        ret  p                          ;=> 07A7  F0
        ret  m                          ;=> 07A8  F8
        reti                            ;=> 07A9  ED 4D
;	rst 0
;	rst 1
;	rst 2
;	rst 3
;	rst 4
;	rst 5
;	rst 6
;	rst 7


        call nz,NN                      ;=> 07AB  C4 30 00
        call z,NN                       ;=> 07AE  CC 30 00
        call nc,NN                      ;=> 07B1  D4 30 00
        call c,NN                       ;=> 07B4  DC 30 00
        call po,NN                      ;=> 07B7  E4 30 00
        call pe,NN                      ;=> 07BA  EC 30 00
        call p,NN                       ;=> 07BD  F4 30 00
        call m,NN                       ;=> 07C0  FC 30 00
        retn                            ;=> 07C3  ED 45
        rst  00h                        ;=> 07C5  C7
        rst  08h                        ;=> 07C6  CF
        rst  10h                        ;=> 07C7  D7
        rst  18h                        ;=> 07C8  DF
        rst  20h                        ;=> 07C9  E7
        rst  28h                        ;=> 07CA  EF
        rst  30h                        ;=> 07CB  F7
        rst  38h                        ;=> 07CC  FF

;------------------------------------------------------------------------------
; Input and Output Group
;------------------------------------------------------------------------------

        in   a,(N)                      ;=> 07CD  DB 20
        in   b,(c)                      ;=> 07CF  ED 40
        in   c,(c)                      ;=> 07D1  ED 48
        in   d,(c)                      ;=> 07D3  ED 50
        in   e,(c)                      ;=> 07D5  ED 58
        in   h,(c)                      ;=> 07D7  ED 60
        in   l,(c)                      ;=> 07D9  ED 68
        in   a,(c)                      ;=> 07DB  ED 78
;	in f,(c)

        ini                             ;=> 07DD  ED A2
        inir                            ;=> 07DF  ED B2
        ind                             ;=> 07E1  ED AA
        indr                            ;=> 07E3  ED BA

        out  (N),a                      ;=> 07E5  D3 20
        out  (c),b                      ;=> 07E7  ED 41
        out  (c),c                      ;=> 07E9  ED 49
        out  (c),d                      ;=> 07EB  ED 51
        out  (c),e                      ;=> 07ED  ED 59
        out  (c),h                      ;=> 07EF  ED 61
        out  (c),l                      ;=> 07F1  ED 69
        out  (c),a                      ;=> 07F3  ED 79
;	out (c),0

        outi                            ;=> 07F5  ED A3
        otir                            ;=> 07F7  ED B3
        outd                            ;=> 07F9  ED AB
        otdr                            ;=> 07FB  ED BB

;------------------------------------------------------------------------------
; $Log: z80opcodes.asm,v $
; Revision 1.2  2014-04-25 23:52:17  pauloscustodio
; Rename input file for z80opcodes generation
;
;

