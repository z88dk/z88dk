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

; BUG_0011: ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
        defb bug0011a-ASMPC, bug0011a-ASMPC  ;=> 0136  06 06
        defb bug0011a-ASMPC, bug0011a-ASMPC  ;=> 0138  04 04
        defb bug0011a-ASMPC, bug0011a-ASMPC  ;=> 013A  02 02
bug0011a:

; BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
bug0047a:
        defw ASMPC,ASMPC,ASMPC          ;=> 013C  3C 01 3C 01 3C 01
bug0047b: 
        jp   ASMPC                      ;=> 0142  C3 42 01

;------------------------------------------------------------------------------
; IF ELSE ENDIF
;------------------------------------------------------------------------------
        if   1 
        defb 1                          ;=> 0145  01
        if   1 
        defb 2                          ;=> 0146  02
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
        defb 8                          ;=> 0147  08
        endif 
        
        if   0 
        defb 9 
        else 
        defb 10                         ;=> 0148  0A
        endif 
        
        if   undefined 
        defb 11 
        else 
        defb 12                         ;=> 0149  0C
        endif 

        if   undefined | 1 
        defb 13                         ;=> 014A  0D
        else 
        defb 14 
        endif 

;------------------------------------------------------------------------------
; Z88DK specific opcodes
;------------------------------------------------------------------------------
        call_oz 1                       ;=> 014B  E7 01
        call_oz 255                     ;=> 014D  E7 FF
        call_oz 256                     ;=> 014F  E7 00 01
        call_oz 65535                   ;=> 0152  E7 FF FF

        call_pkg 0                      ;=> 0155  CF 00 00
        call_pkg 1                      ;=> 0158  CF 01 00
        call_pkg 65535                  ;=> 015B  CF FF FF
        
        fpp  1                          ;=> 015E  DF 01
        fpp  254                        ;=> 0160  DF FE

        invoke 0                        ;=> 0162  CD 00 00
        invoke 1                        ;=> 0165  CD 01 00
        invoke 65535                    ;=> 0168  CD FF FF
        
;------------------------------------------------------------------------------
; 8 bit load group
;------------------------------------------------------------------------------

        ld   b,b                        ;=> 016B  40
        ld   c,b                        ;=> 016C  48
        ld   d,b                        ;=> 016D  50
        ld   e,b                        ;=> 016E  58
        ld   h,b                        ;=> 016F  60
        ld   l,b                        ;=> 0170  68
        ld   a,b                        ;=> 0171  78
        ld   b,c                        ;=> 0172  41
        ld   c,c                        ;=> 0173  49
        ld   d,c                        ;=> 0174  51
        ld   e,c                        ;=> 0175  59
        ld   h,c                        ;=> 0176  61
        ld   l,c                        ;=> 0177  69
        ld   a,c                        ;=> 0178  79
        ld   b,d                        ;=> 0179  42
        ld   c,d                        ;=> 017A  4A
        ld   d,d                        ;=> 017B  52
        ld   e,d                        ;=> 017C  5A
        ld   h,d                        ;=> 017D  62
        ld   l,d                        ;=> 017E  6A
        ld   a,d                        ;=> 017F  7A
        ld   b,e                        ;=> 0180  43
        ld   c,e                        ;=> 0181  4B
        ld   d,e                        ;=> 0182  53
        ld   e,e                        ;=> 0183  5B
        ld   h,e                        ;=> 0184  63
        ld   l,e                        ;=> 0185  6B
        ld   a,e                        ;=> 0186  7B
        ld   b,h                        ;=> 0187  44
        ld   c,h                        ;=> 0188  4C
        ld   d,h                        ;=> 0189  54
        ld   e,h                        ;=> 018A  5C
        ld   h,h                        ;=> 018B  64
        ld   l,h                        ;=> 018C  6C
        ld   a,h                        ;=> 018D  7C
        ld   b,l                        ;=> 018E  45
        ld   c,l                        ;=> 018F  4D
        ld   d,l                        ;=> 0190  55
        ld   e,l                        ;=> 0191  5D
        ld   h,l                        ;=> 0192  65
        ld   l,l                        ;=> 0193  6D
        ld   a,l                        ;=> 0194  7D
        ld   b,a                        ;=> 0195  47
        ld   c,a                        ;=> 0196  4F
        ld   d,a                        ;=> 0197  57
        ld   e,a                        ;=> 0198  5F
        ld   h,a                        ;=> 0199  67
        ld   l,a                        ;=> 019A  6F
        ld   a,a                        ;=> 019B  7F
        ld   b,N                        ;=> 019C  06 20
        ld   c,N                        ;=> 019E  0E 20
        ld   d,N                        ;=> 01A0  16 20
        ld   e,N                        ;=> 01A2  1E 20
        ld   h,N                        ;=> 01A4  26 20
        ld   l,N                        ;=> 01A6  2E 20
        ld   a,N                        ;=> 01A8  3E 20


        ld   b,(hl)                     ;=> 01AA  46
        ld   c,(hl)                     ;=> 01AB  4E
        ld   d,(hl)                     ;=> 01AC  56
        ld   e,(hl)                     ;=> 01AD  5E
        ld   h,(hl)                     ;=> 01AE  66
        ld   l,(hl)                     ;=> 01AF  6E
        ld   a,(hl)                     ;=> 01B0  7E
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

        ld   b,(ix+DIS)                 ;=> 01B1  DD 46 40
        ld   c,(ix+DIS)                 ;=> 01B4  DD 4E 40
        ld   d,(ix+DIS)                 ;=> 01B7  DD 56 40
        ld   e,(ix+DIS)                 ;=> 01BA  DD 5E 40
        ld   h,(ix+DIS)                 ;=> 01BD  DD 66 40
        ld   l,(ix+DIS)                 ;=> 01C0  DD 6E 40
        ld   a,(ix+DIS)                 ;=> 01C3  DD 7E 40
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

        ld   b,(iy+DIS)                 ;=> 01C6  FD 46 40
        ld   c,(iy+DIS)                 ;=> 01C9  FD 4E 40
        ld   d,(iy+DIS)                 ;=> 01CC  FD 56 40
        ld   e,(iy+DIS)                 ;=> 01CF  FD 5E 40
        ld   h,(iy+DIS)                 ;=> 01D2  FD 66 40
        ld   l,(iy+DIS)                 ;=> 01D5  FD 6E 40
        ld   a,(iy+DIS)                 ;=> 01D8  FD 7E 40
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

        ld   (hl),b                     ;=> 01DB  70
        ld   (hl),c                     ;=> 01DC  71
        ld   (hl),d                     ;=> 01DD  72
        ld   (hl),e                     ;=> 01DE  73
        ld   (hl),h                     ;=> 01DF  74
        ld   (hl),l                     ;=> 01E0  75
        ld   (hl),a                     ;=> 01E1  77
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

        ld   (ix+DIS),b                 ;=> 01E2  DD 70 40
        ld   (ix+DIS),c                 ;=> 01E5  DD 71 40
        ld   (ix+DIS),d                 ;=> 01E8  DD 72 40
        ld   (ix+DIS),e                 ;=> 01EB  DD 73 40
        ld   (ix+DIS),h                 ;=> 01EE  DD 74 40
        ld   (ix+DIS),l                 ;=> 01F1  DD 75 40
        ld   (ix+DIS),a                 ;=> 01F4  DD 77 40
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

        ld   (iy+DIS),b                 ;=> 01F7  FD 70 40
        ld   (iy+DIS),c                 ;=> 01FA  FD 71 40
        ld   (iy+DIS),d                 ;=> 01FD  FD 72 40
        ld   (iy+DIS),e                 ;=> 0200  FD 73 40
        ld   (iy+DIS),h                 ;=> 0203  FD 74 40
        ld   (iy+DIS),l                 ;=> 0206  FD 75 40
        ld   (iy+DIS),a                 ;=> 0209  FD 77 40
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

        ld   (hl),N                     ;=> 020C  36 20
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

        ld   (ix+DIS),N                 ;=> 020E  DD 36 40 20
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

        ld   (iy+DIS),N                 ;=> 0212  FD 36 40 20
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

        ld   a,(bc)                     ;=> 0216  0A
        ld   a,(de)                     ;=> 0217  1A
;	ldi	a,(bc)						;;	ld	a,(bc) ;; inc bc
;	ldi	a,(de)						;;	ld	a,(de) ;; inc de
;	ldd	a,(bc)						;;	ld	a,(bc) ;; dec bc
;	ldd	a,(de)						;;	ld	a,(de) ;; dec de

        ld   (bc),a                     ;=> 0218  02
        ld   (de),a                     ;=> 0219  12
;	ldi	(bc),a						;;	ld	(bc),a ;; inc bc
;	ldi	(de),a						;;	ld	(de),a ;; inc de
;	ldd	(bc),a						;;	ld	(bc),a ;; dec bc
;	ldd	(de),a						;;	ld	(de),a ;; dec de

        ld   a,(NN)                     ;=> 021A  3A 30 00
        ld   (NN),a                     ;=> 021D  32 30 00

        ld   a,iir                      ;=> 0220  ED 57
        ld   a,eir                      ;=> 0222  ED 5F
        ld   iir,a                      ;=> 0224  ED 47
        ld   eir,a                      ;=> 0226  ED 4F

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

        ld   bc,NN                      ;=> 0228  01 30 00
        ld   de,NN                      ;=> 022B  11 30 00
        ld   hl,NN                      ;=> 022E  21 30 00
        ld   ix,NN                      ;=> 0231  DD 21 30 00
        ld   iy,NN                      ;=> 0235  FD 21 30 00
        ld   sp,NN                      ;=> 0239  31 30 00
        ld   bc,(NN)                    ;=> 023C  ED 4B 30 00
        ld   de,(NN)                    ;=> 0240  ED 5B 30 00
        ld   hl,(NN)                    ;=> 0244  2A 30 00
        ld   ix,(NN)                    ;=> 0247  DD 2A 30 00
        ld   iy,(NN)                    ;=> 024B  FD 2A 30 00
        ld   sp,(NN)                    ;=> 024F  ED 7B 30 00
        ld   (NN),bc                    ;=> 0253  ED 43 30 00
        ld   (NN),de                    ;=> 0257  ED 53 30 00
        ld   (NN),hl                    ;=> 025B  22 30 00
        ld   (NN),ix                    ;=> 025E  DD 22 30 00
        ld   (NN),iy                    ;=> 0262  FD 22 30 00
        ld   (NN),sp                    ;=> 0266  ED 73 30 00
        ld   sp,hl                      ;=> 026A  F9
        ld   sp,ix                      ;=> 026B  DD F9
        ld   sp,iy                      ;=> 026D  FD F9
        push bc                         ;=> 026F  C5
        push de                         ;=> 0270  D5
        push hl                         ;=> 0271  E5
        push ix                         ;=> 0272  DD E5
        push iy                         ;=> 0274  FD E5
        push af                         ;=> 0276  F5
        pop  bc                         ;=> 0277  C1
        pop  de                         ;=> 0278  D1
        pop  hl                         ;=> 0279  E1
        pop  ix                         ;=> 027A  DD E1
        pop  iy                         ;=> 027C  FD E1
        pop  af                         ;=> 027E  F1

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

        ex   de,hl                      ;=> 027F  EB
        ex   af,af                      ;=> 0280  08
        ex   af,af'                     ;=> 0281  08
        exx                             ;=> 0282  D9
        
        ex   (sp),hl                    ;=> 0283  ED 54
        ex   (sp),ix                    ;=> 0285  DD E3
        ex   (sp),iy                    ;=> 0287  FD E3

        ldi                             ;=> 0289  ED A0
        ldir                            ;=> 028B  ED B0
        ldd                             ;=> 028D  ED A8
        lddr                            ;=> 028F  ED B8

        cpi                             ;=> 0291  CD 8E 08
        cpir                            ;=> 0294  CD AB 08
        cpd                             ;=> 0297  CD 45 08
        cpdr                            ;=> 029A  CD 62 08

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  a,b                        ;=> 029D  80
        adc  a,b                        ;=> 029E  88
        sbc  a,b                        ;=> 029F  98
        add  a,c                        ;=> 02A0  81
        adc  a,c                        ;=> 02A1  89
        sbc  a,c                        ;=> 02A2  99
        add  a,d                        ;=> 02A3  82
        adc  a,d                        ;=> 02A4  8A
        sbc  a,d                        ;=> 02A5  9A
        add  a,e                        ;=> 02A6  83
        adc  a,e                        ;=> 02A7  8B
        sbc  a,e                        ;=> 02A8  9B
        add  a,h                        ;=> 02A9  84
        adc  a,h                        ;=> 02AA  8C
        sbc  a,h                        ;=> 02AB  9C
        add  a,l                        ;=> 02AC  85
        adc  a,l                        ;=> 02AD  8D
        sbc  a,l                        ;=> 02AE  9D
        add  a,a                        ;=> 02AF  87
        adc  a,a                        ;=> 02B0  8F
        sbc  a,a                        ;=> 02B1  9F
        add  a,(hl)                     ;=> 02B2  86
        adc  a,(hl)                     ;=> 02B3  8E
        sbc  a,(hl)                     ;=> 02B4  9E
        add  a,(ix+DIS)                 ;=> 02B5  DD 86 40
        adc  a,(ix+DIS)                 ;=> 02B8  DD 8E 40
        sbc  a,(ix+DIS)                 ;=> 02BB  DD 9E 40
        add  a,(iy+DIS)                 ;=> 02BE  FD 86 40
        adc  a,(iy+DIS)                 ;=> 02C1  FD 8E 40
        sbc  a,(iy+DIS)                 ;=> 02C4  FD 9E 40
        add  a,N                        ;=> 02C7  C6 20
        adc  a,N                        ;=> 02C9  CE 20
        sbc  a,N                        ;=> 02CB  DE 20
        add  b                          ;=> 02CD  80
        adc  b                          ;=> 02CE  88
        sbc  b                          ;=> 02CF  98
        add  c                          ;=> 02D0  81
        adc  c                          ;=> 02D1  89
        sbc  c                          ;=> 02D2  99
        add  d                          ;=> 02D3  82
        adc  d                          ;=> 02D4  8A
        sbc  d                          ;=> 02D5  9A
        add  e                          ;=> 02D6  83
        adc  e                          ;=> 02D7  8B
        sbc  e                          ;=> 02D8  9B
        add  h                          ;=> 02D9  84
        adc  h                          ;=> 02DA  8C
        sbc  h                          ;=> 02DB  9C
        add  l                          ;=> 02DC  85
        adc  l                          ;=> 02DD  8D
        sbc  l                          ;=> 02DE  9D
        add  a                          ;=> 02DF  87
        adc  a                          ;=> 02E0  8F
        sbc  a                          ;=> 02E1  9F
        add  (hl)                       ;=> 02E2  86
        adc  (hl)                       ;=> 02E3  8E
        sbc  (hl)                       ;=> 02E4  9E
        add  (ix+DIS)                   ;=> 02E5  DD 86 40
        adc  (ix+DIS)                   ;=> 02E8  DD 8E 40
        sbc  (ix+DIS)                   ;=> 02EB  DD 9E 40
        add  (iy+DIS)                   ;=> 02EE  FD 86 40
        adc  (iy+DIS)                   ;=> 02F1  FD 8E 40
        sbc  (iy+DIS)                   ;=> 02F4  FD 9E 40
        add  N                          ;=> 02F7  C6 20
        adc  N                          ;=> 02F9  CE 20
        sbc  N                          ;=> 02FB  DE 20
        
        sub  b                          ;=> 02FD  90
        and  b                          ;=> 02FE  A0
        xor  b                          ;=> 02FF  A8
        or   b                          ;=> 0300  B0
        cp   b                          ;=> 0301  B8
        sub  c                          ;=> 0302  91
        and  c                          ;=> 0303  A1
        xor  c                          ;=> 0304  A9
        or   c                          ;=> 0305  B1
        cp   c                          ;=> 0306  B9
        sub  d                          ;=> 0307  92
        and  d                          ;=> 0308  A2
        xor  d                          ;=> 0309  AA
        or   d                          ;=> 030A  B2
        cp   d                          ;=> 030B  BA
        sub  e                          ;=> 030C  93
        and  e                          ;=> 030D  A3
        xor  e                          ;=> 030E  AB
        or   e                          ;=> 030F  B3
        cp   e                          ;=> 0310  BB
        sub  h                          ;=> 0311  94
        and  h                          ;=> 0312  A4
        xor  h                          ;=> 0313  AC
        or   h                          ;=> 0314  B4
        cp   h                          ;=> 0315  BC
        sub  l                          ;=> 0316  95
        and  l                          ;=> 0317  A5
        xor  l                          ;=> 0318  AD
        or   l                          ;=> 0319  B5
        cp   l                          ;=> 031A  BD
        sub  a                          ;=> 031B  97
        and  a                          ;=> 031C  A7
        xor  a                          ;=> 031D  AF
        or   a                          ;=> 031E  B7
        cp   a                          ;=> 031F  BF
        sub  (hl)                       ;=> 0320  96
        and  (hl)                       ;=> 0321  A6
        xor  (hl)                       ;=> 0322  AE
        or   (hl)                       ;=> 0323  B6
        cp   (hl)                       ;=> 0324  BE
        sub  (ix+DIS)                   ;=> 0325  DD 96 40
        and  (ix+DIS)                   ;=> 0328  DD A6 40
        xor  (ix+DIS)                   ;=> 032B  DD AE 40
        or   (ix+DIS)                   ;=> 032E  DD B6 40
        cp   (ix+DIS)                   ;=> 0331  DD BE 40
        sub  (iy+DIS)                   ;=> 0334  FD 96 40
        and  (iy+DIS)                   ;=> 0337  FD A6 40
        xor  (iy+DIS)                   ;=> 033A  FD AE 40
        or   (iy+DIS)                   ;=> 033D  FD B6 40
        cp   (iy+DIS)                   ;=> 0340  FD BE 40
        sub  N                          ;=> 0343  D6 20
        and  N                          ;=> 0345  E6 20
        xor  N                          ;=> 0347  EE 20
        or   N                          ;=> 0349  F6 20
        cp   N                          ;=> 034B  FE 20
        sub  a,b                        ;=> 034D  90
        and  a,b                        ;=> 034E  A0
        xor  a,b                        ;=> 034F  A8
        or   a,b                        ;=> 0350  B0
        cp   a,b                        ;=> 0351  B8
        sub  a,c                        ;=> 0352  91
        and  a,c                        ;=> 0353  A1
        xor  a,c                        ;=> 0354  A9
        or   a,c                        ;=> 0355  B1
        cp   a,c                        ;=> 0356  B9
        sub  a,d                        ;=> 0357  92
        and  a,d                        ;=> 0358  A2
        xor  a,d                        ;=> 0359  AA
        or   a,d                        ;=> 035A  B2
        cp   a,d                        ;=> 035B  BA
        sub  a,e                        ;=> 035C  93
        and  a,e                        ;=> 035D  A3
        xor  a,e                        ;=> 035E  AB
        or   a,e                        ;=> 035F  B3
        cp   a,e                        ;=> 0360  BB
        sub  a,h                        ;=> 0361  94
        and  a,h                        ;=> 0362  A4
        xor  a,h                        ;=> 0363  AC
        or   a,h                        ;=> 0364  B4
        cp   a,h                        ;=> 0365  BC
        sub  a,l                        ;=> 0366  95
        and  a,l                        ;=> 0367  A5
        xor  a,l                        ;=> 0368  AD
        or   a,l                        ;=> 0369  B5
        cp   a,l                        ;=> 036A  BD
        sub  a,a                        ;=> 036B  97
        and  a,a                        ;=> 036C  A7
        xor  a,a                        ;=> 036D  AF
        or   a,a                        ;=> 036E  B7
        cp   a,a                        ;=> 036F  BF
        sub  a,(hl)                     ;=> 0370  96
        and  a,(hl)                     ;=> 0371  A6
        xor  a,(hl)                     ;=> 0372  AE
        or   a,(hl)                     ;=> 0373  B6
        cp   a,(hl)                     ;=> 0374  BE
        sub  a,(ix+DIS)                 ;=> 0375  DD 96 40
        and  a,(ix+DIS)                 ;=> 0378  DD A6 40
        xor  a,(ix+DIS)                 ;=> 037B  DD AE 40
        or   a,(ix+DIS)                 ;=> 037E  DD B6 40
        cp   a,(ix+DIS)                 ;=> 0381  DD BE 40
        sub  a,(iy+DIS)                 ;=> 0384  FD 96 40
        and  a,(iy+DIS)                 ;=> 0387  FD A6 40
        xor  a,(iy+DIS)                 ;=> 038A  FD AE 40
        or   a,(iy+DIS)                 ;=> 038D  FD B6 40
        cp   a,(iy+DIS)                 ;=> 0390  FD BE 40
        sub  a,N                        ;=> 0393  D6 20
        and  a,N                        ;=> 0395  E6 20
        xor  a,N                        ;=> 0397  EE 20
        or   a,N                        ;=> 0399  F6 20
        cp   a,N                        ;=> 039B  FE 20
        
        inc  b                          ;=> 039D  04
        dec  b                          ;=> 039E  05
        inc  c                          ;=> 039F  0C
        dec  c                          ;=> 03A0  0D
        inc  d                          ;=> 03A1  14
        dec  d                          ;=> 03A2  15
        inc  e                          ;=> 03A3  1C
        dec  e                          ;=> 03A4  1D
        inc  h                          ;=> 03A5  24
        dec  h                          ;=> 03A6  25
        inc  l                          ;=> 03A7  2C
        dec  l                          ;=> 03A8  2D
        inc  a                          ;=> 03A9  3C
        dec  a                          ;=> 03AA  3D
        inc  (hl)                       ;=> 03AB  34
        dec  (hl)                       ;=> 03AC  35
        inc  (ix+DIS)                   ;=> 03AD  DD 34 40
        dec  (ix+DIS)                   ;=> 03B0  DD 35 40
        inc  (iy+DIS)                   ;=> 03B3  FD 34 40
        dec  (iy+DIS)                   ;=> 03B6  FD 35 40
        

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  hl,bc                      ;=> 03B9  09
        add  hl,de                      ;=> 03BA  19
        add  hl,hl                      ;=> 03BB  29
        add  hl,sp                      ;=> 03BC  39
        add  ix,bc                      ;=> 03BD  DD 09
        add  ix,de                      ;=> 03BF  DD 19
        add  ix,ix                      ;=> 03C1  DD 29
        add  ix,sp                      ;=> 03C3  DD 39
        add  iy,bc                      ;=> 03C5  FD 09
        add  iy,de                      ;=> 03C7  FD 19
        add  iy,iy                      ;=> 03C9  FD 29
        add  iy,sp                      ;=> 03CB  FD 39

        sbc  hl,bc                      ;=> 03CD  ED 42
        adc  hl,bc                      ;=> 03CF  ED 4A
        sbc  hl,de                      ;=> 03D1  ED 52
        adc  hl,de                      ;=> 03D3  ED 5A
        sbc  hl,hl                      ;=> 03D5  ED 62
        adc  hl,hl                      ;=> 03D7  ED 6A
        sbc  hl,sp                      ;=> 03D9  ED 72
        adc  hl,sp                      ;=> 03DB  ED 7A
;	sub       hl,bc						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,de						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,hl						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,sp						=} 0xB7 0xED 0x42+<2:4>

        inc  bc                         ;=> 03DD  03
        dec  bc                         ;=> 03DE  0B
        inc  de                         ;=> 03DF  13
        dec  de                         ;=> 03E0  1B
        inc  hl                         ;=> 03E1  23
        dec  hl                         ;=> 03E2  2B
        inc  ix                         ;=> 03E3  DD 23
        dec  ix                         ;=> 03E5  DD 2B
        inc  iy                         ;=> 03E7  FD 23
        dec  iy                         ;=> 03E9  FD 2B
        inc  sp                         ;=> 03EB  33
        dec  sp                         ;=> 03EC  3B

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

        rlca                            ;=> 03ED  07
        rrca                            ;=> 03EE  0F
        rla                             ;=> 03EF  17
        rra                             ;=> 03F0  1F

        rlc  b                          ;=> 03F1  CB 00
        rrc  b                          ;=> 03F3  CB 08
        rl   b                          ;=> 03F5  CB 10
        rr   b                          ;=> 03F7  CB 18
        sla  b                          ;=> 03F9  CB 20
        sra  b                          ;=> 03FB  CB 28
        srl  b                          ;=> 03FD  CB 38
        rlc  c                          ;=> 03FF  CB 01
        rrc  c                          ;=> 0401  CB 09
        rl   c                          ;=> 0403  CB 11
        rr   c                          ;=> 0405  CB 19
        sla  c                          ;=> 0407  CB 21
        sra  c                          ;=> 0409  CB 29
        srl  c                          ;=> 040B  CB 39
        rlc  d                          ;=> 040D  CB 02
        rrc  d                          ;=> 040F  CB 0A
        rl   d                          ;=> 0411  CB 12
        rr   d                          ;=> 0413  CB 1A
        sla  d                          ;=> 0415  CB 22
        sra  d                          ;=> 0417  CB 2A
        srl  d                          ;=> 0419  CB 3A
        rlc  e                          ;=> 041B  CB 03
        rrc  e                          ;=> 041D  CB 0B
        rl   e                          ;=> 041F  CB 13
        rr   e                          ;=> 0421  CB 1B
        sla  e                          ;=> 0423  CB 23
        sra  e                          ;=> 0425  CB 2B
        srl  e                          ;=> 0427  CB 3B
        rlc  h                          ;=> 0429  CB 04
        rrc  h                          ;=> 042B  CB 0C
        rl   h                          ;=> 042D  CB 14
        rr   h                          ;=> 042F  CB 1C
        sla  h                          ;=> 0431  CB 24
        sra  h                          ;=> 0433  CB 2C
        srl  h                          ;=> 0435  CB 3C
        rlc  l                          ;=> 0437  CB 05
        rrc  l                          ;=> 0439  CB 0D
        rl   l                          ;=> 043B  CB 15
        rr   l                          ;=> 043D  CB 1D
        sla  l                          ;=> 043F  CB 25
        sra  l                          ;=> 0441  CB 2D
        srl  l                          ;=> 0443  CB 3D
        rlc  a                          ;=> 0445  CB 07
        rrc  a                          ;=> 0447  CB 0F
        rl   a                          ;=> 0449  CB 17
        rr   a                          ;=> 044B  CB 1F
        sla  a                          ;=> 044D  CB 27
        sra  a                          ;=> 044F  CB 2F
        srl  a                          ;=> 0451  CB 3F
        rlc  (hl)                       ;=> 0453  CB 06
        rrc  (hl)                       ;=> 0455  CB 0E
        rl   (hl)                       ;=> 0457  CB 16
        rr   (hl)                       ;=> 0459  CB 1E
        sla  (hl)                       ;=> 045B  CB 26
        sra  (hl)                       ;=> 045D  CB 2E
        srl  (hl)                       ;=> 045F  CB 3E
        rlc  (ix+DIS)                   ;=> 0461  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 0465  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 0469  DD CB 40 16
        rr   (ix+DIS)                   ;=> 046D  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 0471  DD CB 40 26
        sra  (ix+DIS)                   ;=> 0475  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 0479  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 047D  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 0481  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 0485  FD CB 40 16
        rr   (iy+DIS)                   ;=> 0489  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 048D  FD CB 40 26
        sra  (iy+DIS)                   ;=> 0491  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 0495  FD CB 40 3E
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

        rld                             ;=> 0499  CD D7 08
        rrd                             ;=> 049C  CD F9 08

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

        cpl                             ;=> 049F  2F
        neg                             ;=> 04A0  ED 44
        ccf                             ;=> 04A2  3F
        scf                             ;=> 04A3  37
        nop                             ;=> 04A4  00


;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

        bit  0,b                        ;=> 04A5  CB 40
        res  0,b                        ;=> 04A7  CB 80
        set  0,b                        ;=> 04A9  CB C0
        bit  1,b                        ;=> 04AB  CB 48
        res  1,b                        ;=> 04AD  CB 88
        set  1,b                        ;=> 04AF  CB C8
        bit  2,b                        ;=> 04B1  CB 50
        res  2,b                        ;=> 04B3  CB 90
        set  2,b                        ;=> 04B5  CB D0
        bit  3,b                        ;=> 04B7  CB 58
        res  3,b                        ;=> 04B9  CB 98
        set  3,b                        ;=> 04BB  CB D8
        bit  4,b                        ;=> 04BD  CB 60
        res  4,b                        ;=> 04BF  CB A0
        set  4,b                        ;=> 04C1  CB E0
        bit  5,b                        ;=> 04C3  CB 68
        res  5,b                        ;=> 04C5  CB A8
        set  5,b                        ;=> 04C7  CB E8
        bit  6,b                        ;=> 04C9  CB 70
        res  6,b                        ;=> 04CB  CB B0
        set  6,b                        ;=> 04CD  CB F0
        bit  7,b                        ;=> 04CF  CB 78
        res  7,b                        ;=> 04D1  CB B8
        set  7,b                        ;=> 04D3  CB F8
        bit  0,c                        ;=> 04D5  CB 41
        res  0,c                        ;=> 04D7  CB 81
        set  0,c                        ;=> 04D9  CB C1
        bit  1,c                        ;=> 04DB  CB 49
        res  1,c                        ;=> 04DD  CB 89
        set  1,c                        ;=> 04DF  CB C9
        bit  2,c                        ;=> 04E1  CB 51
        res  2,c                        ;=> 04E3  CB 91
        set  2,c                        ;=> 04E5  CB D1
        bit  3,c                        ;=> 04E7  CB 59
        res  3,c                        ;=> 04E9  CB 99
        set  3,c                        ;=> 04EB  CB D9
        bit  4,c                        ;=> 04ED  CB 61
        res  4,c                        ;=> 04EF  CB A1
        set  4,c                        ;=> 04F1  CB E1
        bit  5,c                        ;=> 04F3  CB 69
        res  5,c                        ;=> 04F5  CB A9
        set  5,c                        ;=> 04F7  CB E9
        bit  6,c                        ;=> 04F9  CB 71
        res  6,c                        ;=> 04FB  CB B1
        set  6,c                        ;=> 04FD  CB F1
        bit  7,c                        ;=> 04FF  CB 79
        res  7,c                        ;=> 0501  CB B9
        set  7,c                        ;=> 0503  CB F9
        bit  0,d                        ;=> 0505  CB 42
        res  0,d                        ;=> 0507  CB 82
        set  0,d                        ;=> 0509  CB C2
        bit  1,d                        ;=> 050B  CB 4A
        res  1,d                        ;=> 050D  CB 8A
        set  1,d                        ;=> 050F  CB CA
        bit  2,d                        ;=> 0511  CB 52
        res  2,d                        ;=> 0513  CB 92
        set  2,d                        ;=> 0515  CB D2
        bit  3,d                        ;=> 0517  CB 5A
        res  3,d                        ;=> 0519  CB 9A
        set  3,d                        ;=> 051B  CB DA
        bit  4,d                        ;=> 051D  CB 62
        res  4,d                        ;=> 051F  CB A2
        set  4,d                        ;=> 0521  CB E2
        bit  5,d                        ;=> 0523  CB 6A
        res  5,d                        ;=> 0525  CB AA
        set  5,d                        ;=> 0527  CB EA
        bit  6,d                        ;=> 0529  CB 72
        res  6,d                        ;=> 052B  CB B2
        set  6,d                        ;=> 052D  CB F2
        bit  7,d                        ;=> 052F  CB 7A
        res  7,d                        ;=> 0531  CB BA
        set  7,d                        ;=> 0533  CB FA
        bit  0,e                        ;=> 0535  CB 43
        res  0,e                        ;=> 0537  CB 83
        set  0,e                        ;=> 0539  CB C3
        bit  1,e                        ;=> 053B  CB 4B
        res  1,e                        ;=> 053D  CB 8B
        set  1,e                        ;=> 053F  CB CB
        bit  2,e                        ;=> 0541  CB 53
        res  2,e                        ;=> 0543  CB 93
        set  2,e                        ;=> 0545  CB D3
        bit  3,e                        ;=> 0547  CB 5B
        res  3,e                        ;=> 0549  CB 9B
        set  3,e                        ;=> 054B  CB DB
        bit  4,e                        ;=> 054D  CB 63
        res  4,e                        ;=> 054F  CB A3
        set  4,e                        ;=> 0551  CB E3
        bit  5,e                        ;=> 0553  CB 6B
        res  5,e                        ;=> 0555  CB AB
        set  5,e                        ;=> 0557  CB EB
        bit  6,e                        ;=> 0559  CB 73
        res  6,e                        ;=> 055B  CB B3
        set  6,e                        ;=> 055D  CB F3
        bit  7,e                        ;=> 055F  CB 7B
        res  7,e                        ;=> 0561  CB BB
        set  7,e                        ;=> 0563  CB FB
        bit  0,h                        ;=> 0565  CB 44
        res  0,h                        ;=> 0567  CB 84
        set  0,h                        ;=> 0569  CB C4
        bit  1,h                        ;=> 056B  CB 4C
        res  1,h                        ;=> 056D  CB 8C
        set  1,h                        ;=> 056F  CB CC
        bit  2,h                        ;=> 0571  CB 54
        res  2,h                        ;=> 0573  CB 94
        set  2,h                        ;=> 0575  CB D4
        bit  3,h                        ;=> 0577  CB 5C
        res  3,h                        ;=> 0579  CB 9C
        set  3,h                        ;=> 057B  CB DC
        bit  4,h                        ;=> 057D  CB 64
        res  4,h                        ;=> 057F  CB A4
        set  4,h                        ;=> 0581  CB E4
        bit  5,h                        ;=> 0583  CB 6C
        res  5,h                        ;=> 0585  CB AC
        set  5,h                        ;=> 0587  CB EC
        bit  6,h                        ;=> 0589  CB 74
        res  6,h                        ;=> 058B  CB B4
        set  6,h                        ;=> 058D  CB F4
        bit  7,h                        ;=> 058F  CB 7C
        res  7,h                        ;=> 0591  CB BC
        set  7,h                        ;=> 0593  CB FC
        bit  0,l                        ;=> 0595  CB 45
        res  0,l                        ;=> 0597  CB 85
        set  0,l                        ;=> 0599  CB C5
        bit  1,l                        ;=> 059B  CB 4D
        res  1,l                        ;=> 059D  CB 8D
        set  1,l                        ;=> 059F  CB CD
        bit  2,l                        ;=> 05A1  CB 55
        res  2,l                        ;=> 05A3  CB 95
        set  2,l                        ;=> 05A5  CB D5
        bit  3,l                        ;=> 05A7  CB 5D
        res  3,l                        ;=> 05A9  CB 9D
        set  3,l                        ;=> 05AB  CB DD
        bit  4,l                        ;=> 05AD  CB 65
        res  4,l                        ;=> 05AF  CB A5
        set  4,l                        ;=> 05B1  CB E5
        bit  5,l                        ;=> 05B3  CB 6D
        res  5,l                        ;=> 05B5  CB AD
        set  5,l                        ;=> 05B7  CB ED
        bit  6,l                        ;=> 05B9  CB 75
        res  6,l                        ;=> 05BB  CB B5
        set  6,l                        ;=> 05BD  CB F5
        bit  7,l                        ;=> 05BF  CB 7D
        res  7,l                        ;=> 05C1  CB BD
        set  7,l                        ;=> 05C3  CB FD
        bit  0,a                        ;=> 05C5  CB 47
        res  0,a                        ;=> 05C7  CB 87
        set  0,a                        ;=> 05C9  CB C7
        bit  1,a                        ;=> 05CB  CB 4F
        res  1,a                        ;=> 05CD  CB 8F
        set  1,a                        ;=> 05CF  CB CF
        bit  2,a                        ;=> 05D1  CB 57
        res  2,a                        ;=> 05D3  CB 97
        set  2,a                        ;=> 05D5  CB D7
        bit  3,a                        ;=> 05D7  CB 5F
        res  3,a                        ;=> 05D9  CB 9F
        set  3,a                        ;=> 05DB  CB DF
        bit  4,a                        ;=> 05DD  CB 67
        res  4,a                        ;=> 05DF  CB A7
        set  4,a                        ;=> 05E1  CB E7
        bit  5,a                        ;=> 05E3  CB 6F
        res  5,a                        ;=> 05E5  CB AF
        set  5,a                        ;=> 05E7  CB EF
        bit  6,a                        ;=> 05E9  CB 77
        res  6,a                        ;=> 05EB  CB B7
        set  6,a                        ;=> 05ED  CB F7
        bit  7,a                        ;=> 05EF  CB 7F
        res  7,a                        ;=> 05F1  CB BF
        set  7,a                        ;=> 05F3  CB FF
        bit  0,(hl)                     ;=> 05F5  CB 46
        res  0,(hl)                     ;=> 05F7  CB 86
        set  0,(hl)                     ;=> 05F9  CB C6
        bit  1,(hl)                     ;=> 05FB  CB 4E
        res  1,(hl)                     ;=> 05FD  CB 8E
        set  1,(hl)                     ;=> 05FF  CB CE
        bit  2,(hl)                     ;=> 0601  CB 56
        res  2,(hl)                     ;=> 0603  CB 96
        set  2,(hl)                     ;=> 0605  CB D6
        bit  3,(hl)                     ;=> 0607  CB 5E
        res  3,(hl)                     ;=> 0609  CB 9E
        set  3,(hl)                     ;=> 060B  CB DE
        bit  4,(hl)                     ;=> 060D  CB 66
        res  4,(hl)                     ;=> 060F  CB A6
        set  4,(hl)                     ;=> 0611  CB E6
        bit  5,(hl)                     ;=> 0613  CB 6E
        res  5,(hl)                     ;=> 0615  CB AE
        set  5,(hl)                     ;=> 0617  CB EE
        bit  6,(hl)                     ;=> 0619  CB 76
        res  6,(hl)                     ;=> 061B  CB B6
        set  6,(hl)                     ;=> 061D  CB F6
        bit  7,(hl)                     ;=> 061F  CB 7E
        res  7,(hl)                     ;=> 0621  CB BE
        set  7,(hl)                     ;=> 0623  CB FE
        bit  0,(ix+DIS)                 ;=> 0625  DD CB 40 46
        res  0,(ix+DIS)                 ;=> 0629  DD CB 40 86
        set  0,(ix+DIS)                 ;=> 062D  DD CB 40 C6
        bit  1,(ix+DIS)                 ;=> 0631  DD CB 40 4E
        res  1,(ix+DIS)                 ;=> 0635  DD CB 40 8E
        set  1,(ix+DIS)                 ;=> 0639  DD CB 40 CE
        bit  2,(ix+DIS)                 ;=> 063D  DD CB 40 56
        res  2,(ix+DIS)                 ;=> 0641  DD CB 40 96
        set  2,(ix+DIS)                 ;=> 0645  DD CB 40 D6
        bit  3,(ix+DIS)                 ;=> 0649  DD CB 40 5E
        res  3,(ix+DIS)                 ;=> 064D  DD CB 40 9E
        set  3,(ix+DIS)                 ;=> 0651  DD CB 40 DE
        bit  4,(ix+DIS)                 ;=> 0655  DD CB 40 66
        res  4,(ix+DIS)                 ;=> 0659  DD CB 40 A6
        set  4,(ix+DIS)                 ;=> 065D  DD CB 40 E6
        bit  5,(ix+DIS)                 ;=> 0661  DD CB 40 6E
        res  5,(ix+DIS)                 ;=> 0665  DD CB 40 AE
        set  5,(ix+DIS)                 ;=> 0669  DD CB 40 EE
        bit  6,(ix+DIS)                 ;=> 066D  DD CB 40 76
        res  6,(ix+DIS)                 ;=> 0671  DD CB 40 B6
        set  6,(ix+DIS)                 ;=> 0675  DD CB 40 F6
        bit  7,(ix+DIS)                 ;=> 0679  DD CB 40 7E
        res  7,(ix+DIS)                 ;=> 067D  DD CB 40 BE
        set  7,(ix+DIS)                 ;=> 0681  DD CB 40 FE
        bit  0,(iy+DIS)                 ;=> 0685  FD CB 40 46
        res  0,(iy+DIS)                 ;=> 0689  FD CB 40 86
        set  0,(iy+DIS)                 ;=> 068D  FD CB 40 C6
        bit  1,(iy+DIS)                 ;=> 0691  FD CB 40 4E
        res  1,(iy+DIS)                 ;=> 0695  FD CB 40 8E
        set  1,(iy+DIS)                 ;=> 0699  FD CB 40 CE
        bit  2,(iy+DIS)                 ;=> 069D  FD CB 40 56
        res  2,(iy+DIS)                 ;=> 06A1  FD CB 40 96
        set  2,(iy+DIS)                 ;=> 06A5  FD CB 40 D6
        bit  3,(iy+DIS)                 ;=> 06A9  FD CB 40 5E
        res  3,(iy+DIS)                 ;=> 06AD  FD CB 40 9E
        set  3,(iy+DIS)                 ;=> 06B1  FD CB 40 DE
        bit  4,(iy+DIS)                 ;=> 06B5  FD CB 40 66
        res  4,(iy+DIS)                 ;=> 06B9  FD CB 40 A6
        set  4,(iy+DIS)                 ;=> 06BD  FD CB 40 E6
        bit  5,(iy+DIS)                 ;=> 06C1  FD CB 40 6E
        res  5,(iy+DIS)                 ;=> 06C5  FD CB 40 AE
        set  5,(iy+DIS)                 ;=> 06C9  FD CB 40 EE
        bit  6,(iy+DIS)                 ;=> 06CD  FD CB 40 76
        res  6,(iy+DIS)                 ;=> 06D1  FD CB 40 B6
        set  6,(iy+DIS)                 ;=> 06D5  FD CB 40 F6
        bit  7,(iy+DIS)                 ;=> 06D9  FD CB 40 7E
        res  7,(iy+DIS)                 ;=> 06DD  FD CB 40 BE
        set  7,(iy+DIS)                 ;=> 06E1  FD CB 40 FE
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
        jp   NN                         ;=> 06E5  C3 30 00
        jp   (hl)                       ;=> 06E8  E9
        jp   (ix)                       ;=> 06E9  DD E9
        jp   (iy)                       ;=> 06EB  FD E9
        jp   nz,NN                      ;=> 06ED  C2 30 00
        jp   z,NN                       ;=> 06F0  CA 30 00
        jp   nc,NN                      ;=> 06F3  D2 30 00
        jp   c,NN                       ;=> 06F6  DA 30 00
        jp   po,NN                      ;=> 06F9  E2 30 00
        jp   pe,NN                      ;=> 06FC  EA 30 00
        jp   p,NN                       ;=> 06FF  F2 30 00
        jp   m,NN                       ;=> 0702  FA 30 00

										; max forward jump
        jr   jr2                        ;=> 0705  18 7F
        jr   jr2                        ;=> 0707  18 7D
        jr   jr2                        ;=> 0709  18 7B
        
        djnz ASMPC                      ;=> 070B  10 FE
        djnz ASMPC+0x81                 ;=> 070D  10 7F
        jr   ASMPC                      ;=> 070F  18 FE
        jr   ASMPC-0x7E                 ;=> 0711  18 80
        
        djnz jr1                        ;=> 0713  10 00
jr1:
        jr   jr1                        ;=> 0715  18 FE
        djnz jr1                        ;=> 0717  10 FC
        jr   nz,jr1                     ;=> 0719  20 FA
        jr   z,jr1                      ;=> 071B  28 F8
        jr   nc,jr1                     ;=> 071D  30 F6
        jr   c,jr1                      ;=> 071F  38 F4
        
        defs 127-26, 0FFh 
jr2:
        defs 122, 0FFh 
        jr   jr2                        ;=> 0800  18 84
        jr   jr2                        ;=> 0802  18 82
										; max backward jump - z80pack does not accept -128
        jr   jr2                        ;=> 0804  18 80
        

;	jr po,NN
;	jr pe,NN
;	jr p,NN
;	jr m,NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

        call NN                         ;=> 0806  CD 30 00
        ret                             ;=> 0809  C9
        ret  nz                         ;=> 080A  C0
        ret  z                          ;=> 080B  C8
        ret  nc                         ;=> 080C  D0
        ret  c                          ;=> 080D  D8
        ret  po                         ;=> 080E  E0
        ret  pe                         ;=> 080F  E8
        ret  p                          ;=> 0810  F0
        ret  m                          ;=> 0811  F8
        reti                            ;=> 0812  ED 4D
;	rst 0
;	rst 1
;	rst 2
;	rst 3
;	rst 4
;	rst 5
;	rst 6
;	rst 7


        call nz,NN                      ;=> 0814  28 03 CD 30 00
        call z,NN                       ;=> 0819  20 03 CD 30 00
        call nc,NN                      ;=> 081E  38 03 CD 30 00
        call c,NN                       ;=> 0823  30 03 CD 30 00
        call po,NN                      ;=> 0828  EA 2E 08 CD 30 00
        call pe,NN                      ;=> 082E  E2 34 08 CD 30 00
        call p,NN                       ;=> 0834  FA 3A 08 CD 30 00
        call m,NN                       ;=> 083A  F2 40 08 CD 30 00
        rst  10h                        ;=> 0840  D7
        rst  18h                        ;=> 0841  DF
        rst  20h                        ;=> 0842  E7
        rst  28h                        ;=> 0843  EF
        rst  38h                        ;=> 0844  FF



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
                                        ;=> 0845  38 12 BE 2B 0B F5 E3 CB 85 CB D5 78 B1 20 02 CB 95 E3 F1 C9 BE 2B 0B F5 E3 CB C5 18 EC 30 06 CD 6A 08 37 C9 2B 0B BE 28 12 0C 0D 20 F7 04 10 F4 BE 2B F5 E3 CB 85 CB 95 E3 F1 C9 2B F5 78 B1 28 F2 E3 CB 85 CB D5 E3 F1 C9 38 12 BE 23 0B F5 E3 CB 85 CB D5 78 B1 20 02 CB 95 E3 F1 C9 BE 23 0B F5 E3 CB C5 18 EC 30 06 CD B3 08 37 C9 23 0B BE 28 12 0C 0D 20 F7 04 10 F4 BE 23 F5 E3 CB 85 CB 95 E3 F1 C9 23 F5 78 B1 28 F2 E3 CB 85 CB D5 E3 F1 C9 30 05 CD DE 08 37 C9 07 07 07 07 CB 27 CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 B7 C9 30 05 CD 00 09 37 C9 CB 3F CB 1E 1F CB 1E 1F CB 1E 1F CB 1E 1F 1F 1F 1F 1F B7 C9
