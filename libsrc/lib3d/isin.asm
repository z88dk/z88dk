;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int isin(unsigned degrees);
;	input must be between 0 and 360
;	returns value from -255 to +255
;
; ------
; $Id: isin.asm,v 1.3 2016-06-28 19:31:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	isin
	PUBLIC	_isin


isin:
_isin:
	; __FASTCALL__
        ld      c,l
        ld      b,h ;; save input
        ld      de,181
        or      a
        sbc     hl,de
        jr      c,DontFlip
        ld      hl,360
        sbc     hl,bc  ;; no carry here
        ld      c,l
        ld      b,h
        ld      a,1
        jr      Norm_0_180
DontFlip:
        ld      l,c
        ld      h,b
        xor     a
Norm_0_180:
;; degrees normalized between 0 and 180 in hl and in bc
;; sign of output in a
        ld      de,90
        or      a
        sbc     hl,de
        jr      c,DontFlip2
        ld      hl,180
        sbc     hl,bc   ;; carry is 0 here
        jr      Norm_0_90
DontFlip2:
        ld      l,c
        ld      h,b
Norm_0_90:
;; degrees normalized between 0 and 90 in hl and sign of answer is in a
        ;add     hl,hl
        ld      de,sin_table
        add     hl,de
        ld      e,(hl)
        ;inc     hl
        ;ld      d,(hl)
        ld	d,0
;; de=answer
        or      a
        jr      z,DontNegate
        ld      hl,0
        sbc     hl,de   ;; carry is 0 here
        ret
DontNegate:
        ex      de,hl
        ret

	SECTION rodata_clib
sin_table:

;; Smaller table, generated with Excel; formula (Italian language):  =INT(SEN(RADIANTI(A1))*255,4)
defb  0    ; 0
defb  4    ; 1
defb  8    ; 2
defb  13    ; 3
defb  17    ; 4
defb  22    ; 5
defb  26    ; 6
defb  31    ; 7
defb  35    ; 8
defb  39    ; 9
defb  44    ; 10
defb  48    ; 11
defb  53    ; 12
defb  57    ; 13
defb  61    ; 14
defb  66    ; 15
defb  70    ; 16
defb  74    ; 17
defb  78    ; 18
defb  83    ; 19
defb  87    ; 20
defb  91    ; 21
defb  95    ; 22
defb  99    ; 23
defb  103    ; 24
defb  107    ; 25
defb  111    ; 26
defb  115    ; 27
defb  119    ; 28
defb  123    ; 29
defb  127    ; 30
defb  131    ; 31
defb  135    ; 32
defb  139    ; 33
defb  142    ; 34
defb  146    ; 35
defb  150    ; 36
defb  153    ; 37
defb  157    ; 38
defb  160    ; 39
defb  164    ; 40
defb  167    ; 41
defb  170    ; 42
defb  174    ; 43
defb  177    ; 44
defb  180    ; 45
defb  183    ; 46
defb  186    ; 47
defb  189    ; 48
defb  192    ; 49
defb  195    ; 50
defb  198    ; 51
defb  201    ; 52
defb  203    ; 53
defb  206    ; 54
defb  209    ; 55
defb  211    ; 56
defb  214    ; 57
defb  216    ; 58
defb  218    ; 59
defb  221    ; 60
defb  223    ; 61
defb  225    ; 62
defb  227    ; 63
defb  229    ; 64
defb  231    ; 65
defb  233    ; 66
defb  235    ; 67
defb  236    ; 68
defb  238    ; 69
defb  239    ; 70
defb  241    ; 71
defb  242    ; 72
defb  244    ; 73
defb  245    ; 74
defb  246    ; 75
defb  247    ; 76
defb  248    ; 77
defb  249    ; 78
defb  250    ; 79
defb  251    ; 80
defb  252    ; 81
defb  252    ; 82
defb  253    ; 83
defb  254    ; 84
defb  254    ; 85
defb  254    ; 86
defb  255    ; 87
defb  255    ; 88
defb  255    ; 89
defb  255    ; 90
