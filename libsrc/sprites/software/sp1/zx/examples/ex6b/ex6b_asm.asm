
PUBLIC _scene
PUBLIC _gr_tiles
EXTERN _credit
EXTERN _fan
EXTERN _tree

._scene                        ; C variable "scene" will hold this address

   defb 22, 0, 10              ; set coords to (0,10)
   defb 7                      ; print credit
   defw _credit

   defb 22, 2, 1               ; set coords to (2,1)
   defb 7                      ; print fan
   defw _fan
   
   defb 22, 5, 23              ; set coords to (5,23)
   defb 7                      ; print fan
   defw _fan
   
   defb 22, 16, 6              ; set coords to (16,6)
   defb 7                      ; print fan
   defw _fan
   
   defb 20, $44                ; set attr to bright green on black
   
   defb 22, 15, 1              ; set coords to (15,1)
   defb 14, 9                  ; repeat 9 times (row loop)
   defb 14, 4                  ; repeat 4 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -4              ; move cursor one char down, four chars left
   defb 15                     ; end row loop

   defb 22, 11, 1              ; set coords to (11,1)
   defb 14, 4                  ; repeat 4 times (row loop)
   defb 14, 21                 ; repeat 21 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -21             ; move cursor one char down, 21 chars left
   defb 15                     ; end row loop

   defb 22, 2, 9               ; set coords to (2,9)
   defb 14, 9                  ; repeat 9 times (row loop)
   defb 14, 13                 ; repeat 13 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -13             ; move cursor one char down, 13 chars left
   defb 15                     ; end row loop
 
   defb 22, 14, 22             ; set coords to (14,22)
   defb 14, 9                  ; repeat 9 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop

   defb 22, 15, 14             ; set coords to (15,14)
   defb 14, 9                  ; repeat 9 times (row loop)
   defb 14, 17                 ; repeat 17 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -17             ; move cursor one char down, 17 chars left
   defb 15                     ; end row loop

   defb 22, 18, 17             ; set coords to (18,17)
   defb 7                      ; print tree
   defw _tree
   
   defb 22, 19, 25             ; set coords to (19,25)
   defb 7                      ; print tree
   defw _tree
   
   defb 22, 3, 10
   defb 14, 3                  ; repeat 3 times (row loop)
   defb 14, 3                  ; repeat 3 times (col loop)
   defb 26                     ; save cursor position
   defb 7                      ; print tree
   defw _tree
   defb 28                     ; restore cursor position
   defb 9, 9, 9, 9             ; move cursor to the right 4 chars
   defb 15                     ; end col loop
   defb 23, 3, -12             ; move cursor down 3 chars, left 12 chars
   defb 15                     ; end row loop

   defb 0                      ; end string
   
._gr_tiles

; fan graphic
; width = 5 chars, height = 6 chars
; character codes 128 through 152

	DEFB	$E0,$CF,$BF,$BE,$63,$4F,$5F,$7E
	DEFB	$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB	$03,$50,$F8,$FD,$FE,$FD,$FE,$FF
	DEFB	$EF,$17,$43,$E8,$FD,$FE,$FF,$FF
	DEFB	$EF,$F7,$F7,$FB,$3B,$98,$C7,$E7
	
	DEFB	$63,$4F,$5F,$7E,$63,$4F,$5F,$7F
	DEFB	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB	$FE,$FF,$FE,$FF,$FE,$FF,$FF,$FF
	DEFB	$FF,$FF,$FF,$FF,$AB,$81,$F0,$FC
	DEFB	$D3,$E1,$F1,$E8,$F0,$78,$54,$38
	
	DEFB	$7F,$7E,$7F,$7F,$7F,$7F,$7F,$7F
	DEFB	$F6,$FF,$FF,$FF,$FF,$FF,$FF,$FD
	DEFB	$AA,$FF,$FF,$FF,$FF,$FF,$FF,$55
	DEFB	$FF,$AF,$F5,$FA,$FF,$F6,$FF,$7E
	DEFB	$14,$C8,$E4,$A0,$54,$88,$C2,$A0
	
	DEFB	$7F,$7F,$7F,$7F,$7E,$7D,$7E,$7C
	DEFB	$C0,$D0,$68,$D0,$A8,$D4,$60,$54
	
	DEFB	$7E,$7C,$7E,$7F,$7E,$7F,$3F,$BF
	DEFB	$68,$50,$E8,$D4,$A0,$10,$A8,$41
	
	DEFB	$8B,$C5,$E0,$F8,$FB,$F8,$37,$CF
	DEFB	$FE,$55,$00,$00,$FB,$F8,$37,$CF
	DEFB	$AA,$55,$00,$00,$FB,$F8,$37,$CF
	DEFB	$AA,$54,$00,$00,$FB,$F8,$37,$CF
	DEFB	$91,$03,$07,$1B,$FB,$F8,$37,$CF

	DEFB	$EF,$F7,$F7,$FB,$FB,$F8,$37,$CF

; fan blade graphic frame 0/1
; width = 3 chars, height = 2 chars
; character codes 153 through 158

	DEFB	$EA,$D0,$00,$44,$02,$00,$03,$0F
	DEFB	$00,$55,$FE,$FF,$FE,$FF,$FF,$C3
	DEFB	$AB,$06,$03,$21,$00,$28,$C4,$F2

	DEFB	$3F,$3F,$3F,$1F,$87,$40,$D0,$F5
	DEFB	$91,$D3,$FF,$E7,$91,$2A,$14,$00
	DEFB	$FD,$FD,$FC,$FA,$E5,$13,$06,$5D

; fan blade graphic frame 1/1
; width = 3 chars, height = 2 chars
; character codes 159 through 164

	DEFB	234,208,  2, 85, 47, 31, 47, 15
	DEFB	  0,  0,128,229,255,255,255,195
	DEFB	171, 14,163, 81,248,252,248,242
	
	DEFB	  3,  0, 10,  0,130, 65,208,245
	DEFB	137,203,255,255,255,126,  0,  0
	DEFB	197, 42, 86, 62, 85,179,  6, 93	
	
; tree graphic
; width = 4 chars, height = 5 chars
; character codes 165 through 184

defb 251, 255, 190, 253, 251, 247, 207, 239  ; char block [0, 0]
defb 240, 134, 122, 239, 253, 252, 183, 127  ; char block [1, 0]
defb  15, 129,  80,   4,  64,  32, 132, 136  ; char block [2, 0]
defb 251, 255,  63,  63,  31,  13,  71, 135  ; char block [3, 0]

defb 223, 223, 159, 191, 191, 191, 191, 191  ; char block [0, 1]
defb 251, 124, 255, 251, 127, 255, 190, 219  ; char block [1, 1]
defb   4,  32,  85, 234, 176, 234, 208, 164  ; char block [2, 1]
defb  19,  35,   3,  41,   1,  33,  67, 169  ; char block [3, 1]

defb 127, 127, 127, 111, 127, 127, 123, 191  ; char block [0, 2]
defb 238, 249, 255, 255, 254, 255, 255, 251  ; char block [1, 2]
defb  16,   6, 109, 214, 253, 251, 222, 245  ; char block [2, 2]
defb  16, 160,  80, 128,  68, 128, 132,  17  ; char block [3, 2]

defb 158, 191, 159, 207, 229, 242, 216, 251  ; char block [0, 3]
defb 255, 173, 240, 108, 250, 127,  42,   1  ; char block [1, 3]
defb 250,  97,   2,  87, 252,  84, 160,   0  ; char block [2, 3]
defb   1,  81, 163,  67, 135,  13,  63, 159  ; char block [3, 3]

defb 250, 252, 191, 255, 255, 253, 223, 255  ; char block [0, 4]
defb 208, 125, 168, 147, 199, 253, 223, 255  ; char block [1, 4]
defb   4, 114, 160,  73, 159, 253, 223, 255  ; char block [2, 4]
defb  27,  63, 191, 255, 255, 253, 223, 255  ; char block [3, 4]

