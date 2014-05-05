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
; Value ranges
;------------------------------------------------------------------------------

										; z80pack does not allow negative indexes
        ld   a,(ix-128)                 ;=> 0100  DD 7E 80
        ld   a,(iy-128)                 ;=> 0103  FD 7E 80
        ld   a,(ix)                     ;=> 0106  DD 7E 00
        ld   a,(iy)                     ;=> 0109  FD 7E 00
        ld   a,(ix+0)                   ;=> 010C  DD 7E 00
        ld   a,(iy+0)                   ;=> 010F  FD 7E 00
        ld   a,(ix+127)                 ;=> 0112  DD 7E 7F
        ld   a,(iy+127)                 ;=> 0115  FD 7E 7F

        ld   a,-128                     ;=> 0118  3E 80
        ld   a,0                        ;=> 011A  3E 00
        ld   a,255                      ;=> 011C  3E FF
        ld   bc,-32768                  ;=> 011E  01 00 80
        ld   bc,-1                      ;=> 0121  01 FF FF
        ld   bc,0                       ;=> 0124  01 00 00
        ld   bc,65535                   ;=> 0127  01 FF FF
        jp   -32768                     ;=> 012A  C3 00 80
        jp   -1                         ;=> 012D  C3 FF FF
        jp   0                          ;=> 0130  C3 00 00
        jp   65535                      ;=> 0133  C3 FF FF

;------------------------------------------------------------------------------
; Regression tests
;------------------------------------------------------------------------------

; BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
bug0047a:
        defw ASMPC,ASMPC,ASMPC          ;=> 0136  36 01 36 01 36 01
bug0047b: 
        jp   ASMPC                      ;=> 013C  C3 3C 01

;------------------------------------------------------------------------------
; IF ELSE ENDIF
;------------------------------------------------------------------------------
        if   1 
        defb 1                          ;=> 013F  01
        if   1 
        defb 2                          ;=> 0140  02
        else 
        defb 3 
        endif 
        else 
        defb 4 
        if   1 
        defb 5 
        else 
        defb 6 
        endif 
        endif 

        if   0 
        defb 7 
        endif 
        
        if   1 
        defb 8                          ;=> 0141  08
        endif 
        
        if   0 
        defb 9 
        else 
        defb 10                         ;=> 0142  0A
        endif 
        
        if   undefined 
        defb 11 
        else 
        defb 12                         ;=> 0143  0C
        endif 

        if   undefined | 1 
        defb 13                         ;=> 0144  0D
        else 
        defb 14 
        endif 

;------------------------------------------------------------------------------
; Z88DK specific opcodes
;------------------------------------------------------------------------------
        call_oz 1                       ;=> 0145  E7 01
        call_oz 255                     ;=> 0147  E7 FF
        call_oz 256                     ;=> 0149  E7 00 01
        call_oz 65535                   ;=> 014C  E7 FF FF

        call_pkg 0                      ;=> 014F  CF 00 00
        call_pkg 1                      ;=> 0152  CF 01 00
        call_pkg 65535                  ;=> 0155  CF FF FF
        
        fpp  1                          ;=> 0158  DF 01
        fpp  254                        ;=> 015A  DF FE

        invoke 0                        ;=> 015C  CD 00 00
        invoke 1                        ;=> 015F  CD 01 00
        invoke 65535                    ;=> 0162  CD FF FF
        
;------------------------------------------------------------------------------
; 8 bit load group
;------------------------------------------------------------------------------

        ld   b,b                        ;=> 0165  40
        ld   c,b                        ;=> 0166  48
        ld   d,b                        ;=> 0167  50
        ld   e,b                        ;=> 0168  58
        ld   h,b                        ;=> 0169  60
        ld   l,b                        ;=> 016A  68
        ld   a,b                        ;=> 016B  78
        ld   b,c                        ;=> 016C  41
        ld   c,c                        ;=> 016D  49
        ld   d,c                        ;=> 016E  51
        ld   e,c                        ;=> 016F  59
        ld   h,c                        ;=> 0170  61
        ld   l,c                        ;=> 0171  69
        ld   a,c                        ;=> 0172  79
        ld   b,d                        ;=> 0173  42
        ld   c,d                        ;=> 0174  4A
        ld   d,d                        ;=> 0175  52
        ld   e,d                        ;=> 0176  5A
        ld   h,d                        ;=> 0177  62
        ld   l,d                        ;=> 0178  6A
        ld   a,d                        ;=> 0179  7A
        ld   b,e                        ;=> 017A  43
        ld   c,e                        ;=> 017B  4B
        ld   d,e                        ;=> 017C  53
        ld   e,e                        ;=> 017D  5B
        ld   h,e                        ;=> 017E  63
        ld   l,e                        ;=> 017F  6B
        ld   a,e                        ;=> 0180  7B
        ld   b,h                        ;=> 0181  44
        ld   c,h                        ;=> 0182  4C
        ld   d,h                        ;=> 0183  54
        ld   e,h                        ;=> 0184  5C
        ld   h,h                        ;=> 0185  64
        ld   l,h                        ;=> 0186  6C
        ld   a,h                        ;=> 0187  7C
        ld   b,l                        ;=> 0188  45
        ld   c,l                        ;=> 0189  4D
        ld   d,l                        ;=> 018A  55
        ld   e,l                        ;=> 018B  5D
        ld   h,l                        ;=> 018C  65
        ld   l,l                        ;=> 018D  6D
        ld   a,l                        ;=> 018E  7D
        ld   b,a                        ;=> 018F  47
        ld   c,a                        ;=> 0190  4F
        ld   d,a                        ;=> 0191  57
        ld   e,a                        ;=> 0192  5F
        ld   h,a                        ;=> 0193  67
        ld   l,a                        ;=> 0194  6F
        ld   a,a                        ;=> 0195  7F
        ld   b,N                        ;=> 0196  06 20
        ld   c,N                        ;=> 0198  0E 20
        ld   d,N                        ;=> 019A  16 20
        ld   e,N                        ;=> 019C  1E 20
        ld   h,N                        ;=> 019E  26 20
        ld   l,N                        ;=> 01A0  2E 20
        ld   a,N                        ;=> 01A2  3E 20


        ld   b,(hl)                     ;=> 01A4  46
        ld   c,(hl)                     ;=> 01A5  4E
        ld   d,(hl)                     ;=> 01A6  56
        ld   e,(hl)                     ;=> 01A7  5E
        ld   h,(hl)                     ;=> 01A8  66
        ld   l,(hl)                     ;=> 01A9  6E
        ld   a,(hl)                     ;=> 01AA  7E
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

        ld   b,(ix+DIS)                 ;=> 01AB  DD 46 40
        ld   c,(ix+DIS)                 ;=> 01AE  DD 4E 40
        ld   d,(ix+DIS)                 ;=> 01B1  DD 56 40
        ld   e,(ix+DIS)                 ;=> 01B4  DD 5E 40
        ld   h,(ix+DIS)                 ;=> 01B7  DD 66 40
        ld   l,(ix+DIS)                 ;=> 01BA  DD 6E 40
        ld   a,(ix+DIS)                 ;=> 01BD  DD 7E 40
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

        ld   b,(iy+DIS)                 ;=> 01C0  FD 46 40
        ld   c,(iy+DIS)                 ;=> 01C3  FD 4E 40
        ld   d,(iy+DIS)                 ;=> 01C6  FD 56 40
        ld   e,(iy+DIS)                 ;=> 01C9  FD 5E 40
        ld   h,(iy+DIS)                 ;=> 01CC  FD 66 40
        ld   l,(iy+DIS)                 ;=> 01CF  FD 6E 40
        ld   a,(iy+DIS)                 ;=> 01D2  FD 7E 40
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

        ld   (hl),b                     ;=> 01D5  70
        ld   (hl),c                     ;=> 01D6  71
        ld   (hl),d                     ;=> 01D7  72
        ld   (hl),e                     ;=> 01D8  73
        ld   (hl),h                     ;=> 01D9  74
        ld   (hl),l                     ;=> 01DA  75
        ld   (hl),a                     ;=> 01DB  77
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

        ld   (ix+DIS),b                 ;=> 01DC  DD 70 40
        ld   (ix+DIS),c                 ;=> 01DF  DD 71 40
        ld   (ix+DIS),d                 ;=> 01E2  DD 72 40
        ld   (ix+DIS),e                 ;=> 01E5  DD 73 40
        ld   (ix+DIS),h                 ;=> 01E8  DD 74 40
        ld   (ix+DIS),l                 ;=> 01EB  DD 75 40
        ld   (ix+DIS),a                 ;=> 01EE  DD 77 40
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

        ld   (iy+DIS),b                 ;=> 01F1  FD 70 40
        ld   (iy+DIS),c                 ;=> 01F4  FD 71 40
        ld   (iy+DIS),d                 ;=> 01F7  FD 72 40
        ld   (iy+DIS),e                 ;=> 01FA  FD 73 40
        ld   (iy+DIS),h                 ;=> 01FD  FD 74 40
        ld   (iy+DIS),l                 ;=> 0200  FD 75 40
        ld   (iy+DIS),a                 ;=> 0203  FD 77 40
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

        ld   (hl),N                     ;=> 0206  36 20
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

        ld   (ix+DIS),N                 ;=> 0208  DD 36 40 20
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

        ld   (iy+DIS),N                 ;=> 020C  FD 36 40 20
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

        ld   a,(bc)                     ;=> 0210  0A
        ld   a,(de)                     ;=> 0211  1A
;	ldi	a,(bc)						;;	ld	a,(bc) ;; inc bc
;	ldi	a,(de)						;;	ld	a,(de) ;; inc de
;	ldd	a,(bc)						;;	ld	a,(bc) ;; dec bc
;	ldd	a,(de)						;;	ld	a,(de) ;; dec de

        ld   (bc),a                     ;=> 0212  02
        ld   (de),a                     ;=> 0213  12
;	ldi	(bc),a						;;	ld	(bc),a ;; inc bc
;	ldi	(de),a						;;	ld	(de),a ;; inc de
;	ldd	(bc),a						;;	ld	(bc),a ;; dec bc
;	ldd	(de),a						;;	ld	(de),a ;; dec de

        ld   a,(NN)                     ;=> 0214  3A 30 00
        ld   (NN),a                     ;=> 0217  32 30 00

        ld   a,iir                      ;=> 021A  ED 57
        ld   a,eir                      ;=> 021C  ED 5F
        ld   iir,a                      ;=> 021E  ED 47
        ld   eir,a                      ;=> 0220  ED 4F

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

        ld   bc,NN                      ;=> 0222  01 30 00
        ld   de,NN                      ;=> 0225  11 30 00
        ld   hl,NN                      ;=> 0228  21 30 00
        ld   ix,NN                      ;=> 022B  DD 21 30 00
        ld   iy,NN                      ;=> 022F  FD 21 30 00
        ld   sp,NN                      ;=> 0233  31 30 00
        ld   bc,(NN)                    ;=> 0236  ED 4B 30 00
        ld   de,(NN)                    ;=> 023A  ED 5B 30 00
        ld   hl,(NN)                    ;=> 023E  2A 30 00
        ld   ix,(NN)                    ;=> 0241  DD 2A 30 00
        ld   iy,(NN)                    ;=> 0245  FD 2A 30 00
        ld   sp,(NN)                    ;=> 0249  ED 7B 30 00
        ld   (NN),bc                    ;=> 024D  ED 43 30 00
        ld   (NN),de                    ;=> 0251  ED 53 30 00
        ld   (NN),hl                    ;=> 0255  22 30 00
        ld   (NN),ix                    ;=> 0258  DD 22 30 00
        ld   (NN),iy                    ;=> 025C  FD 22 30 00
        ld   (NN),sp                    ;=> 0260  ED 73 30 00
        ld   sp,hl                      ;=> 0264  F9
        ld   sp,ix                      ;=> 0265  DD F9
        ld   sp,iy                      ;=> 0267  FD F9
        push bc                         ;=> 0269  C5
        push de                         ;=> 026A  D5
        push hl                         ;=> 026B  E5
        push ix                         ;=> 026C  DD E5
        push iy                         ;=> 026E  FD E5
        push af                         ;=> 0270  F5
        pop  bc                         ;=> 0271  C1
        pop  de                         ;=> 0272  D1
        pop  hl                         ;=> 0273  E1
        pop  ix                         ;=> 0274  DD E1
        pop  iy                         ;=> 0276  FD E1
        pop  af                         ;=> 0278  F1

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

        ex   de,hl                      ;=> 0279  EB
        ex   af,af                      ;=> 027A  08
        ex   af,af'                     ;=> 027B  08
        exx                             ;=> 027C  D9
        
        ex   (sp),hl                    ;=> 027D  ED 54
        ex   (sp),ix                    ;=> 027F  DD E3
        ex   (sp),iy                    ;=> 0281  FD E3

        ldi                             ;=> 0283  ED A0
        ldir                            ;=> 0285  ED B0
        ldd                             ;=> 0287  ED A8
        lddr                            ;=> 0289  ED B8

        cpi                             ;=> 028B  CD 88 08
        cpir                            ;=> 028E  CD A5 08
        cpd                             ;=> 0291  CD 3F 08
        cpdr                            ;=> 0294  CD 5C 08

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  a,b                        ;=> 0297  80
        adc  a,b                        ;=> 0298  88
        sbc  a,b                        ;=> 0299  98
        add  a,c                        ;=> 029A  81
        adc  a,c                        ;=> 029B  89
        sbc  a,c                        ;=> 029C  99
        add  a,d                        ;=> 029D  82
        adc  a,d                        ;=> 029E  8A
        sbc  a,d                        ;=> 029F  9A
        add  a,e                        ;=> 02A0  83
        adc  a,e                        ;=> 02A1  8B
        sbc  a,e                        ;=> 02A2  9B
        add  a,h                        ;=> 02A3  84
        adc  a,h                        ;=> 02A4  8C
        sbc  a,h                        ;=> 02A5  9C
        add  a,l                        ;=> 02A6  85
        adc  a,l                        ;=> 02A7  8D
        sbc  a,l                        ;=> 02A8  9D
        add  a,a                        ;=> 02A9  87
        adc  a,a                        ;=> 02AA  8F
        sbc  a,a                        ;=> 02AB  9F
        add  a,(hl)                     ;=> 02AC  86
        adc  a,(hl)                     ;=> 02AD  8E
        sbc  a,(hl)                     ;=> 02AE  9E
        add  a,(ix+DIS)                 ;=> 02AF  DD 86 40
        adc  a,(ix+DIS)                 ;=> 02B2  DD 8E 40
        sbc  a,(ix+DIS)                 ;=> 02B5  DD 9E 40
        add  a,(iy+DIS)                 ;=> 02B8  FD 86 40
        adc  a,(iy+DIS)                 ;=> 02BB  FD 8E 40
        sbc  a,(iy+DIS)                 ;=> 02BE  FD 9E 40
        add  a,N                        ;=> 02C1  C6 20
        adc  a,N                        ;=> 02C3  CE 20
        sbc  a,N                        ;=> 02C5  DE 20
        add  b                          ;=> 02C7  80
        adc  b                          ;=> 02C8  88
        sbc  b                          ;=> 02C9  98
        add  c                          ;=> 02CA  81
        adc  c                          ;=> 02CB  89
        sbc  c                          ;=> 02CC  99
        add  d                          ;=> 02CD  82
        adc  d                          ;=> 02CE  8A
        sbc  d                          ;=> 02CF  9A
        add  e                          ;=> 02D0  83
        adc  e                          ;=> 02D1  8B
        sbc  e                          ;=> 02D2  9B
        add  h                          ;=> 02D3  84
        adc  h                          ;=> 02D4  8C
        sbc  h                          ;=> 02D5  9C
        add  l                          ;=> 02D6  85
        adc  l                          ;=> 02D7  8D
        sbc  l                          ;=> 02D8  9D
        add  a                          ;=> 02D9  87
        adc  a                          ;=> 02DA  8F
        sbc  a                          ;=> 02DB  9F
        add  (hl)                       ;=> 02DC  86
        adc  (hl)                       ;=> 02DD  8E
        sbc  (hl)                       ;=> 02DE  9E
        add  (ix+DIS)                   ;=> 02DF  DD 86 40
        adc  (ix+DIS)                   ;=> 02E2  DD 8E 40
        sbc  (ix+DIS)                   ;=> 02E5  DD 9E 40
        add  (iy+DIS)                   ;=> 02E8  FD 86 40
        adc  (iy+DIS)                   ;=> 02EB  FD 8E 40
        sbc  (iy+DIS)                   ;=> 02EE  FD 9E 40
        add  N                          ;=> 02F1  C6 20
        adc  N                          ;=> 02F3  CE 20
        sbc  N                          ;=> 02F5  DE 20
        
        sub  b                          ;=> 02F7  90
        and  b                          ;=> 02F8  A0
        xor  b                          ;=> 02F9  A8
        or   b                          ;=> 02FA  B0
        cp   b                          ;=> 02FB  B8
        sub  c                          ;=> 02FC  91
        and  c                          ;=> 02FD  A1
        xor  c                          ;=> 02FE  A9
        or   c                          ;=> 02FF  B1
        cp   c                          ;=> 0300  B9
        sub  d                          ;=> 0301  92
        and  d                          ;=> 0302  A2
        xor  d                          ;=> 0303  AA
        or   d                          ;=> 0304  B2
        cp   d                          ;=> 0305  BA
        sub  e                          ;=> 0306  93
        and  e                          ;=> 0307  A3
        xor  e                          ;=> 0308  AB
        or   e                          ;=> 0309  B3
        cp   e                          ;=> 030A  BB
        sub  h                          ;=> 030B  94
        and  h                          ;=> 030C  A4
        xor  h                          ;=> 030D  AC
        or   h                          ;=> 030E  B4
        cp   h                          ;=> 030F  BC
        sub  l                          ;=> 0310  95
        and  l                          ;=> 0311  A5
        xor  l                          ;=> 0312  AD
        or   l                          ;=> 0313  B5
        cp   l                          ;=> 0314  BD
        sub  a                          ;=> 0315  97
        and  a                          ;=> 0316  A7
        xor  a                          ;=> 0317  AF
        or   a                          ;=> 0318  B7
        cp   a                          ;=> 0319  BF
        sub  (hl)                       ;=> 031A  96
        and  (hl)                       ;=> 031B  A6
        xor  (hl)                       ;=> 031C  AE
        or   (hl)                       ;=> 031D  B6
        cp   (hl)                       ;=> 031E  BE
        sub  (ix+DIS)                   ;=> 031F  DD 96 40
        and  (ix+DIS)                   ;=> 0322  DD A6 40
        xor  (ix+DIS)                   ;=> 0325  DD AE 40
        or   (ix+DIS)                   ;=> 0328  DD B6 40
        cp   (ix+DIS)                   ;=> 032B  DD BE 40
        sub  (iy+DIS)                   ;=> 032E  FD 96 40
        and  (iy+DIS)                   ;=> 0331  FD A6 40
        xor  (iy+DIS)                   ;=> 0334  FD AE 40
        or   (iy+DIS)                   ;=> 0337  FD B6 40
        cp   (iy+DIS)                   ;=> 033A  FD BE 40
        sub  N                          ;=> 033D  D6 20
        and  N                          ;=> 033F  E6 20
        xor  N                          ;=> 0341  EE 20
        or   N                          ;=> 0343  F6 20
        cp   N                          ;=> 0345  FE 20
        sub  a,b                        ;=> 0347  90
        and  a,b                        ;=> 0348  A0
        xor  a,b                        ;=> 0349  A8
        or   a,b                        ;=> 034A  B0
        cp   a,b                        ;=> 034B  B8
        sub  a,c                        ;=> 034C  91
        and  a,c                        ;=> 034D  A1
        xor  a,c                        ;=> 034E  A9
        or   a,c                        ;=> 034F  B1
        cp   a,c                        ;=> 0350  B9
        sub  a,d                        ;=> 0351  92
        and  a,d                        ;=> 0352  A2
        xor  a,d                        ;=> 0353  AA
        or   a,d                        ;=> 0354  B2
        cp   a,d                        ;=> 0355  BA
        sub  a,e                        ;=> 0356  93
        and  a,e                        ;=> 0357  A3
        xor  a,e                        ;=> 0358  AB
        or   a,e                        ;=> 0359  B3
        cp   a,e                        ;=> 035A  BB
        sub  a,h                        ;=> 035B  94
        and  a,h                        ;=> 035C  A4
        xor  a,h                        ;=> 035D  AC
        or   a,h                        ;=> 035E  B4
        cp   a,h                        ;=> 035F  BC
        sub  a,l                        ;=> 0360  95
        and  a,l                        ;=> 0361  A5
        xor  a,l                        ;=> 0362  AD
        or   a,l                        ;=> 0363  B5
        cp   a,l                        ;=> 0364  BD
        sub  a,a                        ;=> 0365  97
        and  a,a                        ;=> 0366  A7
        xor  a,a                        ;=> 0367  AF
        or   a,a                        ;=> 0368  B7
        cp   a,a                        ;=> 0369  BF
        sub  a,(hl)                     ;=> 036A  96
        and  a,(hl)                     ;=> 036B  A6
        xor  a,(hl)                     ;=> 036C  AE
        or   a,(hl)                     ;=> 036D  B6
        cp   a,(hl)                     ;=> 036E  BE
        sub  a,(ix+DIS)                 ;=> 036F  DD 96 40
        and  a,(ix+DIS)                 ;=> 0372  DD A6 40
        xor  a,(ix+DIS)                 ;=> 0375  DD AE 40
        or   a,(ix+DIS)                 ;=> 0378  DD B6 40
        cp   a,(ix+DIS)                 ;=> 037B  DD BE 40
        sub  a,(iy+DIS)                 ;=> 037E  FD 96 40
        and  a,(iy+DIS)                 ;=> 0381  FD A6 40
        xor  a,(iy+DIS)                 ;=> 0384  FD AE 40
        or   a,(iy+DIS)                 ;=> 0387  FD B6 40
        cp   a,(iy+DIS)                 ;=> 038A  FD BE 40
        sub  a,N                        ;=> 038D  D6 20
        and  a,N                        ;=> 038F  E6 20
        xor  a,N                        ;=> 0391  EE 20
        or   a,N                        ;=> 0393  F6 20
        cp   a,N                        ;=> 0395  FE 20
        
        inc  b                          ;=> 0397  04
        dec  b                          ;=> 0398  05
        inc  c                          ;=> 0399  0C
        dec  c                          ;=> 039A  0D
        inc  d                          ;=> 039B  14
        dec  d                          ;=> 039C  15
        inc  e                          ;=> 039D  1C
        dec  e                          ;=> 039E  1D
        inc  h                          ;=> 039F  24
        dec  h                          ;=> 03A0  25
        inc  l                          ;=> 03A1  2C
        dec  l                          ;=> 03A2  2D
        inc  a                          ;=> 03A3  3C
        dec  a                          ;=> 03A4  3D
        inc  (hl)                       ;=> 03A5  34
        dec  (hl)                       ;=> 03A6  35
        inc  (ix+DIS)                   ;=> 03A7  DD 34 40
        dec  (ix+DIS)                   ;=> 03AA  DD 35 40
        inc  (iy+DIS)                   ;=> 03AD  FD 34 40
        dec  (iy+DIS)                   ;=> 03B0  FD 35 40
        

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  hl,bc                      ;=> 03B3  09
        add  hl,de                      ;=> 03B4  19
        add  hl,hl                      ;=> 03B5  29
        add  hl,sp                      ;=> 03B6  39
        add  ix,bc                      ;=> 03B7  DD 09
        add  ix,de                      ;=> 03B9  DD 19
        add  ix,ix                      ;=> 03BB  DD 29
        add  ix,sp                      ;=> 03BD  DD 39
        add  iy,bc                      ;=> 03BF  FD 09
        add  iy,de                      ;=> 03C1  FD 19
        add  iy,iy                      ;=> 03C3  FD 29
        add  iy,sp                      ;=> 03C5  FD 39

        sbc  hl,bc                      ;=> 03C7  ED 42
        adc  hl,bc                      ;=> 03C9  ED 4A
        sbc  hl,de                      ;=> 03CB  ED 52
        adc  hl,de                      ;=> 03CD  ED 5A
        sbc  hl,hl                      ;=> 03CF  ED 62
        adc  hl,hl                      ;=> 03D1  ED 6A
        sbc  hl,sp                      ;=> 03D3  ED 72
        adc  hl,sp                      ;=> 03D5  ED 7A
;	sub       hl,bc						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,de						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,hl						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,sp						=} 0xB7 0xED 0x42+<2:4>

        inc  bc                         ;=> 03D7  03
        dec  bc                         ;=> 03D8  0B
        inc  de                         ;=> 03D9  13
        dec  de                         ;=> 03DA  1B
        inc  hl                         ;=> 03DB  23
        dec  hl                         ;=> 03DC  2B
        inc  ix                         ;=> 03DD  DD 23
        dec  ix                         ;=> 03DF  DD 2B
        inc  iy                         ;=> 03E1  FD 23
        dec  iy                         ;=> 03E3  FD 2B
        inc  sp                         ;=> 03E5  33
        dec  sp                         ;=> 03E6  3B

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

        rlca                            ;=> 03E7  07
        rrca                            ;=> 03E8  0F
        rla                             ;=> 03E9  17
        rra                             ;=> 03EA  1F

        rlc  b                          ;=> 03EB  CB 00
        rrc  b                          ;=> 03ED  CB 08
        rl   b                          ;=> 03EF  CB 10
        rr   b                          ;=> 03F1  CB 18
        sla  b                          ;=> 03F3  CB 20
        sra  b                          ;=> 03F5  CB 28
        srl  b                          ;=> 03F7  CB 38
        rlc  c                          ;=> 03F9  CB 01
        rrc  c                          ;=> 03FB  CB 09
        rl   c                          ;=> 03FD  CB 11
        rr   c                          ;=> 03FF  CB 19
        sla  c                          ;=> 0401  CB 21
        sra  c                          ;=> 0403  CB 29
        srl  c                          ;=> 0405  CB 39
        rlc  d                          ;=> 0407  CB 02
        rrc  d                          ;=> 0409  CB 0A
        rl   d                          ;=> 040B  CB 12
        rr   d                          ;=> 040D  CB 1A
        sla  d                          ;=> 040F  CB 22
        sra  d                          ;=> 0411  CB 2A
        srl  d                          ;=> 0413  CB 3A
        rlc  e                          ;=> 0415  CB 03
        rrc  e                          ;=> 0417  CB 0B
        rl   e                          ;=> 0419  CB 13
        rr   e                          ;=> 041B  CB 1B
        sla  e                          ;=> 041D  CB 23
        sra  e                          ;=> 041F  CB 2B
        srl  e                          ;=> 0421  CB 3B
        rlc  h                          ;=> 0423  CB 04
        rrc  h                          ;=> 0425  CB 0C
        rl   h                          ;=> 0427  CB 14
        rr   h                          ;=> 0429  CB 1C
        sla  h                          ;=> 042B  CB 24
        sra  h                          ;=> 042D  CB 2C
        srl  h                          ;=> 042F  CB 3C
        rlc  l                          ;=> 0431  CB 05
        rrc  l                          ;=> 0433  CB 0D
        rl   l                          ;=> 0435  CB 15
        rr   l                          ;=> 0437  CB 1D
        sla  l                          ;=> 0439  CB 25
        sra  l                          ;=> 043B  CB 2D
        srl  l                          ;=> 043D  CB 3D
        rlc  a                          ;=> 043F  CB 07
        rrc  a                          ;=> 0441  CB 0F
        rl   a                          ;=> 0443  CB 17
        rr   a                          ;=> 0445  CB 1F
        sla  a                          ;=> 0447  CB 27
        sra  a                          ;=> 0449  CB 2F
        srl  a                          ;=> 044B  CB 3F
        rlc  (hl)                       ;=> 044D  CB 06
        rrc  (hl)                       ;=> 044F  CB 0E
        rl   (hl)                       ;=> 0451  CB 16
        rr   (hl)                       ;=> 0453  CB 1E
        sla  (hl)                       ;=> 0455  CB 26
        sra  (hl)                       ;=> 0457  CB 2E
        srl  (hl)                       ;=> 0459  CB 3E
        rlc  (ix+DIS)                   ;=> 045B  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 045F  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 0463  DD CB 40 16
        rr   (ix+DIS)                   ;=> 0467  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 046B  DD CB 40 26
        sra  (ix+DIS)                   ;=> 046F  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 0473  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 0477  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 047B  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 047F  FD CB 40 16
        rr   (iy+DIS)                   ;=> 0483  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 0487  FD CB 40 26
        sra  (iy+DIS)                   ;=> 048B  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 048F  FD CB 40 3E
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

        rld                             ;=> 0493  CD D1 08
        rrd                             ;=> 0496  CD F3 08

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

        cpl                             ;=> 0499  2F
        neg                             ;=> 049A  ED 44
        ccf                             ;=> 049C  3F
        scf                             ;=> 049D  37
        nop                             ;=> 049E  00


;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

        bit  0,b                        ;=> 049F  CB 40
        res  0,b                        ;=> 04A1  CB 80
        set  0,b                        ;=> 04A3  CB C0
        bit  1,b                        ;=> 04A5  CB 48
        res  1,b                        ;=> 04A7  CB 88
        set  1,b                        ;=> 04A9  CB C8
        bit  2,b                        ;=> 04AB  CB 50
        res  2,b                        ;=> 04AD  CB 90
        set  2,b                        ;=> 04AF  CB D0
        bit  3,b                        ;=> 04B1  CB 58
        res  3,b                        ;=> 04B3  CB 98
        set  3,b                        ;=> 04B5  CB D8
        bit  4,b                        ;=> 04B7  CB 60
        res  4,b                        ;=> 04B9  CB A0
        set  4,b                        ;=> 04BB  CB E0
        bit  5,b                        ;=> 04BD  CB 68
        res  5,b                        ;=> 04BF  CB A8
        set  5,b                        ;=> 04C1  CB E8
        bit  6,b                        ;=> 04C3  CB 70
        res  6,b                        ;=> 04C5  CB B0
        set  6,b                        ;=> 04C7  CB F0
        bit  7,b                        ;=> 04C9  CB 78
        res  7,b                        ;=> 04CB  CB B8
        set  7,b                        ;=> 04CD  CB F8
        bit  0,c                        ;=> 04CF  CB 41
        res  0,c                        ;=> 04D1  CB 81
        set  0,c                        ;=> 04D3  CB C1
        bit  1,c                        ;=> 04D5  CB 49
        res  1,c                        ;=> 04D7  CB 89
        set  1,c                        ;=> 04D9  CB C9
        bit  2,c                        ;=> 04DB  CB 51
        res  2,c                        ;=> 04DD  CB 91
        set  2,c                        ;=> 04DF  CB D1
        bit  3,c                        ;=> 04E1  CB 59
        res  3,c                        ;=> 04E3  CB 99
        set  3,c                        ;=> 04E5  CB D9
        bit  4,c                        ;=> 04E7  CB 61
        res  4,c                        ;=> 04E9  CB A1
        set  4,c                        ;=> 04EB  CB E1
        bit  5,c                        ;=> 04ED  CB 69
        res  5,c                        ;=> 04EF  CB A9
        set  5,c                        ;=> 04F1  CB E9
        bit  6,c                        ;=> 04F3  CB 71
        res  6,c                        ;=> 04F5  CB B1
        set  6,c                        ;=> 04F7  CB F1
        bit  7,c                        ;=> 04F9  CB 79
        res  7,c                        ;=> 04FB  CB B9
        set  7,c                        ;=> 04FD  CB F9
        bit  0,d                        ;=> 04FF  CB 42
        res  0,d                        ;=> 0501  CB 82
        set  0,d                        ;=> 0503  CB C2
        bit  1,d                        ;=> 0505  CB 4A
        res  1,d                        ;=> 0507  CB 8A
        set  1,d                        ;=> 0509  CB CA
        bit  2,d                        ;=> 050B  CB 52
        res  2,d                        ;=> 050D  CB 92
        set  2,d                        ;=> 050F  CB D2
        bit  3,d                        ;=> 0511  CB 5A
        res  3,d                        ;=> 0513  CB 9A
        set  3,d                        ;=> 0515  CB DA
        bit  4,d                        ;=> 0517  CB 62
        res  4,d                        ;=> 0519  CB A2
        set  4,d                        ;=> 051B  CB E2
        bit  5,d                        ;=> 051D  CB 6A
        res  5,d                        ;=> 051F  CB AA
        set  5,d                        ;=> 0521  CB EA
        bit  6,d                        ;=> 0523  CB 72
        res  6,d                        ;=> 0525  CB B2
        set  6,d                        ;=> 0527  CB F2
        bit  7,d                        ;=> 0529  CB 7A
        res  7,d                        ;=> 052B  CB BA
        set  7,d                        ;=> 052D  CB FA
        bit  0,e                        ;=> 052F  CB 43
        res  0,e                        ;=> 0531  CB 83
        set  0,e                        ;=> 0533  CB C3
        bit  1,e                        ;=> 0535  CB 4B
        res  1,e                        ;=> 0537  CB 8B
        set  1,e                        ;=> 0539  CB CB
        bit  2,e                        ;=> 053B  CB 53
        res  2,e                        ;=> 053D  CB 93
        set  2,e                        ;=> 053F  CB D3
        bit  3,e                        ;=> 0541  CB 5B
        res  3,e                        ;=> 0543  CB 9B
        set  3,e                        ;=> 0545  CB DB
        bit  4,e                        ;=> 0547  CB 63
        res  4,e                        ;=> 0549  CB A3
        set  4,e                        ;=> 054B  CB E3
        bit  5,e                        ;=> 054D  CB 6B
        res  5,e                        ;=> 054F  CB AB
        set  5,e                        ;=> 0551  CB EB
        bit  6,e                        ;=> 0553  CB 73
        res  6,e                        ;=> 0555  CB B3
        set  6,e                        ;=> 0557  CB F3
        bit  7,e                        ;=> 0559  CB 7B
        res  7,e                        ;=> 055B  CB BB
        set  7,e                        ;=> 055D  CB FB
        bit  0,h                        ;=> 055F  CB 44
        res  0,h                        ;=> 0561  CB 84
        set  0,h                        ;=> 0563  CB C4
        bit  1,h                        ;=> 0565  CB 4C
        res  1,h                        ;=> 0567  CB 8C
        set  1,h                        ;=> 0569  CB CC
        bit  2,h                        ;=> 056B  CB 54
        res  2,h                        ;=> 056D  CB 94
        set  2,h                        ;=> 056F  CB D4
        bit  3,h                        ;=> 0571  CB 5C
        res  3,h                        ;=> 0573  CB 9C
        set  3,h                        ;=> 0575  CB DC
        bit  4,h                        ;=> 0577  CB 64
        res  4,h                        ;=> 0579  CB A4
        set  4,h                        ;=> 057B  CB E4
        bit  5,h                        ;=> 057D  CB 6C
        res  5,h                        ;=> 057F  CB AC
        set  5,h                        ;=> 0581  CB EC
        bit  6,h                        ;=> 0583  CB 74
        res  6,h                        ;=> 0585  CB B4
        set  6,h                        ;=> 0587  CB F4
        bit  7,h                        ;=> 0589  CB 7C
        res  7,h                        ;=> 058B  CB BC
        set  7,h                        ;=> 058D  CB FC
        bit  0,l                        ;=> 058F  CB 45
        res  0,l                        ;=> 0591  CB 85
        set  0,l                        ;=> 0593  CB C5
        bit  1,l                        ;=> 0595  CB 4D
        res  1,l                        ;=> 0597  CB 8D
        set  1,l                        ;=> 0599  CB CD
        bit  2,l                        ;=> 059B  CB 55
        res  2,l                        ;=> 059D  CB 95
        set  2,l                        ;=> 059F  CB D5
        bit  3,l                        ;=> 05A1  CB 5D
        res  3,l                        ;=> 05A3  CB 9D
        set  3,l                        ;=> 05A5  CB DD
        bit  4,l                        ;=> 05A7  CB 65
        res  4,l                        ;=> 05A9  CB A5
        set  4,l                        ;=> 05AB  CB E5
        bit  5,l                        ;=> 05AD  CB 6D
        res  5,l                        ;=> 05AF  CB AD
        set  5,l                        ;=> 05B1  CB ED
        bit  6,l                        ;=> 05B3  CB 75
        res  6,l                        ;=> 05B5  CB B5
        set  6,l                        ;=> 05B7  CB F5
        bit  7,l                        ;=> 05B9  CB 7D
        res  7,l                        ;=> 05BB  CB BD
        set  7,l                        ;=> 05BD  CB FD
        bit  0,a                        ;=> 05BF  CB 47
        res  0,a                        ;=> 05C1  CB 87
        set  0,a                        ;=> 05C3  CB C7
        bit  1,a                        ;=> 05C5  CB 4F
        res  1,a                        ;=> 05C7  CB 8F
        set  1,a                        ;=> 05C9  CB CF
        bit  2,a                        ;=> 05CB  CB 57
        res  2,a                        ;=> 05CD  CB 97
        set  2,a                        ;=> 05CF  CB D7
        bit  3,a                        ;=> 05D1  CB 5F
        res  3,a                        ;=> 05D3  CB 9F
        set  3,a                        ;=> 05D5  CB DF
        bit  4,a                        ;=> 05D7  CB 67
        res  4,a                        ;=> 05D9  CB A7
        set  4,a                        ;=> 05DB  CB E7
        bit  5,a                        ;=> 05DD  CB 6F
        res  5,a                        ;=> 05DF  CB AF
        set  5,a                        ;=> 05E1  CB EF
        bit  6,a                        ;=> 05E3  CB 77
        res  6,a                        ;=> 05E5  CB B7
        set  6,a                        ;=> 05E7  CB F7
        bit  7,a                        ;=> 05E9  CB 7F
        res  7,a                        ;=> 05EB  CB BF
        set  7,a                        ;=> 05ED  CB FF
        bit  0,(hl)                     ;=> 05EF  CB 46
        res  0,(hl)                     ;=> 05F1  CB 86
        set  0,(hl)                     ;=> 05F3  CB C6
        bit  1,(hl)                     ;=> 05F5  CB 4E
        res  1,(hl)                     ;=> 05F7  CB 8E
        set  1,(hl)                     ;=> 05F9  CB CE
        bit  2,(hl)                     ;=> 05FB  CB 56
        res  2,(hl)                     ;=> 05FD  CB 96
        set  2,(hl)                     ;=> 05FF  CB D6
        bit  3,(hl)                     ;=> 0601  CB 5E
        res  3,(hl)                     ;=> 0603  CB 9E
        set  3,(hl)                     ;=> 0605  CB DE
        bit  4,(hl)                     ;=> 0607  CB 66
        res  4,(hl)                     ;=> 0609  CB A6
        set  4,(hl)                     ;=> 060B  CB E6
        bit  5,(hl)                     ;=> 060D  CB 6E
        res  5,(hl)                     ;=> 060F  CB AE
        set  5,(hl)                     ;=> 0611  CB EE
        bit  6,(hl)                     ;=> 0613  CB 76
        res  6,(hl)                     ;=> 0615  CB B6
        set  6,(hl)                     ;=> 0617  CB F6
        bit  7,(hl)                     ;=> 0619  CB 7E
        res  7,(hl)                     ;=> 061B  CB BE
        set  7,(hl)                     ;=> 061D  CB FE
        bit  0,(ix+DIS)                 ;=> 061F  DD CB 40 46
        res  0,(ix+DIS)                 ;=> 0623  DD CB 40 86
        set  0,(ix+DIS)                 ;=> 0627  DD CB 40 C6
        bit  1,(ix+DIS)                 ;=> 062B  DD CB 40 4E
        res  1,(ix+DIS)                 ;=> 062F  DD CB 40 8E
        set  1,(ix+DIS)                 ;=> 0633  DD CB 40 CE
        bit  2,(ix+DIS)                 ;=> 0637  DD CB 40 56
        res  2,(ix+DIS)                 ;=> 063B  DD CB 40 96
        set  2,(ix+DIS)                 ;=> 063F  DD CB 40 D6
        bit  3,(ix+DIS)                 ;=> 0643  DD CB 40 5E
        res  3,(ix+DIS)                 ;=> 0647  DD CB 40 9E
        set  3,(ix+DIS)                 ;=> 064B  DD CB 40 DE
        bit  4,(ix+DIS)                 ;=> 064F  DD CB 40 66
        res  4,(ix+DIS)                 ;=> 0653  DD CB 40 A6
        set  4,(ix+DIS)                 ;=> 0657  DD CB 40 E6
        bit  5,(ix+DIS)                 ;=> 065B  DD CB 40 6E
        res  5,(ix+DIS)                 ;=> 065F  DD CB 40 AE
        set  5,(ix+DIS)                 ;=> 0663  DD CB 40 EE
        bit  6,(ix+DIS)                 ;=> 0667  DD CB 40 76
        res  6,(ix+DIS)                 ;=> 066B  DD CB 40 B6
        set  6,(ix+DIS)                 ;=> 066F  DD CB 40 F6
        bit  7,(ix+DIS)                 ;=> 0673  DD CB 40 7E
        res  7,(ix+DIS)                 ;=> 0677  DD CB 40 BE
        set  7,(ix+DIS)                 ;=> 067B  DD CB 40 FE
        bit  0,(iy+DIS)                 ;=> 067F  FD CB 40 46
        res  0,(iy+DIS)                 ;=> 0683  FD CB 40 86
        set  0,(iy+DIS)                 ;=> 0687  FD CB 40 C6
        bit  1,(iy+DIS)                 ;=> 068B  FD CB 40 4E
        res  1,(iy+DIS)                 ;=> 068F  FD CB 40 8E
        set  1,(iy+DIS)                 ;=> 0693  FD CB 40 CE
        bit  2,(iy+DIS)                 ;=> 0697  FD CB 40 56
        res  2,(iy+DIS)                 ;=> 069B  FD CB 40 96
        set  2,(iy+DIS)                 ;=> 069F  FD CB 40 D6
        bit  3,(iy+DIS)                 ;=> 06A3  FD CB 40 5E
        res  3,(iy+DIS)                 ;=> 06A7  FD CB 40 9E
        set  3,(iy+DIS)                 ;=> 06AB  FD CB 40 DE
        bit  4,(iy+DIS)                 ;=> 06AF  FD CB 40 66
        res  4,(iy+DIS)                 ;=> 06B3  FD CB 40 A6
        set  4,(iy+DIS)                 ;=> 06B7  FD CB 40 E6
        bit  5,(iy+DIS)                 ;=> 06BB  FD CB 40 6E
        res  5,(iy+DIS)                 ;=> 06BF  FD CB 40 AE
        set  5,(iy+DIS)                 ;=> 06C3  FD CB 40 EE
        bit  6,(iy+DIS)                 ;=> 06C7  FD CB 40 76
        res  6,(iy+DIS)                 ;=> 06CB  FD CB 40 B6
        set  6,(iy+DIS)                 ;=> 06CF  FD CB 40 F6
        bit  7,(iy+DIS)                 ;=> 06D3  FD CB 40 7E
        res  7,(iy+DIS)                 ;=> 06D7  FD CB 40 BE
        set  7,(iy+DIS)                 ;=> 06DB  FD CB 40 FE
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
        jp   NN                         ;=> 06DF  C3 30 00
        jp   (hl)                       ;=> 06E2  E9
        jp   (ix)                       ;=> 06E3  DD E9
        jp   (iy)                       ;=> 06E5  FD E9
        jp   nz,NN                      ;=> 06E7  C2 30 00
        jp   z,NN                       ;=> 06EA  CA 30 00
        jp   nc,NN                      ;=> 06ED  D2 30 00
        jp   c,NN                       ;=> 06F0  DA 30 00
        jp   po,NN                      ;=> 06F3  E2 30 00
        jp   pe,NN                      ;=> 06F6  EA 30 00
        jp   p,NN                       ;=> 06F9  F2 30 00
        jp   m,NN                       ;=> 06FC  FA 30 00

										; max forward jump
        jr   jr2                        ;=> 06FF  18 7F
        jr   jr2                        ;=> 0701  18 7D
        jr   jr2                        ;=> 0703  18 7B
        
        djnz ASMPC                      ;=> 0705  10 FE
        djnz ASMPC+0x81                 ;=> 0707  10 7F
        jr   ASMPC                      ;=> 0709  18 FE
        jr   ASMPC-0x7E                 ;=> 070B  18 80
        
        djnz jr1                        ;=> 070D  10 00
jr1:
        jr   jr1                        ;=> 070F  18 FE
        djnz jr1                        ;=> 0711  10 FC
        jr   nz,jr1                     ;=> 0713  20 FA
        jr   z,jr1                      ;=> 0715  28 F8
        jr   nc,jr1                     ;=> 0717  30 F6
        jr   c,jr1                      ;=> 0719  38 F4
        
        defs 127-26, 0FFh 
jr2:
        defs 122, 0FFh 
        jr   jr2                        ;=> 07FA  18 84
        jr   jr2                        ;=> 07FC  18 82
										; max backward jump - z80pack does not accept -128
        jr   jr2                        ;=> 07FE  18 80
        

;	jr po,NN
;	jr pe,NN
;	jr p,NN
;	jr m,NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

        call NN                         ;=> 0800  CD 30 00
        ret                             ;=> 0803  C9
        ret  nz                         ;=> 0804  C0
        ret  z                          ;=> 0805  C8
        ret  nc                         ;=> 0806  D0
        ret  c                          ;=> 0807  D8
        ret  po                         ;=> 0808  E0
        ret  pe                         ;=> 0809  E8
        ret  p                          ;=> 080A  F0
        ret  m                          ;=> 080B  F8
        reti                            ;=> 080C  ED 4D
;	rst 0
;	rst 1
;	rst 2
;	rst 3
;	rst 4
;	rst 5
;	rst 6
;	rst 7


        call nz,NN                      ;=> 080E  28 03 CD 30 00
        call z,NN                       ;=> 0813  20 03 CD 30 00
        call nc,NN                      ;=> 0818  38 03 CD 30 00
        call c,NN                       ;=> 081D  30 03 CD 30 00
        call po,NN                      ;=> 0822  EA 28 08 CD 30 00
        call pe,NN                      ;=> 0828  E2 2E 08 CD 30 00
        call p,NN                       ;=> 082E  FA 34 08 CD 30 00
        call m,NN                       ;=> 0834  F2 3A 08 CD 30 00
        rst  10h                        ;=> 083A  D7
        rst  18h                        ;=> 083B  DF
        rst  20h                        ;=> 083C  E7
        rst  28h                        ;=> 083D  EF
        rst  38h                        ;=> 083E  FF



;------------------------------------------------------------------------------
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
                                        ;=> 083F  38 12 BE 2B 0B F5 E3 CB 85 CB D5 78 B1 20 02 CB 95 E3 F1 C9 BE 2B 0B F5 E3 CB C5 18 EC 30 06 CD 64 08 37 C9 2B 0B BE 28 12 0C 0D 20 F7 04 10 F4 BE 2B F5 E3 CB 85 CB 95 E3 F1 C9 2B F5 78 B1 28 F2 E3 CB 85 CB D5 E3 F1 C9 38 12 BE 23 0B F5 E3 CB 85 CB D5 78 B1 20 02 CB 95 E3 F1 C9 BE 23 0B F5 E3 CB C5 18 EC 30 06 CD AD 08 37 C9 23 0B BE 28 12 0C 0D 20 F7 04 10 F4 BE 23 F5 E3 CB 85 CB 95 E3 F1 C9 23 F5 78 B1 28 F2 E3 CB 85 CB D5 E3 F1 C9 30 05 CD D8 08 37 C9 07 07 07 07 CB 27 CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 B7 C9 30 05 CD FA 08 37 C9 CB 3F CB 1E 1F CB 1E 1F CB 1E 1F CB 1E 1F 1F 1F 1F 1F B7 C9
