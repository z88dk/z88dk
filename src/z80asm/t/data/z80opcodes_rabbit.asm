;------------------------------------------------------------------------------
; Z80 reference opcodes parsed by build_z80opcodes.pl
; 		z80asm-code ;; z80pack-code ;; code ;; code
; The code is assembled by z80pack and transformed into code and binary form:
;		z80asm-code ;; addr hh hh hh hh
; This is file used to test the assembly of z80asm
; 
; Copyright (C) Paulo Custodio, 2011-2014
; 
; 
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


        ld   b,(hl)                     ;=> 013F  46
        ld   c,(hl)                     ;=> 0140  4E
        ld   d,(hl)                     ;=> 0141  56
        ld   e,(hl)                     ;=> 0142  5E
        ld   h,(hl)                     ;=> 0143  66
        ld   l,(hl)                     ;=> 0144  6E
        ld   a,(hl)                     ;=> 0145  7E
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

        ld   b,(ix+DIS)                 ;=> 0146  DD 46 40
        ld   c,(ix+DIS)                 ;=> 0149  DD 4E 40
        ld   d,(ix+DIS)                 ;=> 014C  DD 56 40
        ld   e,(ix+DIS)                 ;=> 014F  DD 5E 40
        ld   h,(ix+DIS)                 ;=> 0152  DD 66 40
        ld   l,(ix+DIS)                 ;=> 0155  DD 6E 40
        ld   a,(ix+DIS)                 ;=> 0158  DD 7E 40
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

        ld   b,(iy+DIS)                 ;=> 015B  FD 46 40
        ld   c,(iy+DIS)                 ;=> 015E  FD 4E 40
        ld   d,(iy+DIS)                 ;=> 0161  FD 56 40
        ld   e,(iy+DIS)                 ;=> 0164  FD 5E 40
        ld   h,(iy+DIS)                 ;=> 0167  FD 66 40
        ld   l,(iy+DIS)                 ;=> 016A  FD 6E 40
        ld   a,(iy+DIS)                 ;=> 016D  FD 7E 40
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

        ld   (hl),b                     ;=> 0170  70
        ld   (hl),c                     ;=> 0171  71
        ld   (hl),d                     ;=> 0172  72
        ld   (hl),e                     ;=> 0173  73
        ld   (hl),h                     ;=> 0174  74
        ld   (hl),l                     ;=> 0175  75
        ld   (hl),a                     ;=> 0176  77
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

        ld   (ix+DIS),b                 ;=> 0177  DD 70 40
        ld   (ix+DIS),c                 ;=> 017A  DD 71 40
        ld   (ix+DIS),d                 ;=> 017D  DD 72 40
        ld   (ix+DIS),e                 ;=> 0180  DD 73 40
        ld   (ix+DIS),h                 ;=> 0183  DD 74 40
        ld   (ix+DIS),l                 ;=> 0186  DD 75 40
        ld   (ix+DIS),a                 ;=> 0189  DD 77 40
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

        ld   (iy+DIS),b                 ;=> 018C  FD 70 40
        ld   (iy+DIS),c                 ;=> 018F  FD 71 40
        ld   (iy+DIS),d                 ;=> 0192  FD 72 40
        ld   (iy+DIS),e                 ;=> 0195  FD 73 40
        ld   (iy+DIS),h                 ;=> 0198  FD 74 40
        ld   (iy+DIS),l                 ;=> 019B  FD 75 40
        ld   (iy+DIS),a                 ;=> 019E  FD 77 40
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

        ld   (hl),N                     ;=> 01A1  36 20
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

        ld   (ix+DIS),N                 ;=> 01A3  DD 36 40 20
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

        ld   (iy+DIS),N                 ;=> 01A7  FD 36 40 20
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

        ld   a,(bc)                     ;=> 01AB  0A
        ld   a,(de)                     ;=> 01AC  1A
;	ldi	a,(bc)						;;	ld	a,(bc) ;; inc bc
;	ldi	a,(de)						;;	ld	a,(de) ;; inc de
;	ldd	a,(bc)						;;	ld	a,(bc) ;; dec bc
;	ldd	a,(de)						;;	ld	a,(de) ;; dec de

        ld   (bc),a                     ;=> 01AD  02
        ld   (de),a                     ;=> 01AE  12
;	ldi	(bc),a						;;	ld	(bc),a ;; inc bc
;	ldi	(de),a						;;	ld	(de),a ;; inc de
;	ldd	(bc),a						;;	ld	(bc),a ;; dec bc
;	ldd	(de),a						;;	ld	(de),a ;; dec de

        ld   a,(NN)                     ;=> 01AF  3A 30 00
        ld   (NN),a                     ;=> 01B2  32 30 00

        ld   a,iir                      ;=> 01B5  ED 57
        ld   a,eir                      ;=> 01B7  ED 5F
        ld   iir,a                      ;=> 01B9  ED 47
        ld   eir,a                      ;=> 01BB  ED 4F

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

        ld   bc,NN                      ;=> 01BD  01 30 00
        ld   de,NN                      ;=> 01C0  11 30 00
        ld   hl,NN                      ;=> 01C3  21 30 00
        ld   ix,NN                      ;=> 01C6  DD 21 30 00
        ld   iy,NN                      ;=> 01CA  FD 21 30 00
        ld   sp,NN                      ;=> 01CE  31 30 00
        ld   bc,(NN)                    ;=> 01D1  ED 4B 30 00
        ld   de,(NN)                    ;=> 01D5  ED 5B 30 00
        ld   hl,(NN)                    ;=> 01D9  2A 30 00
        ld   ix,(NN)                    ;=> 01DC  DD 2A 30 00
        ld   iy,(NN)                    ;=> 01E0  FD 2A 30 00
        ld   sp,(NN)                    ;=> 01E4  ED 7B 30 00
        ld   (NN),bc                    ;=> 01E8  ED 43 30 00
        ld   (NN),de                    ;=> 01EC  ED 53 30 00
        ld   (NN),hl                    ;=> 01F0  22 30 00
        ld   (NN),ix                    ;=> 01F3  DD 22 30 00
        ld   (NN),iy                    ;=> 01F7  FD 22 30 00
        ld   (NN),sp                    ;=> 01FB  ED 73 30 00
        ld   sp,hl                      ;=> 01FF  F9
        ld   sp,ix                      ;=> 0200  DD F9
        ld   sp,iy                      ;=> 0202  FD F9
        push bc                         ;=> 0204  C5
        push de                         ;=> 0205  D5
        push hl                         ;=> 0206  E5
        push ix                         ;=> 0207  DD E5
        push iy                         ;=> 0209  FD E5
        push af                         ;=> 020B  F5
        pop  bc                         ;=> 020C  C1
        pop  de                         ;=> 020D  D1
        pop  hl                         ;=> 020E  E1
        pop  ix                         ;=> 020F  DD E1
        pop  iy                         ;=> 0211  FD E1
        pop  af                         ;=> 0213  F1

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

        ex   de,hl                      ;=> 0214  EB
        ex   af,af                      ;=> 0215  08
        ex   af,af'                     ;=> 0216  08
        exx                             ;=> 0217  D9
        
        ex   (sp),hl                    ;=> 0218  ED 54
        ex   (sp),ix                    ;=> 021A  DD E3
        ex   (sp),iy                    ;=> 021C  FD E3

        ldi                             ;=> 021E  ED A0
        ldir                            ;=> 0220  ED B0
        ldd                             ;=> 0222  ED A8
        lddr                            ;=> 0224  ED B8

        cpi                             ;=> 0226  CD 56 07
        cpir                            ;=> 0229  CD 73 07
        cpd                             ;=> 022C  CD 0D 07
        cpdr                            ;=> 022F  CD 2A 07

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  a,b                        ;=> 0232  80
        adc  a,b                        ;=> 0233  88
        sbc  a,b                        ;=> 0234  98
        add  a,c                        ;=> 0235  81
        adc  a,c                        ;=> 0236  89
        sbc  a,c                        ;=> 0237  99
        add  a,d                        ;=> 0238  82
        adc  a,d                        ;=> 0239  8A
        sbc  a,d                        ;=> 023A  9A
        add  a,e                        ;=> 023B  83
        adc  a,e                        ;=> 023C  8B
        sbc  a,e                        ;=> 023D  9B
        add  a,h                        ;=> 023E  84
        adc  a,h                        ;=> 023F  8C
        sbc  a,h                        ;=> 0240  9C
        add  a,l                        ;=> 0241  85
        adc  a,l                        ;=> 0242  8D
        sbc  a,l                        ;=> 0243  9D
        add  a,a                        ;=> 0244  87
        adc  a,a                        ;=> 0245  8F
        sbc  a,a                        ;=> 0246  9F
        add  a,(hl)                     ;=> 0247  86
        adc  a,(hl)                     ;=> 0248  8E
        sbc  a,(hl)                     ;=> 0249  9E
        add  a,(ix+DIS)                 ;=> 024A  DD 86 40
        adc  a,(ix+DIS)                 ;=> 024D  DD 8E 40
        sbc  a,(ix+DIS)                 ;=> 0250  DD 9E 40
        add  a,(iy+DIS)                 ;=> 0253  FD 86 40
        adc  a,(iy+DIS)                 ;=> 0256  FD 8E 40
        sbc  a,(iy+DIS)                 ;=> 0259  FD 9E 40
        add  a,N                        ;=> 025C  C6 20
        adc  a,N                        ;=> 025E  CE 20
        sbc  a,N                        ;=> 0260  DE 20
        sub  b                          ;=> 0262  90
        and  b                          ;=> 0263  A0
        xor  b                          ;=> 0264  A8
        or   b                          ;=> 0265  B0
        cp   b                          ;=> 0266  B8
        sub  c                          ;=> 0267  91
        and  c                          ;=> 0268  A1
        xor  c                          ;=> 0269  A9
        or   c                          ;=> 026A  B1
        cp   c                          ;=> 026B  B9
        sub  d                          ;=> 026C  92
        and  d                          ;=> 026D  A2
        xor  d                          ;=> 026E  AA
        or   d                          ;=> 026F  B2
        cp   d                          ;=> 0270  BA
        sub  e                          ;=> 0271  93
        and  e                          ;=> 0272  A3
        xor  e                          ;=> 0273  AB
        or   e                          ;=> 0274  B3
        cp   e                          ;=> 0275  BB
        sub  h                          ;=> 0276  94
        and  h                          ;=> 0277  A4
        xor  h                          ;=> 0278  AC
        or   h                          ;=> 0279  B4
        cp   h                          ;=> 027A  BC
        sub  l                          ;=> 027B  95
        and  l                          ;=> 027C  A5
        xor  l                          ;=> 027D  AD
        or   l                          ;=> 027E  B5
        cp   l                          ;=> 027F  BD
        sub  a                          ;=> 0280  97
        and  a                          ;=> 0281  A7
        xor  a                          ;=> 0282  AF
        or   a                          ;=> 0283  B7
        cp   a                          ;=> 0284  BF
        sub  (hl)                       ;=> 0285  96
        and  (hl)                       ;=> 0286  A6
        xor  (hl)                       ;=> 0287  AE
        or   (hl)                       ;=> 0288  B6
        cp   (hl)                       ;=> 0289  BE
        sub  (ix+DIS)                   ;=> 028A  DD 96 40
        and  (ix+DIS)                   ;=> 028D  DD A6 40
        xor  (ix+DIS)                   ;=> 0290  DD AE 40
        or   (ix+DIS)                   ;=> 0293  DD B6 40
        cp   (ix+DIS)                   ;=> 0296  DD BE 40
        sub  (iy+DIS)                   ;=> 0299  FD 96 40
        and  (iy+DIS)                   ;=> 029C  FD A6 40
        xor  (iy+DIS)                   ;=> 029F  FD AE 40
        or   (iy+DIS)                   ;=> 02A2  FD B6 40
        cp   (iy+DIS)                   ;=> 02A5  FD BE 40
        sub  N                          ;=> 02A8  D6 20
        and  N                          ;=> 02AA  E6 20
        xor  N                          ;=> 02AC  EE 20
        or   N                          ;=> 02AE  F6 20
        cp   N                          ;=> 02B0  FE 20
        inc  b                          ;=> 02B2  04
        dec  b                          ;=> 02B3  05
        inc  c                          ;=> 02B4  0C
        dec  c                          ;=> 02B5  0D
        inc  d                          ;=> 02B6  14
        dec  d                          ;=> 02B7  15
        inc  e                          ;=> 02B8  1C
        dec  e                          ;=> 02B9  1D
        inc  h                          ;=> 02BA  24
        dec  h                          ;=> 02BB  25
        inc  l                          ;=> 02BC  2C
        dec  l                          ;=> 02BD  2D
        inc  a                          ;=> 02BE  3C
        dec  a                          ;=> 02BF  3D
        inc  (hl)                       ;=> 02C0  34
        dec  (hl)                       ;=> 02C1  35
        inc  (ix+DIS)                   ;=> 02C2  DD 34 40
        dec  (ix+DIS)                   ;=> 02C5  DD 35 40
        inc  (iy+DIS)                   ;=> 02C8  FD 34 40
        dec  (iy+DIS)                   ;=> 02CB  FD 35 40
        

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  hl,bc                      ;=> 02CE  09
        add  hl,de                      ;=> 02CF  19
        add  hl,hl                      ;=> 02D0  29
        add  hl,sp                      ;=> 02D1  39
        add  ix,bc                      ;=> 02D2  DD 09
        add  ix,de                      ;=> 02D4  DD 19
        add  ix,ix                      ;=> 02D6  DD 29
        add  ix,sp                      ;=> 02D8  DD 39
        add  iy,bc                      ;=> 02DA  FD 09
        add  iy,de                      ;=> 02DC  FD 19
        add  iy,iy                      ;=> 02DE  FD 29
        add  iy,sp                      ;=> 02E0  FD 39

        sbc  hl,bc                      ;=> 02E2  ED 42
        adc  hl,bc                      ;=> 02E4  ED 4A
        sbc  hl,de                      ;=> 02E6  ED 52
        adc  hl,de                      ;=> 02E8  ED 5A
        sbc  hl,hl                      ;=> 02EA  ED 62
        adc  hl,hl                      ;=> 02EC  ED 6A
        sbc  hl,sp                      ;=> 02EE  ED 72
        adc  hl,sp                      ;=> 02F0  ED 7A
;	sub       hl,bc						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,de						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,hl						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,sp						=} 0xB7 0xED 0x42+<2:4>

        inc  bc                         ;=> 02F2  03
        dec  bc                         ;=> 02F3  0B
        inc  de                         ;=> 02F4  13
        dec  de                         ;=> 02F5  1B
        inc  hl                         ;=> 02F6  23
        dec  hl                         ;=> 02F7  2B
        inc  ix                         ;=> 02F8  DD 23
        dec  ix                         ;=> 02FA  DD 2B
        inc  iy                         ;=> 02FC  FD 23
        dec  iy                         ;=> 02FE  FD 2B
        inc  sp                         ;=> 0300  33
        dec  sp                         ;=> 0301  3B

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

        rlca                            ;=> 0302  07
        rrca                            ;=> 0303  0F
        rla                             ;=> 0304  17
        rra                             ;=> 0305  1F

        rlc  b                          ;=> 0306  CB 00
        rrc  b                          ;=> 0308  CB 08
        rl   b                          ;=> 030A  CB 10
        rr   b                          ;=> 030C  CB 18
        sla  b                          ;=> 030E  CB 20
        sra  b                          ;=> 0310  CB 28
        srl  b                          ;=> 0312  CB 38
        rlc  c                          ;=> 0314  CB 01
        rrc  c                          ;=> 0316  CB 09
        rl   c                          ;=> 0318  CB 11
        rr   c                          ;=> 031A  CB 19
        sla  c                          ;=> 031C  CB 21
        sra  c                          ;=> 031E  CB 29
        srl  c                          ;=> 0320  CB 39
        rlc  d                          ;=> 0322  CB 02
        rrc  d                          ;=> 0324  CB 0A
        rl   d                          ;=> 0326  CB 12
        rr   d                          ;=> 0328  CB 1A
        sla  d                          ;=> 032A  CB 22
        sra  d                          ;=> 032C  CB 2A
        srl  d                          ;=> 032E  CB 3A
        rlc  e                          ;=> 0330  CB 03
        rrc  e                          ;=> 0332  CB 0B
        rl   e                          ;=> 0334  CB 13
        rr   e                          ;=> 0336  CB 1B
        sla  e                          ;=> 0338  CB 23
        sra  e                          ;=> 033A  CB 2B
        srl  e                          ;=> 033C  CB 3B
        rlc  h                          ;=> 033E  CB 04
        rrc  h                          ;=> 0340  CB 0C
        rl   h                          ;=> 0342  CB 14
        rr   h                          ;=> 0344  CB 1C
        sla  h                          ;=> 0346  CB 24
        sra  h                          ;=> 0348  CB 2C
        srl  h                          ;=> 034A  CB 3C
        rlc  l                          ;=> 034C  CB 05
        rrc  l                          ;=> 034E  CB 0D
        rl   l                          ;=> 0350  CB 15
        rr   l                          ;=> 0352  CB 1D
        sla  l                          ;=> 0354  CB 25
        sra  l                          ;=> 0356  CB 2D
        srl  l                          ;=> 0358  CB 3D
        rlc  a                          ;=> 035A  CB 07
        rrc  a                          ;=> 035C  CB 0F
        rl   a                          ;=> 035E  CB 17
        rr   a                          ;=> 0360  CB 1F
        sla  a                          ;=> 0362  CB 27
        sra  a                          ;=> 0364  CB 2F
        srl  a                          ;=> 0366  CB 3F
        rlc  (hl)                       ;=> 0368  CB 06
        rrc  (hl)                       ;=> 036A  CB 0E
        rl   (hl)                       ;=> 036C  CB 16
        rr   (hl)                       ;=> 036E  CB 1E
        sla  (hl)                       ;=> 0370  CB 26
        sra  (hl)                       ;=> 0372  CB 2E
        srl  (hl)                       ;=> 0374  CB 3E
        rlc  (ix+DIS)                   ;=> 0376  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 037A  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 037E  DD CB 40 16
        rr   (ix+DIS)                   ;=> 0382  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 0386  DD CB 40 26
        sra  (ix+DIS)                   ;=> 038A  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 038E  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 0392  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 0396  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 039A  FD CB 40 16
        rr   (iy+DIS)                   ;=> 039E  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 03A2  FD CB 40 26
        sra  (iy+DIS)                   ;=> 03A6  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 03AA  FD CB 40 3E
        rlc  b                          ;=> 03AE  CB 00
        rrc  b                          ;=> 03B0  CB 08
        rl   b                          ;=> 03B2  CB 10
        rr   b                          ;=> 03B4  CB 18
        sla  b                          ;=> 03B6  CB 20
        sra  b                          ;=> 03B8  CB 28
        srl  b                          ;=> 03BA  CB 38
        rlc  c                          ;=> 03BC  CB 01
        rrc  c                          ;=> 03BE  CB 09
        rl   c                          ;=> 03C0  CB 11
        rr   c                          ;=> 03C2  CB 19
        sla  c                          ;=> 03C4  CB 21
        sra  c                          ;=> 03C6  CB 29
        srl  c                          ;=> 03C8  CB 39
        rlc  d                          ;=> 03CA  CB 02
        rrc  d                          ;=> 03CC  CB 0A
        rl   d                          ;=> 03CE  CB 12
        rr   d                          ;=> 03D0  CB 1A
        sla  d                          ;=> 03D2  CB 22
        sra  d                          ;=> 03D4  CB 2A
        srl  d                          ;=> 03D6  CB 3A
        rlc  e                          ;=> 03D8  CB 03
        rrc  e                          ;=> 03DA  CB 0B
        rl   e                          ;=> 03DC  CB 13
        rr   e                          ;=> 03DE  CB 1B
        sla  e                          ;=> 03E0  CB 23
        sra  e                          ;=> 03E2  CB 2B
        srl  e                          ;=> 03E4  CB 3B
        rlc  h                          ;=> 03E6  CB 04
        rrc  h                          ;=> 03E8  CB 0C
        rl   h                          ;=> 03EA  CB 14
        rr   h                          ;=> 03EC  CB 1C
        sla  h                          ;=> 03EE  CB 24
        sra  h                          ;=> 03F0  CB 2C
        srl  h                          ;=> 03F2  CB 3C
        rlc  l                          ;=> 03F4  CB 05
        rrc  l                          ;=> 03F6  CB 0D
        rl   l                          ;=> 03F8  CB 15
        rr   l                          ;=> 03FA  CB 1D
        sla  l                          ;=> 03FC  CB 25
        sra  l                          ;=> 03FE  CB 2D
        srl  l                          ;=> 0400  CB 3D
        rlc  a                          ;=> 0402  CB 07
        rrc  a                          ;=> 0404  CB 0F
        rl   a                          ;=> 0406  CB 17
        rr   a                          ;=> 0408  CB 1F
        sla  a                          ;=> 040A  CB 27
        sra  a                          ;=> 040C  CB 2F
        srl  a                          ;=> 040E  CB 3F
        rlc  (hl)                       ;=> 0410  CB 06
        rrc  (hl)                       ;=> 0412  CB 0E
        rl   (hl)                       ;=> 0414  CB 16
        rr   (hl)                       ;=> 0416  CB 1E
        sla  (hl)                       ;=> 0418  CB 26
        sra  (hl)                       ;=> 041A  CB 2E
        srl  (hl)                       ;=> 041C  CB 3E
        rlc  (ix+DIS)                   ;=> 041E  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 0422  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 0426  DD CB 40 16
        rr   (ix+DIS)                   ;=> 042A  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 042E  DD CB 40 26
        sra  (ix+DIS)                   ;=> 0432  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 0436  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 043A  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 043E  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 0442  FD CB 40 16
        rr   (iy+DIS)                   ;=> 0446  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 044A  FD CB 40 26
        sra  (iy+DIS)                   ;=> 044E  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 0452  FD CB 40 3E
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

        rld                             ;=> 0456  CD 9F 07
        rrd                             ;=> 0459  CD C1 07

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

        cpl                             ;=> 045C  2F
        neg                             ;=> 045D  ED 44
        ccf                             ;=> 045F  3F
        scf                             ;=> 0460  37
        nop                             ;=> 0461  00


;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

        bit  0,b                        ;=> 0462  CB 40
        res  0,b                        ;=> 0464  CB 80
        set  0,b                        ;=> 0466  CB C0
        bit  1,b                        ;=> 0468  CB 48
        res  1,b                        ;=> 046A  CB 88
        set  1,b                        ;=> 046C  CB C8
        bit  2,b                        ;=> 046E  CB 50
        res  2,b                        ;=> 0470  CB 90
        set  2,b                        ;=> 0472  CB D0
        bit  3,b                        ;=> 0474  CB 58
        res  3,b                        ;=> 0476  CB 98
        set  3,b                        ;=> 0478  CB D8
        bit  4,b                        ;=> 047A  CB 60
        res  4,b                        ;=> 047C  CB A0
        set  4,b                        ;=> 047E  CB E0
        bit  5,b                        ;=> 0480  CB 68
        res  5,b                        ;=> 0482  CB A8
        set  5,b                        ;=> 0484  CB E8
        bit  6,b                        ;=> 0486  CB 70
        res  6,b                        ;=> 0488  CB B0
        set  6,b                        ;=> 048A  CB F0
        bit  7,b                        ;=> 048C  CB 78
        res  7,b                        ;=> 048E  CB B8
        set  7,b                        ;=> 0490  CB F8
        bit  0,c                        ;=> 0492  CB 41
        res  0,c                        ;=> 0494  CB 81
        set  0,c                        ;=> 0496  CB C1
        bit  1,c                        ;=> 0498  CB 49
        res  1,c                        ;=> 049A  CB 89
        set  1,c                        ;=> 049C  CB C9
        bit  2,c                        ;=> 049E  CB 51
        res  2,c                        ;=> 04A0  CB 91
        set  2,c                        ;=> 04A2  CB D1
        bit  3,c                        ;=> 04A4  CB 59
        res  3,c                        ;=> 04A6  CB 99
        set  3,c                        ;=> 04A8  CB D9
        bit  4,c                        ;=> 04AA  CB 61
        res  4,c                        ;=> 04AC  CB A1
        set  4,c                        ;=> 04AE  CB E1
        bit  5,c                        ;=> 04B0  CB 69
        res  5,c                        ;=> 04B2  CB A9
        set  5,c                        ;=> 04B4  CB E9
        bit  6,c                        ;=> 04B6  CB 71
        res  6,c                        ;=> 04B8  CB B1
        set  6,c                        ;=> 04BA  CB F1
        bit  7,c                        ;=> 04BC  CB 79
        res  7,c                        ;=> 04BE  CB B9
        set  7,c                        ;=> 04C0  CB F9
        bit  0,d                        ;=> 04C2  CB 42
        res  0,d                        ;=> 04C4  CB 82
        set  0,d                        ;=> 04C6  CB C2
        bit  1,d                        ;=> 04C8  CB 4A
        res  1,d                        ;=> 04CA  CB 8A
        set  1,d                        ;=> 04CC  CB CA
        bit  2,d                        ;=> 04CE  CB 52
        res  2,d                        ;=> 04D0  CB 92
        set  2,d                        ;=> 04D2  CB D2
        bit  3,d                        ;=> 04D4  CB 5A
        res  3,d                        ;=> 04D6  CB 9A
        set  3,d                        ;=> 04D8  CB DA
        bit  4,d                        ;=> 04DA  CB 62
        res  4,d                        ;=> 04DC  CB A2
        set  4,d                        ;=> 04DE  CB E2
        bit  5,d                        ;=> 04E0  CB 6A
        res  5,d                        ;=> 04E2  CB AA
        set  5,d                        ;=> 04E4  CB EA
        bit  6,d                        ;=> 04E6  CB 72
        res  6,d                        ;=> 04E8  CB B2
        set  6,d                        ;=> 04EA  CB F2
        bit  7,d                        ;=> 04EC  CB 7A
        res  7,d                        ;=> 04EE  CB BA
        set  7,d                        ;=> 04F0  CB FA
        bit  0,e                        ;=> 04F2  CB 43
        res  0,e                        ;=> 04F4  CB 83
        set  0,e                        ;=> 04F6  CB C3
        bit  1,e                        ;=> 04F8  CB 4B
        res  1,e                        ;=> 04FA  CB 8B
        set  1,e                        ;=> 04FC  CB CB
        bit  2,e                        ;=> 04FE  CB 53
        res  2,e                        ;=> 0500  CB 93
        set  2,e                        ;=> 0502  CB D3
        bit  3,e                        ;=> 0504  CB 5B
        res  3,e                        ;=> 0506  CB 9B
        set  3,e                        ;=> 0508  CB DB
        bit  4,e                        ;=> 050A  CB 63
        res  4,e                        ;=> 050C  CB A3
        set  4,e                        ;=> 050E  CB E3
        bit  5,e                        ;=> 0510  CB 6B
        res  5,e                        ;=> 0512  CB AB
        set  5,e                        ;=> 0514  CB EB
        bit  6,e                        ;=> 0516  CB 73
        res  6,e                        ;=> 0518  CB B3
        set  6,e                        ;=> 051A  CB F3
        bit  7,e                        ;=> 051C  CB 7B
        res  7,e                        ;=> 051E  CB BB
        set  7,e                        ;=> 0520  CB FB
        bit  0,h                        ;=> 0522  CB 44
        res  0,h                        ;=> 0524  CB 84
        set  0,h                        ;=> 0526  CB C4
        bit  1,h                        ;=> 0528  CB 4C
        res  1,h                        ;=> 052A  CB 8C
        set  1,h                        ;=> 052C  CB CC
        bit  2,h                        ;=> 052E  CB 54
        res  2,h                        ;=> 0530  CB 94
        set  2,h                        ;=> 0532  CB D4
        bit  3,h                        ;=> 0534  CB 5C
        res  3,h                        ;=> 0536  CB 9C
        set  3,h                        ;=> 0538  CB DC
        bit  4,h                        ;=> 053A  CB 64
        res  4,h                        ;=> 053C  CB A4
        set  4,h                        ;=> 053E  CB E4
        bit  5,h                        ;=> 0540  CB 6C
        res  5,h                        ;=> 0542  CB AC
        set  5,h                        ;=> 0544  CB EC
        bit  6,h                        ;=> 0546  CB 74
        res  6,h                        ;=> 0548  CB B4
        set  6,h                        ;=> 054A  CB F4
        bit  7,h                        ;=> 054C  CB 7C
        res  7,h                        ;=> 054E  CB BC
        set  7,h                        ;=> 0550  CB FC
        bit  0,l                        ;=> 0552  CB 45
        res  0,l                        ;=> 0554  CB 85
        set  0,l                        ;=> 0556  CB C5
        bit  1,l                        ;=> 0558  CB 4D
        res  1,l                        ;=> 055A  CB 8D
        set  1,l                        ;=> 055C  CB CD
        bit  2,l                        ;=> 055E  CB 55
        res  2,l                        ;=> 0560  CB 95
        set  2,l                        ;=> 0562  CB D5
        bit  3,l                        ;=> 0564  CB 5D
        res  3,l                        ;=> 0566  CB 9D
        set  3,l                        ;=> 0568  CB DD
        bit  4,l                        ;=> 056A  CB 65
        res  4,l                        ;=> 056C  CB A5
        set  4,l                        ;=> 056E  CB E5
        bit  5,l                        ;=> 0570  CB 6D
        res  5,l                        ;=> 0572  CB AD
        set  5,l                        ;=> 0574  CB ED
        bit  6,l                        ;=> 0576  CB 75
        res  6,l                        ;=> 0578  CB B5
        set  6,l                        ;=> 057A  CB F5
        bit  7,l                        ;=> 057C  CB 7D
        res  7,l                        ;=> 057E  CB BD
        set  7,l                        ;=> 0580  CB FD
        bit  0,a                        ;=> 0582  CB 47
        res  0,a                        ;=> 0584  CB 87
        set  0,a                        ;=> 0586  CB C7
        bit  1,a                        ;=> 0588  CB 4F
        res  1,a                        ;=> 058A  CB 8F
        set  1,a                        ;=> 058C  CB CF
        bit  2,a                        ;=> 058E  CB 57
        res  2,a                        ;=> 0590  CB 97
        set  2,a                        ;=> 0592  CB D7
        bit  3,a                        ;=> 0594  CB 5F
        res  3,a                        ;=> 0596  CB 9F
        set  3,a                        ;=> 0598  CB DF
        bit  4,a                        ;=> 059A  CB 67
        res  4,a                        ;=> 059C  CB A7
        set  4,a                        ;=> 059E  CB E7
        bit  5,a                        ;=> 05A0  CB 6F
        res  5,a                        ;=> 05A2  CB AF
        set  5,a                        ;=> 05A4  CB EF
        bit  6,a                        ;=> 05A6  CB 77
        res  6,a                        ;=> 05A8  CB B7
        set  6,a                        ;=> 05AA  CB F7
        bit  7,a                        ;=> 05AC  CB 7F
        res  7,a                        ;=> 05AE  CB BF
        set  7,a                        ;=> 05B0  CB FF
        bit  0,(hl)                     ;=> 05B2  CB 46
        res  0,(hl)                     ;=> 05B4  CB 86
        set  0,(hl)                     ;=> 05B6  CB C6
        bit  1,(hl)                     ;=> 05B8  CB 4E
        res  1,(hl)                     ;=> 05BA  CB 8E
        set  1,(hl)                     ;=> 05BC  CB CE
        bit  2,(hl)                     ;=> 05BE  CB 56
        res  2,(hl)                     ;=> 05C0  CB 96
        set  2,(hl)                     ;=> 05C2  CB D6
        bit  3,(hl)                     ;=> 05C4  CB 5E
        res  3,(hl)                     ;=> 05C6  CB 9E
        set  3,(hl)                     ;=> 05C8  CB DE
        bit  4,(hl)                     ;=> 05CA  CB 66
        res  4,(hl)                     ;=> 05CC  CB A6
        set  4,(hl)                     ;=> 05CE  CB E6
        bit  5,(hl)                     ;=> 05D0  CB 6E
        res  5,(hl)                     ;=> 05D2  CB AE
        set  5,(hl)                     ;=> 05D4  CB EE
        bit  6,(hl)                     ;=> 05D6  CB 76
        res  6,(hl)                     ;=> 05D8  CB B6
        set  6,(hl)                     ;=> 05DA  CB F6
        bit  7,(hl)                     ;=> 05DC  CB 7E
        res  7,(hl)                     ;=> 05DE  CB BE
        set  7,(hl)                     ;=> 05E0  CB FE
        bit  0,(ix+DIS)                 ;=> 05E2  DD CB 40 46
        res  0,(ix+DIS)                 ;=> 05E6  DD CB 40 86
        set  0,(ix+DIS)                 ;=> 05EA  DD CB 40 C6
        bit  1,(ix+DIS)                 ;=> 05EE  DD CB 40 4E
        res  1,(ix+DIS)                 ;=> 05F2  DD CB 40 8E
        set  1,(ix+DIS)                 ;=> 05F6  DD CB 40 CE
        bit  2,(ix+DIS)                 ;=> 05FA  DD CB 40 56
        res  2,(ix+DIS)                 ;=> 05FE  DD CB 40 96
        set  2,(ix+DIS)                 ;=> 0602  DD CB 40 D6
        bit  3,(ix+DIS)                 ;=> 0606  DD CB 40 5E
        res  3,(ix+DIS)                 ;=> 060A  DD CB 40 9E
        set  3,(ix+DIS)                 ;=> 060E  DD CB 40 DE
        bit  4,(ix+DIS)                 ;=> 0612  DD CB 40 66
        res  4,(ix+DIS)                 ;=> 0616  DD CB 40 A6
        set  4,(ix+DIS)                 ;=> 061A  DD CB 40 E6
        bit  5,(ix+DIS)                 ;=> 061E  DD CB 40 6E
        res  5,(ix+DIS)                 ;=> 0622  DD CB 40 AE
        set  5,(ix+DIS)                 ;=> 0626  DD CB 40 EE
        bit  6,(ix+DIS)                 ;=> 062A  DD CB 40 76
        res  6,(ix+DIS)                 ;=> 062E  DD CB 40 B6
        set  6,(ix+DIS)                 ;=> 0632  DD CB 40 F6
        bit  7,(ix+DIS)                 ;=> 0636  DD CB 40 7E
        res  7,(ix+DIS)                 ;=> 063A  DD CB 40 BE
        set  7,(ix+DIS)                 ;=> 063E  DD CB 40 FE
        bit  0,(iy+DIS)                 ;=> 0642  FD CB 40 46
        res  0,(iy+DIS)                 ;=> 0646  FD CB 40 86
        set  0,(iy+DIS)                 ;=> 064A  FD CB 40 C6
        bit  1,(iy+DIS)                 ;=> 064E  FD CB 40 4E
        res  1,(iy+DIS)                 ;=> 0652  FD CB 40 8E
        set  1,(iy+DIS)                 ;=> 0656  FD CB 40 CE
        bit  2,(iy+DIS)                 ;=> 065A  FD CB 40 56
        res  2,(iy+DIS)                 ;=> 065E  FD CB 40 96
        set  2,(iy+DIS)                 ;=> 0662  FD CB 40 D6
        bit  3,(iy+DIS)                 ;=> 0666  FD CB 40 5E
        res  3,(iy+DIS)                 ;=> 066A  FD CB 40 9E
        set  3,(iy+DIS)                 ;=> 066E  FD CB 40 DE
        bit  4,(iy+DIS)                 ;=> 0672  FD CB 40 66
        res  4,(iy+DIS)                 ;=> 0676  FD CB 40 A6
        set  4,(iy+DIS)                 ;=> 067A  FD CB 40 E6
        bit  5,(iy+DIS)                 ;=> 067E  FD CB 40 6E
        res  5,(iy+DIS)                 ;=> 0682  FD CB 40 AE
        set  5,(iy+DIS)                 ;=> 0686  FD CB 40 EE
        bit  6,(iy+DIS)                 ;=> 068A  FD CB 40 76
        res  6,(iy+DIS)                 ;=> 068E  FD CB 40 B6
        set  6,(iy+DIS)                 ;=> 0692  FD CB 40 F6
        bit  7,(iy+DIS)                 ;=> 0696  FD CB 40 7E
        res  7,(iy+DIS)                 ;=> 069A  FD CB 40 BE
        set  7,(iy+DIS)                 ;=> 069E  FD CB 40 FE
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
        jp   NN                         ;=> 06A2  C3 30 00
        jp   (hl)                       ;=> 06A5  E9
        jp   (ix)                       ;=> 06A6  DD E9
        jp   (iy)                       ;=> 06A8  FD E9
        jp   nz,NN                      ;=> 06AA  C2 30 00
        jp   z,NN                       ;=> 06AD  CA 30 00
        jp   nc,NN                      ;=> 06B0  D2 30 00
        jp   c,NN                       ;=> 06B3  DA 30 00
        jp   po,NN                      ;=> 06B6  E2 30 00
        jp   pe,NN                      ;=> 06B9  EA 30 00
        jp   p,NN                       ;=> 06BC  F2 30 00
        jp   m,NN                       ;=> 06BF  FA 30 00

        jr   jr1                        ;=> 06C2  18 DE
        djnz jr1                        ;=> 06C4  10 DC
        jr   nz,jr1                     ;=> 06C6  20 DA
        jr   z,jr1                      ;=> 06C8  28 D8
        jr   nc,jr1                     ;=> 06CA  30 D6
        jr   c,jr1                      ;=> 06CC  38 D4
;	jr po,NN
;	jr pe,NN
;	jr p,NN
;	jr m,NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

        call NN                         ;=> 06CE  CD 30 00
        ret                             ;=> 06D1  C9
        ret  nz                         ;=> 06D2  C0
        ret  z                          ;=> 06D3  C8
        ret  nc                         ;=> 06D4  D0
        ret  c                          ;=> 06D5  D8
        ret  po                         ;=> 06D6  E0
        ret  pe                         ;=> 06D7  E8
        ret  p                          ;=> 06D8  F0
        ret  m                          ;=> 06D9  F8
        reti                            ;=> 06DA  ED 4D
;	rst 0
;	rst 1
;	rst 2
;	rst 3
;	rst 4
;	rst 5
;	rst 6
;	rst 7


        call nz,NN                      ;=> 06DC  28 03 CD 30 00
        call z,NN                       ;=> 06E1  20 03 CD 30 00
        call nc,NN                      ;=> 06E6  38 03 CD 30 00
        call c,NN                       ;=> 06EB  30 03 CD 30 00
        call po,NN                      ;=> 06F0  EA F6 06 CD 30 00
        call pe,NN                      ;=> 06F6  E2 FC 06 CD 30 00
        call p,NN                       ;=> 06FC  FA 02 07 CD 30 00
        call m,NN                       ;=> 0702  F2 08 07 CD 30 00
        rst  10h                        ;=> 0708  D7
        rst  18h                        ;=> 0709  DF
        rst  20h                        ;=> 070A  E7
        rst  28h                        ;=> 070B  EF
        rst  38h                        ;=> 070C  FF



;------------------------------------------------------------------------------
; 
; Revision 1.2  2014/04/26 08:14:01  pauloscustodio
; ws
;
; Revision 1.1  2014/04/25 23:52:17  pauloscustodio
; Rename input file for z80opcodes generation
;
;
                                        ;=> 070D  38 12 BE 2B 0B F5 E3 CB 85 CB D5 78 B1 20 02 CB 95 E3 F1 C9 BE 2B 0B F5 E3 CB C5 18 EC 30 06 CD 32 07 37 C9 2B 0B BE 28 12 0C 0D 20 F7 04 10 F4 BE 2B F5 E3 CB 85 CB 95 E3 F1 C9 2B F5 78 B1 28 F2 E3 CB 85 CB D5 E3 F1 C9 38 12 BE 23 0B F5 E3 CB 85 CB D5 78 B1 20 02 CB 95 E3 F1 C9 BE 23 0B F5 E3 CB C5 18 EC 30 06 CD 7B 07 37 C9 23 0B BE 28 12 0C 0D 20 F7 04 10 F4 BE 23 F5 E3 CB 85 CB 95 E3 F1 C9 23 F5 78 B1 28 F2 E3 CB 85 CB D5 E3 F1 C9 30 05 CD A6 07 37 C9 07 07 07 07 CB 27 CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 B7 C9 30 05 CD C8 07 37 C9 CB 3F CB 1E 1F CB 1E 1F CB 1E 1F CB 1E 1F 1F 1F 1F 1F B7 C9
