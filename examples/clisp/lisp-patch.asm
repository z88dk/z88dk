;
; Patch for the ZX Spectrum's SpecLisp v1.3, by Serious Software
; By Stefano Bodrato, (c) 5/2015
;
; This patch fixes the editor of the ancient SpecLisp interpreter by Serious Software.
; It adds stability by masking unwanted characters and permits the use of most of
; the symbols normally allowed by the LISP interpreters.
; '-' is still reserved as number sign.  Use '_' for functions and symbols.
;
; The patch must be loaded in the UDG area.
; Step by step patching process:

;    MERGE ""          <- SpecLisp LOADER
;    LOAD "" CODE      <- SpecLisp program
;    LOAD "" CODE USR "a"     <- this patch
;    POKE 28477,164 : POKE 28770,88 : POKE 28771,255
;
;	.. otherwise, RANDOMIZE USR USR "r"    (= 65504)


; patch build instructions:
; z88dk-z80asm -b lisp-patch.asm
; appmake +zx -b lisp-patch.bin --org 65368


; "quote" shortcut:
; (putprop (quote ') 24666 (quote subr))

; Removing definitions:
;(remprop (quote ....) (quote subr)) deletes a function def

; More command aliases:
;(putprop (quote defun) 25144 (quote subr))
;(putprop (quote prog) 25267 (quote subr))
;(putprop (quote progn) 24632 (quote subr))
;(de > (x y) (greaterp x y))
;(de >= (x y) (not (lessp x y)))
;(de < (x y) (lessp x y))
;(de <= (x y) (not (greaterp x y)))
;(de consp (x) (not (atom x)))
;(de symbolp (x) (cond (x)) (not (atom x)))


org 65368
		
patch:
		call 28713
		cp 128
		jr nc,filt

		cp 7		; EDIT to get back to BASIC   (RANDOMIZE USR 29772 restores LISP)
		ret z
		cp 8		; Left arrow for CANCEL
		ret z
		jr cont
		nop			; <- 16 bytes boundary


; Character: !
        DEFB    %00000000 
        DEFB    %00011000 
        DEFB    %00011000 
        DEFB    %00011000 
        DEFB    %00011000 
        DEFB    %00000000 
        DEFB    %00011000 
        DEFB    %00000000 
; Character: "
        DEFB    %00000000 
        DEFB    %00111100 
        DEFB    %00100100 
        DEFB    %00111100 
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00000000 
; Character: #
        DEFB    %00000000 
        DEFB    %00100100 
        DEFB    %01111110 
        DEFB    %00100100 
        DEFB    %00100100 
        DEFB    %01111110 
        DEFB    %00100100 
        DEFB    %00000000 
; Character: $
        DEFB    %00001000 
        DEFB    %00111110 
        DEFB    %00101000 
        DEFB    %00111110 
        DEFB    %00001010 
        DEFB    %00001010 
        DEFB    %00111110 
        DEFB    %00001000 
; Character: %
        DEFB    %00000000 
        DEFB    %01100010 
        DEFB    %01000100 
        DEFB    %00001000 
        DEFB    %00010000 
        DEFB    %00100010 
        DEFB    %01000110 
        DEFB    %00000000 
; Character: &
        DEFB    %00000000 
        DEFB    %00110000 
        DEFB    %01101000 
        DEFB    %00110000 
        DEFB    %01001010 
        DEFB    %01100100 
        DEFB    %00111010 
        DEFB    %00000000 
; Character: '
        DEFB    %00000000 
        DEFB    %00001100 
        DEFB    %00011000 
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00000000 

;; 16 bytes, characters: ( )
cont:
		cp 12		; DELETE
		ret z
		cp 13		; CR
		ret z
		
		cp 33
		jr nc,nofilt2
filt:
		ld a,32
		ret
		nop
		nop
		nop
		

; Character: *
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00100100 
        DEFB    %00011000 
        DEFB    %01111110 
        DEFB    %00011000 
        DEFB    %00100100 
        DEFB    %00000000 
; Character: +
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00011000 
        DEFB    %00011000 
        DEFB    %01111110 
        DEFB    %00011000 
        DEFB    %00011000 
        DEFB    %00000000 
		
		
;; 24 bytes, Characters: , - .
nofilt2:
;		cp 39  ;"'"
;		ret z
		cp '('
		ret z
		cp ')'
		ret z
		cp '.'
		ret z
		cp ','
		ret z
		cp '-'
		ret z

		cp 48
		ret nc
remap:
		add 144-31	; remap to UDG

		ret
		
		nop
		nop
		nop

		
; Character: /
        DEFB    %00000000 
        DEFB    %00000000 
        DEFB    %00000110 
        DEFB    %00001100 
        DEFB    %00011000 
        DEFB    %00110000 
        DEFB    %01100000 
        DEFB    %00000000 

boot:
		
		; patch keyboard scan code
		ld hl,patch
		ld (28770),hl
		; extend the character set to UDG
		ld	a,164
		ld (28477),a
		; suppress the annoying '*' prompt
		xor a
		ld (28749),a
		ld	a,164
		ld (28757),a
		
		; enter LISP
		jp 24500
		
		nop

; custom cursor
		defb %10101010
		defb %01010101
		defb %10101010
		defb %01010101
		defb %10101010
		defb %01010101
		defb %10101010
		defb %01010101
