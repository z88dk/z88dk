;
; SpecLisp patch for the ZX Spectrum
;
; This patch fixes the editor of the ancient SpecLisp interpreter by Serious Software.
; It adds stability by masking unwanted characters and permits the use of most of
; the symbols normally allowed by the LISP interpreters.
;
; '-' is still reserved as number sign: use '_' instead in functions and symbols.
;

; The patch must be loaded in the UDG area.
; Step by step patching process:

;    CLEAR 65200
;    MERGE ""          <- SpecLisp LOADER
;    LOAD "" CODE      <- SpecLisp program
;    LOAD "" CODE      <- this program patch
;
;	.. RANDOMIZE USR USR "r"    (= 65504)

; how to build with the z88dk tools:
;    del "speclisp-patch-quote.tap"
;    z80asm -a speclisp-patch-quote.asm
;    appmake +zx -b speclisp-patch-quote.bin --org 65324

;org 65368-44

	
org 65257


boot_c:
		ld	a,195		; JP
		ld ($70f4),a
		ld ($7122),a
		ld ($7171),a
		ld	hl,addquote
		ld ($70f5),hl
		ld	hl,addquote1
		ld ($7123),hl
		ld	hl,addquote2
		ld ($7172),hl
		; enter LISP
		jp $738F



addquote:		; $70f4 remapped
		cp	'.'
		jp	z,$710A
		cp 39	; quote ?
		jp nz,$70f8
		
		;LD B,14h	; bracket flag + a new flag for 'quote' on bit #4
		LD B,10h
		LD L,A
		ret		; 21

		
		
		
	; + 23  =  44
	
addquote1:   ; $7122 remapped
		bit 4,b
		jr z,noquote
		
		;res 4,b
		ld b,4				; set flag for brackets mode
		;ld b,2				; set 'in function' flag/tag
		;ld b,0				;
		
		;ld l,'('			; we are in brackets mode, now
		;call $716a			; decode line for LISP interpreter
		
		;ld de,(7$82C)
		;ld ($782A),de	; open bricket
		
;ld 	de,(782Ah)
;ld ($7830),de
;		call $6E0B			; bind 'quote' command	

		;call $70B3		; move to next char
		
		
;		push hl
;		pop bc
;		call $6f3f
;		;ld b,2
		
		
		ld de,$799D		; live value for 'quote'
		ld ($7830),de
		call $6E0B			; bind 'quote' command	

		;;;;call $70B3		; move to next char  ---??
		call $716a  ; read next parameter from input line
		ld de,($782a)
		call $6E0B			; bind parameter
		

;		ld de,($782C)		; let's open '('..
;		call $6E0B			; bind 'quote' command


;00007164:	EX DE,HL
;00007165:	LD (782Ch),DE		; (..) decoded item result
;00007169:	RET

		ld de,0
		ld ($782c),de
;		call $6e4a   (call 715f??)
		
		call $7158			; cons ($6e4a) and set TAG
		call $7158			; cons ($6e4a) and set TAG

		
;		ld de,($782a)	
;		call $6E0B			; bind parameter

;		ld de,0
;		ld ($782c),de
;		call $7158			; cons ($6e4a) and set TAG
;		call $7158			; cons ($6e4a) and set TAG
		
;		inc sp
;		inc sp
		
;		jp $7158			; cons ($6e4a) and set TAG
;		jp $715f			; cons ($6e4a) and set TAG

;		call $717a
;		ld de,0
;		ld ($782c),de
;		call $7158			; cons ($6e4a) and set TAG

		;jp $717a
		
;		call $6E4a			; close and bind item/block

;		ld b,2				; set 'in function' flag/tag
;		call $7174
		
;		ld b,2				; set 'in function' flag/tag

;nop
;nop
;nop
;nop

;		call $7122			; get argument for 'quote'

;		call $7122			; get argument for 'quote'
;		jp $717d
;		call $6E4a			; close and bind item/block
		
;		ld de,0
;		ld ($782c),de

;nop
;nop
;nop
	;CALL 716Ah		; decode line for LISP interpreter
	
	;LD DE,(782Ah)		; (RESULT) -
	;CALL 6E0Bh		; "cons" ("bind" accumlator) . DE
	
;		jp $7146
		;jp $7174
		
		
		;jp  $713a
;;
		call  $70c2			; decode next item between brackets
		jp  $7122			; decode next item between brackets
		;jp  $7158
;;		call $70b3			; pick next char and increment the editor buffer ptr
		;;jp  $7133			; go back to LISP interpreter


noquote:
		bit 2,b
		jp z,$7133
		jp $7126


addquote2:   ; $7171 remapped
		jp	z,$7174
		ld	a,39 ; quote
		cp l
		jp	z,$7174
		jp	$69AA		; "ch FOUND .. '(' expected" error message

		
;org 65368
		
patch:
		call 28713
		cp 128
		jr nc,filt

		cp 7		; EDIT to get back to BASIC   (RANDOMIZE USR 29772 restores LISP)
		ret z
		cp 8		; Left arrow for CANDEL
		ret z
		jr cont

in_quote: defb 0	; <- 16 bytes boundary


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
        DEFB    %01101100 
        DEFB    %01101100 
        DEFB    %00100100 
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
;; Character: '
;        DEFB    %00000000 
;        DEFB    %00001100 
;        DEFB    %00011000 
;        DEFB    %00000000 
;        DEFB    %00000000 
;        DEFB    %00000000 
;        DEFB    %00000000 
;        DEFB    %00000000 

;; 24 bytes, characters: ' ( )

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
		nop
		nop
		nop
		nop
		nop
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
		cp 39  ;"'"
		ret z
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
		add 144-31	; remap to UDG  (another fancy option could be to use UDG code 'O')

		ret
		
;		nop
;		nop
;		nop

		
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
		; cursor
		;ld	a,147
		ld	a,164
		ld (28757),a
		jp boot_c
		nop


; cursor shape is slightly different than in the other patch
; so we can see which LISP variant we are using !

		defb %10101010
		defb %01010101
		defb %10101010
		defb %01010101
		defb %10101010
		defb %01010101
		defb %10101010
		defb 0
