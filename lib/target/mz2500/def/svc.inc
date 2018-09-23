;============================================================================
;	MZ-2500 IOCSコール (SVCコール)
; MZ-2500 IOCS call (SVC call)
;============================================================================

;SVC	MACRO
;	RST	18h
;	DB	%1
;	ENDM

;----------------------------------------------------------------------------
;	パラメータ受け渡しエリア
; Parameter passing area
;----------------------------------------------------------------------------
KEYBUF	EQU	0A01h	; 0A01h-0B0Fh
BUF2	EQU	0B10h	; 0B10h-0C1Fh
BUF3	EQU	0C20h	; 0C20h-0CBFh
BUF4	EQU	0CC0h	; 0CC0h-0DBFh
DIRARE	EQU	1000h	; 1000h-17FFh
SVCCW	EQU	0CC0h	; 0CC0h-0CECh

KCTRLS	EQU	05D2h
CURSW	EQU	05D3h
CURX	EQU	05E2h
CURY	EQU	05E3h
CURXST	EQU	05E4h
CURYST	EQU	05E5h
CURXED	EQU	05E6h
CURYED	EQU	05E7h
CURCOL	EQU	05E8h
CURLIN	EQU	05E9h
INSMOD	EQU	05EAh
CURTXT	EQU	05ECh
SCROLL	EQU	05EDh
DSPSA	EQU	05EFh	;word
COLORA	EQU	05F4h
CHRATR	EQU	05F5h
DSPMOD	EQU	05F8h
CURBGC	EQU	05F9h	;word
DSPSL	EQU	05FBh	;word
DSPEL	EQU	05FDh	;word
DSPSC	EQU	05FFh
DSPEC	EQU	0600h
TABTBL	EQU	0602h	;byte[10]
KANJI	EQU	060Ch
FKLIST	EQU	060Dh
FNTSEL	EQU	0610h
KANKAN	EQU	0613h
IE_KEY	EQU	0680h
IE_STO	EQU	0694h
IE_HEL	EQU	0694h
IE_COM	EQU	0696h
IE_MOU	EQU	0698h
IE_TIM	EQU	069Dh
IE_ITV	EQU	069Eh
IE_PLA	EQU	069Fh
I_MSTR	EQU	06A2h

;----------------------------------------------------------------------------
;	プリンタ・ファイル・キー入力・OPN
; Printer · File · Key input · OPN
;----------------------------------------------------------------------------

;----------------------------------------------------------------------------
; MONOP
; モニタ・モードに入る
; IN :	無
; OUT:	無
; DES:	全
; Enter monitor mode
; IN: None
; OUT: None
; DES: all
;
_MONOP	EQU	00h

;----------------------------------------------------------------------------
; CR1
; 改行する
; IN :	無
; OUT:	無
; DES:	IY
; Begin on a new line
; IN: None
; OUT: None
; DES: IY
;
_CR1	EQU	01h

;----------------------------------------------------------------------------
; CR2
; 行頭でなければ改行する
; IN :	無
; OUT:	無
; DES:	IY
; Break at the beginning of the line
; IN: None
; OUT: None
; DES: IY
;
_CR2	EQU	02h

;----------------------------------------------------------------------------
; CRT1C
; CRTへ1文字出力する
; IN :	A = 文字コード
; OUT:	無
; DES:	IY
; Output one character to CRT
; IN: A = character code
; OUT: None
; DES: IY
;
_CRT1C	EQU	03h

;----------------------------------------------------------------------------
; CRT1X
; CRTへ1文字出力する　制御コードを実行しない
; IN :	無
; OUT:	無
; DES:	IY
; Do not execute control code to output one character to CRT
; IN: None
; OUT: None
; DES: IY
;
_CRT1X	EQU	04h

;----------------------------------------------------------------------------
; CRTMSG
; CRTへ文字列を出力する
; IN :	DE = ASCIIZ文字列アドレス
; OUT:	無
; DES:	AF, IY
; Output character string to CRT
; IN: DE = ASCIIZ character string address
; OUT: None
; DES: AF, IY
;
_CRTMSG	EQU	05h

;----------------------------------------------------------------------------
; LPTOT
; プリンタへ1文字出力 コード変換無し
; IN :	A = 出力データ
; OUT:	無
; DES:	全
; LPTOT
; 1 character output code to printer No conversion
; IN: A = output data
; OUT: None
; DES: all
;
_LPTOT	EQU	06h

;----------------------------------------------------------------------------
; LPT1C
; プリンタへ1文字出力 プリンタの種類に合わせてコード変換を行う
; IN :	A = 出力データ
; OUT:	無
; DES:	全
; 1 character output to printer Convert code according to printer type
; IN: A = output data
; OUT: None
; DES: all
;
_LPT1C	EQU	07h

;----------------------------------------------------------------------------
; DISP
; 指定位置に文字を表示する　制御コードはそのコードに対応するキャラクタが表示される
; IOCS用のコールであり、ユーザが使うものではない
; IN :	A = データ
;	H = 横位置
;	L = 縦位置
; OUT:	無
; DES:	全
; For the control code that displays characters at the specified position, the character corresponding to that code is displayed
; This is a call for IOCS and not used by user
; IN: A = data
; H = horizontal position
; L = vertical position
; OUT: None
; DES: all
;
_DISP	EQU	08h

_TERM	EQU	09h

;----------------------------------------------------------------------------
; GETL
; キーボードから1行入力
; IN :	DE = バッファアドレス
; OUT:	Cy = 1 : SHIFT+BREAKが押された
;	   = 0 : SHIFT+BREAKが押されていない
; DES:	BC, HL以外
; GETL
; One line input from the keyboard
; IN: DE = buffer address
; OUT: Cy = 1: SHIFT + BREAK pressed
; = 0: SHIFT + BREAK not pressed
; DES: other than BC, HL
;
_GETL	EQU	0Ch

;----------------------------------------------------------------------------
; INKEY
; キーボードから1文字入力する
; IN :	A[Bit0] = 0 : キーが押されていなければ Zf = 1 でリターンする
;		= 1 : キーが押されるまで待つ
;	A[Bit1] = 0 : ファンクションキーを展開しない
;		= 1 : ファンクションキーを展開する
;	A[Bit2] = 0 : かな漢字変換を行わない
;		= 1 : かな漢字変換を行う
;	A[Bit3] = 0 : アルゴキー・COPYキーはフラグのみセットする
;		= 1 : アルゴキー・COPYキーの機能を実行する
; OUT:	Zf = 1 : キー入力なし
;	   = 0 :
;		[通常キーの場合]
;		  B         = ASCIIコード
;		  C[Bit7]   = 0
;		  C[Bit6-0] = key mode
;		[特殊キーの場合]
;		  B         = key code
;		  C[Bit7]   = 1
;		  C[Bit6-0] = key mode
;
; DES:	HL, DE以外
; Input one character from the keyboard
; IN: A [Bit 0] = 0: If the key is not pressed, return with Zf = 1
; = 1: Wait until the key is pressed
; A [Bit 1] = 0: Do not expand the function key
; = 1: Expands the function key
; A [Bit 2] = 0: Kana-Kanji conversion is not performed
; = 1: Perform Kana-Kanji conversion
; A [Bit 3] = 0: Algo key · COPY key sets only flag
; = 1: Execute the function of the Algo key · COPY key
; OUT: Zf = 1: No key input
; = 0:
; [For normal key]
; B = ASCII code
; C [Bit 7] = 0
; C [Bit 6 - 0] = key mode
; [For special keys]
; B = key code
; C [Bit 7] = 1
; C [Bit 6 - 0] = key mode
;
_INKEY	EQU	0Dh

;----------------------------------------------------------------------------
; BRKEY
; SHIFT+BREAKが押されているかをチェック
; IN :	無
; OUT:	押されていたら Zf=1, Cy=1
; DES:	AF
; Check if SHIFT + BREAK is pressed
; IN: None
; OUT: Zf = 1, Cy = 1 if pressed
; DES: AF
;
_BREAK	EQU	0Eh

;----------------------------------------------------------------------------
; HALT
; BREAKが押されたら、キー何か押されるまで待つ
; IN :	A[0] = 1
; OUT:	無
; DES:	AF
; When BREAK is pressed, wait until some key is pressed
; IN: A [0] = 1
; OUT: None
; DES: AF
;
_HALT	EQU	0Fh

;----------------------------------------------------------------------------
; DI
; 割り込みを禁止する
; IN :	A = 0     : 1ms〜1s程度の期間割り込みを禁止する場合に使用
;	  = 0以外 : 1s以上の期間割り込みを禁止する場合に使用(music wait)
; OUT:	無
; DES:	AF
; Disable interrupts
; IN: A = 0: Used when prohibiting interrupts for about 1 ms to 1 s
; = Other than 0: Used when prohibiting interrupt for 1 s or more (music wait)
; OUT: None
; DES: AF
;
_DI	EQU	10h

;----------------------------------------------------------------------------
; EI
; 割り込みを許可する
; IN :	無
; OUT:	無
; DES:	AF
; Allow interrupts
; IN: None
; OUT: None
; DES: AF
;
_EI	EQU	11h

;----------------------------------------------------------------------------
; NEWON
; RAM IOCSから機能を切り離し、メモリを開放する
; IN :	A = 0 : レベルII (電卓・カラーシミュレーションなど)
;	  = 1 : .mouse, .voice
;	  = 2 : .jisho
;	  = 3 : .term, .kkan
;	  = 4 : .cls, .posck, .possv, .pset, .line, .patter, .box,
;		.paint, .circle, .point, .ginit, .view, .scren,
;		.color, .symbl, .hview, .crep, .gput, .gget,
;		.pense, .move, .pri, .cbloc, .crti, .cocnv, .hroll
;	  = 5 : .lptra, .hcpy
; OUT:	無
; DES:	AF
; Detach function from RAM IOCS and release memory
; IN: A = 0: Level II (calculator · color simulation etc.)
; = 1: .mouse, .voice
; = 2: .jisho
; = 3: .term, .kkan
; = 4: .cls, .posck, .possv, .pset, .line, .patter, .box,
; .paint, .circle, .point, .ginit, .view, .scren,
; .color, .symbl, .hview, .crep, .gput, .gget,
; .pense, .move, .pri, .cbloc, .crti, .cocnv, .hroll
; = 5: .lptra, .hcpy
; OUT: None
; DES: AF
;
_NEWON	EQU	12h

;----------------------------------------------------------------------------
; DEASC
; ASCII文字列をバイナリに変換する
; 対応文字列は 10進整数(1〜65535), $xxxx, &H, &O, &B, &J, &K
; IN :	HL = ASCII文字列のアドレス
; OUT:	DE = バイナリデータ（&J, &Kの場合はシフトJISコード）
;	HL = 変換した文字列の次のアドレス
;	Cy = 0 : 正常終了 Aレジスタに変換した数値のタイプを返す
;	   = 1 : オーバーフロー(A=2) / エラー(A=3)
;	A  = 変換した数値のタイプ(正常終了時)
;		0Eh:&B     0Fh:&O  10h:&H  11h:$xxxx
;		12h:10進数 13h:&J  14h:&K
; DES:	AF, HL, DE
; Convert an ASCII string to binary
; The corresponding string is a decimal integer (1 to 65535), $ xxxx, & H, & O, & B, & J, & K
; IN: HL = Address of ASCII character string
; OUT: DE = binary data (& J, shift JIS code for & K)
; HL = address following the converted character string
; Cy = 0: Normal termination Returns the type of numeric value converted to A register
; = 1: overflow (A = 2) / error (A = 3)
; A = Type of converted value (upon successful completion)
; 0Eh: & B 0Fh: & O 10h: & H 11h: $ xxxx
; 12h: Decimal number 13h: & J 14h: & K
; DES: AF, HL, DE
;
_DEASC	EQU	13h

;----------------------------------------------------------------------------
; DEHEX
; ASCII文字列の16進数をバイナリに変換する "$", "&H" は不要
; IN :	HL = ASCII文字列のアドレス
; OUT:	DE = バイナリデータ
;	HL = 変換した文字列の次のアドレス
;	Cy = 1 : 正常終了
;	A  = 2 : オーバーフロー
; DES:	AF, HL, DE
; Convert hexadecimal ASCII string to binary "$", "& H" unnecessary
; IN: HL = Address of ASCII character string
; OUT: DE = binary data
; HL = address following the converted character string
; Cy = 1: normal termination
; A = 2: overflow
; DES: AF, HL, DE
;
_DEHEX	EQU	14h

;----------------------------------------------------------------------------
; CKHEX
; ASCIIコードが16進数文字かどうかをチェック
; IN :	A  = ASCIIコード
; OUT:	Cy = 0 : ASCIIコードは[0-9A-Fa-f] Aレジスタに00h〜0Fhの値を返す
;	Cy = 1 : ASCIIコードは16進数文字ではない
; DES:	AF
; Check if the ASCII code is a hexadecimal character
; IN: A = ASCII code
; OUT: Cy = 0: The ASCII code returns the value of 00h to 0Fh to the [0-9A - Fa - f] A register
; Cy = 1: ASCII code is not a hexadecimal character
; DES: AF
;
_CKHEX	EQU	15h

;----------------------------------------------------------------------------
; ASCHL
; 無符号整数を10進数のASCII文字列に変換する
; IN :	HL = バイナリデータ(無符号整数)
;	DE = 結果を格納するバッファアドレス
;	B  = 0     : ゼロサプレスする
;	   = 0以外 : 先頭の'0'をスペースにする(結果は5バイトになる)
; OUT:	DE = 格納したASCII文字列の次のアドレス
; DES:	AF, DE
; Convert an unsigned integer to a decimal ASCII string
; IN: HL = Binary data (unsigned integer)
; DE = buffer address to store the result
; B = 0: zero suppression
; Other than 0: Leading '0' to space (result is 5 bytes)
; OUT: DE = address following the stored ASCII character string

;
_ASCHL	EQU	16h

;----------------------------------------------------------------------------
; COUNT
; 文字列の長さを返す
; IN :	DE = 文字列のアドレス
; OUT:	B  = 文字列の長さ
; DES:	AF
; Returns the length of a string
; IN: DE = String address
; OUT: B = length of string
; DES: AF
;
;
_COUNT	EQU	17h

_KKAN	EQU	18h

;----------------------------------------------------------------------------
; JISHO
; 辞書ROM変換 MZ-1R28が必要
; IN :	A = 機能コード
;		0 : 文節変換        第1候補取り出し
;		1 : 文節変換        次候補取り出し
;		2 : 文節変換        前候補取り出し
;		3 : 人名・地名変換　第1候補取り出し
;		4 : 人名・地名変換  次候補取り出し
;		5 : 人名・地名変換  前候補取り出し
;	(KEYBUF) = 変換対象 SHIFT-JIS 最大40バイト
; OUT:	HL       = 候補数
;	B        = 辞書ROMの有無 0:無し
;	(KEYBUF) = 変換結果
; DES:	AF
; Dictionary ROM conversion MZ-1R 28 required
; IN: A = Function code
; 0: First clause retrieval of clause conversion
; 1: Retrieve clause candidate next candidate
; 2: retrieve candidate before clause conversion
; 3: person name / place name conversion first candidate retrieval
; 4: Person name / place name conversion next candidate retrieval
; 5: Retrieve candidate before conversion of person's name / place name
; (KEYBUF) = Conversion target SHIFT-JIS maximum 40 bytes
; OUT: HL = candidate number
; B = presence / absence of dictionary ROM 0: none
; (KEYBUF) = conversion result
; DES: AF
;
_JISHO	EQU	19h

_DIOCS	EQU	1Ah

;----------------------------------------------------------------------------
; ERRX
; エラーメッセージを表示する
; IN :	A  = エラーコード
;	     Bit7 = 1 にすると、直前にアクセスしたデバイス名とファイル名も
;	     表示する
; OUT:	無
; DES:	無
; Display error message
; IN: A = error code
; When Bit 7 = 1, the device name and file name accessed immediately before
;	indicate
; OUT: None
; DES: none
;
_ERRX	EQU	1Bh

;----------------------------------------------------------------------------
; KCONV
; 漢字コードを変換する
; IN :	A  = 0 : シフトJIS  → JIS
;	     1 : JIS        → シフトJIS
;	     2 : シフトJIS  → 区点コード
;	     3 : 区点コード → シフトJIS
;	     4 : 区点コード → JIS
;	     5 : JIS        → 区点コード
; OUT:	HL = 変換した漢字コード
;	Cy = 1 : エラー(HL=81A6h "※" を返す)
; DES:	AF
; Convert Kanji code
; IN: A = 0: Shift JIS → JIS
; 1: JIS → shift JIS
; 2: shift JIS → zone code
; 3: Area code → Shift JIS
; 4: Area code → JIS
; 5: JIS → zone code
; OUT: HL = Converted Kanji code
; Cy = 1: Error (HL = 81 A 6 h "*" is returned)
; DES: AF
;
_KCONV	EQU	1Ch

_LPTRA	EQU	1Dh

;----------------------------------------------------------------------------
; ?PONT
; キャラクタ画面のXY座標からVRAMのアドレスを計算する
; IN :	L = X座標
;	H = Y座標
; OUT:	HL = VRAMアドレス(C000h〜C7FFh)
; DES:	全
; Calculate the address of the VRAM from the XY coordinates of the character screen
; IN: L = X coordinate
; H = Y coordinate
; OUT: HL = VRAM address (C000h to C7FFh)
; DES: all
;
_PONT	EQU	1Eh

_KCALL	EQU	1Fh

;----------------------------------------------------------------------------
; BELL
; ベルを鳴らす(880Hz)
; IN :	無
; OUT:	無
; DES:	AF
; Ring the bell (880 Hz)
; IN: None
; OUT: None
; DES: AF
;
_BELL	EQU	20h

;----------------------------------------------------------------------------
; PLAY
; 音楽を演奏する
; IN :	A  = チャンネル(0-5)	(MCTRLで演奏中でないことを確認すること)
;	   = FFh : 全チャンネル
;	DE = MMLアドレス
; OUT:	無
; DES:	全
; Play music
; IN: A = Channel (0-5) (Make sure you are not playing on MCTRL)
; = FFh: all channels
; DE = MML address
; OUT: None
; DES: all
;
_PLAY	EQU	21h

;----------------------------------------------------------------------------
; SOUND
; SSGのレジスタにデータを書き込む
; IN :	B = 0 : 指定時間だけ音を鳴らす
;		A = 音階(0-95)
;		E = 音長(0.1s単位)
;	B = 1 : SSGレジスタ書き込み
;		A = SSG レジスタ番号
;		E = 書き込みデータ
; OUT:	無
; DES:	AF
; Write data to SSG registers
; IN: B = 0: Sounds for specified time
; A = scale (0 - 95)
; E = Tone length (0.1 s unit)
; B = 1: Write SSG register
; A = SSG register number
; E = write data
; OUT: None
; DES: AF
;
_SOUND	EQU	22h

;----------------------------------------------------------------------------
; MCTRL
; 音楽演奏関連制御
; IN :	B = 0 :	PSGルーチンの初期設定(music init)
;	  = 1 :	演奏開始
;	  = 2 : 演奏停止
;	  = 3 : 演奏中なら演奏が終わるまで待つ
;	  = 4 : 演奏中かどうか調べる(OUT: Zf=0 で演奏中)
;	  = 5 : システム音色データ取り出し
;		A  = 音色番号(0-29)
;		DE = バッファアドレス(29バイト必要)
;	  = 6 : ユーザー作成の音色データをセット
;		C  = チャンネル(0-2)
;		HL = 音色データのアドレス(26バイト)
;	  = 7 : LFOデータセット/取り出し
;		A = 0 : 取り出し
;		  = 1 : セット
;		C = チャンネル(0-5)
;		HL = バッファアドレス(4バイト)
; OUT:	無
; DES:	AF
; MCTRL
; Music performance related control
; IN: B = 0: PSG routine initial setting (music init)
; = 1: start playing
; = 2: Stop playing
; = 3: Wait until the performance is over if you are playing
; = 4: Check if it is playing (OUT: Zf = 0 playing)
; = 5: System tone color data retrieval
; A = tone color number (0 - 29)
; DE = Buffer address (29 bytes required)
; = 6: Set user created tone color data
; C = Channel (0-2)
; HL = tone color data address (26 bytes)
; = 7: LFO dataset / fetch
; A = 0: removal
; = 1: set
; C = Channel (0 - 5)
; HL = buffer address (4 bytes)
; OUT: None
; DES: AF
;
_MCTRL	EQU	23h

;----------------------------------------------------------------------------
; PRT1C
; ファイルへ1文字出力
; IN :	A = データ
; OUT:	無
; DES:	AF
; PRT 1 C
; Output 1 character to file
; IN: A = data
; OUT: None
; DES: AF
;
_PRT1C	EQU	26h

;----------------------------------------------------------------------------
; INP1C
; ファイルから1文字入力
; IN :	無
; OUT:	A = データ
;	Cy = 1 (EOF検出時)
; DES:	AF
; Enter one character from file
; IN: None
; OUT: A = data
; Cy = 1 (when EOF is detected)
; DES: AF
;
_INP1C	EQU	27h

;----------------------------------------------------------------------------
; CLRIO
; すべてのopenをキャンセルし、IOCSを初期化
; 書き込み途中のものはkillする
; IN :	無
; OUT:	無
; Cancel all open and initialize IOCS
; Kill what is being written
; IN: None
; OUT: None
; DES: AF
; DES:	AF
;
_CLRIO	EQU	28h

;----------------------------------------------------------------------------
; PWD
; カレントディレクトリのパス名を得る
; IN :	無
; OUT:	DE = パス名を読み込むためのバッファアドレス
;		(一般的には1000h-17FFhのDIR Areaをバッファとして使用する)
;	B  = パス名の長さ
; Get the path name of the current directory
; IN: None
; OUT: DE = buffer address to read path name
; (Generally, use DIR Area of ​​1000h - 17FFh as buffer)
; B = length of path name
; DES: all
; DES:	全
;
_PWD	EQU	2Ah

;----------------------------------------------------------------------------
; MKDIR
; ディレクトリ作成 DEVNMをコールした後に呼ぶこと
; IN :	無
; OUT:	無
; DES:	AF
; Create Directory Create a call after calling DEVNM
; IN: None
; OUT: None
; DES: AF
;
_MKDIR	EQU	2Bh

;----------------------------------------------------------------------------
; DEVNM
; デバイス名とディレクトリ名を解釈する
; 文字列バッファとしてKEYBUFを使用
; IN :	DE = デバイス名とディレクトリ名を格納したバッファアドレス
;	B  = 長さ
; OUT:	HL = pointer(next)
;	DE = device table
;	A  = channel
; DES:	全
; Interpret device and directory names
; Use KEYBUF as a string buffer
; IN: DE = buffer address storing device name and directory name
; B = length
; OUT: HL = pointer (next)
; DE = device table
; A = channel
; DES: all
;
_DEVNM	EQU	2Ch

;----------------------------------------------------------------------------
; DEVFN
; デバイス名とディレクトリ名とファイル名を解釈する
; 文字列バッファとしてKEYBUFを使用
; IN :	DE = デバイス名・ディレクトリ名・ファイル名を格納したバッファアドレス
;	B  = 長さ
; OUT:	無
; DES:	全
; Interpret device name, directory name and file name
; Use KEYBUF as a string buffer
; IN: DE = buffer address storing device name, directory name, file name
; B = length
; OUT: None
; DES: all
;
_DEVFN	EQU	2Dh

;----------------------------------------------------------------------------
; LUCHK
; 次に使用するlogical-unit-number(lu)を指定する
; 複数のluを使用する場合、luが変わるたびに呼び出す必要がある
; IN :	A  = lu
; OUT:	A  = 1 : Readオープンされている
;	   = 2 : Writeオープンされている
;	   = 4 : RANDOMファイルとしてオープンされている
;	Cy = 1 : オープンされていない
; DES:	AF
; Specify the logical-unit-number (lu) to be used next
; When using multiple lu's, you need to call each time lu changes
; IN: A = lu
; OUT: A = 1: Read is open
; = 2: Write is open
; = 4: Open as RANDOM file
; Cy = 1: not open
; DES: AF
;
_LUCHK	EQU	2Eh

;----------------------------------------------------------------------------
; LOPEN
; ロードを実行するためにファイルをオープンする
; DEVFNをコールした後にコールすること
; オープン可能なファイルは BTX, OBJ のみ
; IN :	無
; OUT:	無
; DES:	全
; Open the file to execute the load
; Call after calling DEVFN
; Openable files are BTX, OBJ only
; IN: None
; OUT: None
; DES: all
;
;
_LOPEN	EQU	2Fh

;----------------------------------------------------------------------------
; LOADF
; OBJ, BTXファイルをロードする
; DEVNMをコールした後でコールすること
; IN :	HL = ロードアドレス
; OUT:	無
; DES:	全
; Load OBJ, BTX file
; Call after calling DEVNM
; IN: HL = load address
; OUT: None
; DES: all
;
_LOADF	EQU	30h

;----------------------------------------------------------------------------
; SAVEF
; ファイルをセーブする
; DEVNMをコールした後でコールすること
; IN :	DE = セーブ開始アドレス
;	A  = 0    : ファイルの作成のみ・セーブしない
;	   = 0以外: ファイルを作成し、セーブする
;	MLMD20,21 = セーブする長さ
;	MLMD22,23 = ロードアドレス
;	MLMD24,25 = 実行アドレス
; OUT:	無
; DES:	全
; Save the file
; Call after calling DEVNM
; IN: DE = save start address
; A = 0: Create file only - Do not save
; = Other than 0: Create and save the file
; MLMD 20, 21 = length to save
; MLMD 22, 23 = load address
; MLMD 24, 25 = execution address
; OUT: None
; DES: all
;
_SAVEF	EQU	31h

;----------------------------------------------------------------------------
; RWOPN
; ファイルをオープンする
; DEVNMをコールした後でコールすること
; IN :	A = Logical Unit Number
;	D = 01h : Readオープン
;	  = 02h : Writeオープン
;	  = 04h : RANDOMファイルのオープン
;	  = 10h : APPENDオープン
;	E = field/32-1 (RANDOMファイルのオープンの場合のみ)
; OUT:	無 (RANDOMファイル以外)
;	RANDOMファイルの場合
;	  Zf = 1 : new file
;	     = 0 : file exist
; DES:	AF
; Open a file
; Call after calling DEVNM
; IN: A = Logical Unit Number
; D = 01 h: Read open
; = 02h: Write open
; = 04h: Opening the RANDOM file
; = 10h: APPEND open
; E = field / 32 - 1 (only for RANDOM file open)
; OUT: None (other than RANDOM file)
; For the RANDOM file
; Zf = 1: new file
; = 0: file exist
; DES: AF
;
_RWOPN	EQU	33h

;----------------------------------------------------------------------------
; BGETL
; 1行入力　現在のカーソル位置から入力する
; その他はGETLと同じ
; IN :	無
; OUT:	DE = バッファアドレス
; DES:	BC, HL以外
; Enter 1 line Enter from the current cursor position
;Others are same as GETL
; IN: None
; OUT: DE = buffer address
; DES: other than BC, HL
;
_BGETL	EQU	34h

;----------------------------------------------------------------------------
; INMSG
; ファイルから1行入力(0Dhまで) 末尾の0Dhは取り除かれる
; DEVNMをコールした後でコールすること
; IN :	DE = 入力バッファアドレス
; OUT:	B  = 長さ
;	Cy = 1 : EOF
; DES:	DE, HL以外
;  Enter 1 line from file 0Dh at the end is removed (up to 0Dh)
; Call after calling DEVNM
; IN: DE = input buffer address
; OUT: B = length
; Cy = 1: EOF
; DES: other than DE, HL
;
_INMSG	EQU	35h

;----------------------------------------------------------------------------
; UNPUT
; ファイルから読みだしたデータをファイルへ戻す
; 1バイトのみ可能
; IN :	A = 戻すデータ
; OUT:	無
; DES:	AF
; Return data read from file back to file
; Only 1 byte possible
; IN: A = return data
; OUT: None
; DES: AF
;
_UNPUT	EQU	36h

;----------------------------------------------------------------------------
; PRSTR
; ファイルにnバイトデータを出力
; IN :	DE = データアドレス
;	B  = データ長さ
; OUT:	無
; DES:	AF
; Output n bytes of data to file
; IN: DE = data address
; B = data length
; OUT: None
; DES: AF
;
_PRSTR	EQU	37h

;----------------------------------------------------------------------------
; CLKL
; ファイルのCLOSE/KILL
; IN :	A = 0    : 現在オープン中のすべてのファイルをclose/killする
;	  = 0以外: Aで指定されたLogical Unitのファイルをclose/killする
;	B = 0    : KILL
;	  = 0以外: CLOSE
; OUT:	無
; DES:	AF
; File CLOSE / KILL
; IN: A = 0: Close / kill all currently open files
; Other than 0: Close / kill the file of Logical Unit specified by A
; B = 0: KILL
; Other than 0: CLOSE
; OUT: None
; DES: AF
;
_CLKL	EQU	38h

;----------------------------------------------------------------------------
; DIR
; ディレクトリの内容をディレクトリバッファに読み込む・CRT/LPTに出力する
; DEVNMをコールした後でコールすること
; IN :	A = 0 : ディレクトリを1000h〜17FFhに読み出し、隠し文字の処理とソートを行う
;		DE = ファイル名 (隠し文字の*,?を含んでもよい)
;		B  = ファイル名の長さ
;	A = 0以外: Aで指定されたLogical Unitにディレクトリを出力する
;		88h : CRT
;		89h : LPT
; OUT:	無
; DES:	AF
; Read contents of directory into directory buffer · Output to CRT / LPT
; Call after calling DEVNM
; IN: A = 0: Read the directory from 1000h to 17FFh to process and sort hidden characters
; DE = file name (may include hidden *,?)
; B = length of file name
; A = other than 0: Output the directory to the Logical Unit specified by A
; 88h: CRT
; 89 h: LPT
; OUT: None
; DES: AF
;
_DIR	EQU	39h

;----------------------------------------------------------------------------
; CHDIR
; チェンジディレクトリ
; DEVNMをコールした後でコールすること
; IN :	無
; OUT:	無
; DES:	無
; Change directory
; Call after calling DEVNM
; IN: None
; OUT: None
; DES: none
;
_CHDIR	EQU	3Ah

;----------------------------------------------------------------------------
; FINIT
; BASICのinit commandに相当
; DEVNMをコールした後でコールすること
; IN :	無
; OUT:	無
; DES:	全
; Equivalent to BASIC's init command
; Call after calling DEVNM
; IN: None
; OUT: None
; DES: all
;
_FINIT	EQU	3Ch

;----------------------------------------------------------------------------
; DELET
; BASICのdelete/rmdir commandに相当
; DEVNMをコールした後でコールすること
; IN :	Cy = 0 : detele
;	   = 1 : rmdir
; OUT:	無
; DES:	AF
; Equivalent to BASIC delete / rmdir command
; Call after calling DEVNM
; IN: Cy = 0: detele
; = 1: rmdir
; OUT: None
; DES: AF
;
_DELET	EQU	3Dh

;----------------------------------------------------------------------------
; RENAM
; ファイル名を変更する
; DEVNMをコールした後でコールすること
; IN :	DE = 新しいファイル名のアドレス
;	B  = 新しいファイル名の長さ
; OUT:	無
; DES:	AF
; Change the file name
; Call after calling DEVNM
; IN: DE = address of the new file name
; B = length of new file name
; OUT: None
; DES: AF
;
_RENAM	EQU	3Eh

;----------------------------------------------------------------------------
; LOCK
; ファイルのプロテクト設定・解除・ステータス取得
; DEVNMをコールした後でコールすること
; IN :	A = 00h : プロテクト解除
;	  = 01h : ファイルをプロテクトする
;	  = FFh : ファイルのプロテクト状況を調べる
;		Cy = 1        : file not found
;		   = 0, A = 0 : unlocked
;		   = 0, A = 1 : locked
; OUT:	無
; DES:	AF
; Protect file setting / cancel · Status acquisition
; Call after calling DEVNM
; IN: A = 00h: Unprotect
; = 01h: Protect file
; = FFh: Check file protection status
; Cy = 1: file not found
; = 0, A = 0: unlocked
; = 0, A = 1: locked
; OUT: None
; DES: AF
;
_LOCK	EQU	3Fh

;----------------------------------------------------------------------------
; BRD
; ランダムファイルをアクセス
; IN :	A = 0 : 次にread/writeするレコード番号を設定する
;		この番号は、以下の A = 1〜4 のコールで使用する
;		この番号はオートインクリメントする
;		DE = record number
;	A = 1, DE = 0以外:
;		1レコード読み、DEの示すアドレスに格納する
;		Bに長さが入る
;		BASICのinput#()に相当
;	A = 1, DE = 0:
;		1レコード読み、field-bufferに格納する
;		BASICのget#に相当
;	A = 2, DE = 0以外:
;		DEからB typeをファイルに出力
;		BASICのprint#()に相当
;	A = 2, DE = 0:
;		field-bufferをファイルに出力する
;		BASICのput#に相当
;	A = 3:
;		field bufferからデータを取り出す
;		DE = 読み出しアドレス
;		B  = オフセット(fieldの何バイトめかを示す)
;		C  = 読み出す長さ
;		L  = ファイル番号
;	A = 4:
;		field bufferにデータをセットする
;		BASICのlset/rsetに相当
;		他の入力レジスタは A = 3 の場合と同様
;	A = 5:
;		fieldからデータをまとめて入力する
;		gload等で使用
;		HL = ロードアドレス
;		D  = read/writeするサイズ/256  1,2,4,8,16のいずれかを指定
;		E  = 0を指定
;		BC = ファイルの先頭からの位置(バイト単位) / 256
;		     この値はD reg.の倍数であること
;	A = 6:
;		fileへデータをまとめて出力する
;		gsaveなどで使用
;		他の入力レジスタは A = 5 の場合と同様
; DES:	全
; Accessing random files
; IN: A = 0: Set the record number to be read / written next
; This number is used for the following A = 1 to 4 calls
; This number will autoincrement
; DE = record number
; A = 1, except for DE = 0:
; 1 record read, stored in the address indicated by DE
; B has a length
; Equivalent to input # () of BASIC
; A = 1, DE = 0:
; 1 record read, stored in field-buffer
; Equivalent to get # of BASIC
; A = 2, except for DE = 0:
; Output B type from DE to file
;Equivalent to BASIC's print # ()
; A = 2, DE = 0:
; Output field-buffer to file
; Equivalent to BASIC put #
; A = 3:
; Retrieve data from field buffer
; DE = Read address
; B = offset (indicating the number of bytes in the field)
; C = length to read
; L = file number
; A = 4:
; Set data in field buffer
; Equivalent to lset / rset of BASIC
; The other input registers are the same as in the case of A = 3
; A = 5:
; Enter data from field collectively
; Used with gload etc.
; HL = load address
; D = size to read / write Size / 256 1, 2, 4, 8, 16 is specified
; Specify E = 0
; BC = position from the beginning of the file (in bytes) / 256
; This value must be a multiple of D reg.
; A = 6:
; Output data to file collectively
; Used with gsave etc.
; Other input registers are the same as for A = 5
; DES: all
;
_BRD	EQU	40h

;----------------------------------------------------------------------------
; FFUNC
; BASICのLOC/LOF/FPOSと同等の機能
; LUCHKをコールした後でコールすること
; IN :	A = 0 : BC = LOC
;	A = 1 : BC = LOF
;	A = 2 : BC = FPOS
;	A = 3 : BC = CRを出力した後に出力した文字数(ファイル)
;		     カーソルの現在の桁位置(CRT)
;		     プリンタのヘッド位置(LPT)
; OUT:	BC
; DES:	DE, HL以外
; Equivalent function to BASIC's LOC / LOF / FPOS
; Call after calling LUCHK
; IN: A = 0: BC = LOC
; A = 1: BC = LOF
; A = 2: BC = FPOS
; A = 3: Number of characters (file) output after outputting BC = CR
; Current position of the cursor (CRT)
; Printer head position (LPT)
; OUT: BC
; DES: other than DE, HL
;
_FFUNC	EQU	41h

;----------------------------------------------------------------------------
; DEFNC
; レコード単位でのファイルの入出力
; DEVNMをコールした後でコールすること
; IN :	A = 0 : フリーサイズを求める
;		Cy = 0 : DEにフリーサイズ(Kバイト)を出力
;		   = 1 : 実行しない
;	A = 1 : レコード単位の入力
;		HL = 読み出しアドレス
;		DE = バイトサイズ
;		BC = 読み出し開始ブロック番号
;	A = 1 : レコード単位の入力
;		HL = 書き込みデータのアドレス
;		DE = バイトサイズ
;		BC = 書き込み開始ブロック番号
; DES:	AF
; DEFNC
; Input and output of files in record units
; Call after calling DEVNM
; IN: A = 0: seek free size
; Cy = 0: Output free size (K bytes) to DE
; = 1: Do not execute
; A = 1: record unit input
; HL = Read address
; DE = byte size
; BC = Read start block number
; A = 1: record unit input
; HL = address of write data
; DE = byte size
; BC = write start block number
; DES: AF
;
_DFUNC	EQU	42h

_ERCVR	EQU	43h

;----------------------------------------------------------------------------
; SWAP
; テキスト・ファイルの交換・復帰を行う
; IN :	A = 0 : テキスト・ファイルの交換
;		DE = セーブするテキスト先頭アドレス
;		HL = セーブする長さ
;	A = FFh : テキスト・ファイルの復帰
; OUT:	無
; DES:	全
; Exchange and restore text files
; IN: A = 0: Text file exchange
; DE = Starting address of the text to be saved
; HL = length to save
; A = FFh: Restore text file
; OUT: None
; DES: all
;
_SWAP	EQU	44h

;----------------------------------------------------------------------------
; CLS
; グラフィック画面をバックカラーでクリアする
; IN :	A = バックカラー
; OUT:	無
; DES:	全
; Clear graphic screen with back color
; IN: A = Back color
; OUT: None
; DES: all
;
_CLS	EQU	45h

;----------------------------------------------------------------------------
; POSCK
; 指定座標がグラフィック画面上のビューポート内にあるかどうかをチェック
; IN :	(HL  ).w = X座標
;	(HL+2).w = Y座標
; OUT:	無 (範囲外のときはエラー)
; DES:	全
; Check if the specified coordinates are in the viewport on the graphic screen
; IN: (HL). W = X coordinate
; (HL + 2). W = Y coordinate
; OUT: None (Error when out of range)
; DES: all
;
_POSCK	EQU	46h

;----------------------------------------------------------------------------
; POSSV
; 座標セット/読み出し
; IN :	Cy = 0 : 座標セット
;		  (HL  ).w = X座標
;		  (HL+2).w = Y座標
;	Cy = 1 : 座標読み出し
; OUT:	DE = X座標
;	HL = Y座標
; DES:	全
; Coordinate set / read
; IN: Cy = 0: coordinate set
; (HL). W = X coordinate
; (HL + 2). W = Y coordinate
; Cy = 1: coordinate reading
; OUT: DE = X coordinate
; HL = Y coordinate
; DES: all
;
_POSSV	EQU	47h

;----------------------------------------------------------------------------
; PSET
; グラフィック画面上に点を描画
; IN :	(HL  )   = カラーコード
;	(HL+1)   = 描画機能
;	(HL+2).w = X座標
;	(HL+4).w = Y座標
; OUT:	無
; DES:	全
; Draw a point on the graphic screen
; IN: (HL) = color code
; (HL + 1) = drawing function
; (HL + 2). W = X coordinate
; (HL + 4). W = Y coordinate
; OUT: None
; DES: all
;
_PSET	EQU	48h

;----------------------------------------------------------------------------
; LINE
; グラフィック画面上に線を描画
; IN :	(HL  )   = カラーコード
;	(HL+1)   = 描画機能
;	(HL+2).w = 始点X座標
;	(HL+4).w = 始点Y座標
;	(HL+6).w = 終点X座標
;	(HL+8).w = 終点Y座標
;	(HL+10)  = ラインモード
;		    Bit0 = 0 : 実線
;			 = 1 : ラインスタイル
;		    Bit1 = 0 : 新しいラインスタイル
;			 = 1 : 前のラインスタイル
;	(HL+11).w = ラインスタイル
; OUT:	無
; DES:	全
; Draw a line on the graphic screen
; IN: (HL) = color code
; (HL + 1) = drawing function
; (HL + 2) .w = start point X coordinate
; (HL + 4). W = start point Y coordinate
; (HL + 6). W = end point X coordinate
; (HL + 8). W = End point Y coordinate
; (HL + 10) = line mode
; Bit 0 = 0: solid line
; = 1: Line style
; Bit 1 = 0: New line style
; = 1: previous line style
; (HL + 11) .w = Line style
; OUT: None
; DES: all
;
_LINE	EQU	49h

;----------------------------------------------------------------------------
; PATTR
; グラフィック画面上にパターンを描画
; IN :	(HL  )   = カラーコード
;	(HL+1)   = 描画機能
;	(HL+2)   = バックカラー
;	(HL+3)   = 文字列の長さ
;	(HL+4).w = 文字列のアドレス
;	(HL+6)   = 方向 0:上 1:下
;	(HL+7)   = 高さ
; OUT:	無
; DES:	全
; Drawing a pattern on the graphic screen
; IN: (HL) = color code
; (HL + 1) = drawing function
; (HL + 2) = back color
; (HL + 3) = length of string
; (HL + 4) .w = address of string
; (HL + 6) = direction 0: top 1: bottom
; (HL + 7) = height
; OUT: None
; DES: all
;
_PATTR	EQU	4Ah

;----------------------------------------------------------------------------
; LINE
; グラフィック画面上に長方形を描画
; IN :	(HL  )   = カラーコード
;	(HL+1)   = 描画機能
;	(HL+2).w = 始点X座標
;	(HL+4).w = 始点Y座標
;	(HL+6).w = 終点X座標
;	(HL+8).w = 終点Y座標
;	(HL+10)  = ラインモード
;		    0 : 実線で枠を描画
;		    1 : ラインスタイルで枠を描画
;		    2 : 長方形を指定色で塗りつぶす
;		    3 : 長方形をタイルパターンで塗りつぶす
;	(HL+11).w = ラインスタイルまたはタイルパターンアドレス
;	(HL+13)   = タイルパターンのバイト数
; OUT:	無
; DES:	全
; Draw a rectangle on the graphic screen
; IN: (HL) = color code
; (HL + 1) = drawing function
; (HL + 2) .w = start point X coordinate
; (HL + 4). W = start point Y coordinate
; (HL + 6). W = end point X coordinate
; (HL + 8). W = End point Y coordinate
; (HL + 10) = line mode
; 0: Draw a frame with a solid line
; 1: Draw frame with line style
; 2: Fill rectangle with specified color
; 3: Fill rectangle with tile pattern
; (HL + 11) .w = line style or tile pattern address
; (HL + 13) = Number of bytes in the tile pattern
; OUT: None
; DES: all
;
_BOX	EQU	4Bh

;----------------------------------------------------------------------------
; LINE
; グラフィック画面上の閉鎖領域内を塗りつぶす
; IN :	(HL  ).w = 開始X座標
;	(HL+2).w = 開始Y座標
;	(HL+4).w = 境界色アドレス
;	(HL+6)   = 境界色の数 FFhの場合はnotモード
;	(HL+7)   = 0 : 指定色による塗りつぶし		(HL+9) = カラー
;		 = 1 : タイルパターンによる塗りつぶし
;			(HL+8).w = タイルパターンアドレス
;			(HL+10)  = タイルパターンのバイト数
; OUT:	無
; DES:	全
; Fill the closed area on the graphic screen
; IN: (HL). W = start X coordinate
; (HL + 2). W = start Y coordinate
; (HL + 4) .w = boundary color address
; (HL + 6) = number of boundary colors FFh is not mode
; (HL + 7) = 0: fill with specified color (HL + 9) = color
; = 1: Fill with tile pattern
; (HL + 8). W = Tile pattern address
; (HL + 10) = number of bytes in the tile pattern
; OUT: None
; DES: all
;
_PAINT	EQU	4Ch

;----------------------------------------------------------------------------
; CIRCL
; グラフィック画面上に円を描画
; IN :	(HL  )   = カラーコード
;	(HL+1)   = 描画機能
;	(HL+2).w = 中心X座標
;	(HL+4).w = 中心Y座標
;	(HL+6).w = 半径
;	(HL+8)   = 弦描画フラグ
;		    Bit0 = 0 : 開始点と中心の間に弦を描かない
;			 = 1 : 開始点と中心の間に弦を描く
;		    Bit1 = 0 : 終点と中心の間に弦を描かない
;			 = 1 : 終点と中心の間に弦を描く
;	(HL+ 9).f = 開始角(単精度)
;	(HL+14).f = 終了角(単精度)
;	(HL+19).f = 比率(単精度)
; OUT:	無
; DES:	全
; Draw a circle on the graphic screen
; IN: (HL) = color code
; (HL + 1) = drawing function
; (HL + 2) .w = center X coordinate
; (HL + 4) .w = center Y coordinate
; (HL + 6). W = Radius
; (HL + 8) = string drawing flag
; Bit 0 = 0: Do not draw a string between the starting point and the center
; = 1: draw a string between the starting point and the center
; Bit 1 = 0: Do not draw a string between the end point and the center
; = 1: draw a string between the end point and the center
; (HL + 9). F = start angle (single precision)
; (HL + 14). F = End angle (single precision)
; (HL + 19). F = Ratio (single precision)
; OUT: None
; DES: all
;
;
_CIRCL	EQU	4Dh

_POINT	EQU	4Eh

_HCPY	EQU	4Fh

_DFKEY	EQU	50h

;----------------------------------------------------------------------------
; GINIT
; 画面モードの初期化を行う
; IN :	A[Bit5,4] = 00 : 4色モード
;		  = 01 : 16色モード
;		  = 1x : 256色モード
;	A[Bit6]   =  0 : 200ラインモード
;		  =  1 : 400ラインモード
;	A[Bit7]   =  0 : 320ドットモード
;		  =  1 : 640ドットモード
; OUT:	無
; DES:	全
; Initialize screen mode
; IN: A [Bit 5, 4] = 00: 4 color mode
; = 01: 16 color mode
; = 1x: 256 color mode
; A [Bit 6] = 0: 200 line mode
; = 1: 400 line mode
; A [Bit 7] = 0: 320 dot mode
; = 1: 640 dot mode
; OUT: None
; DES: all
;
_GINIT	EQU	51h

;----------------------------------------------------------------------------
; VIEW
; ビューポートの設定
; IN :	(HL) Bit0 = 0 : 消去を行わない
;		  = 1 : 消去を行う
;	     Bit1 = 0 : 枠を描画しない
;		  = 1 : 枠を描画する
;	(HL+1)        : 消去に使う色
;	(HL+2)	      : 枠の描画に使う色
;	(HL+3)	      : 枠の描画に使うfunction
;	(HL+4).w      : 左端の座標
;	(HL+6).w      : 上端の座標
;	(HL+8).w      : 右端の座標
;	(HL+10).w     : 下端の座標
;	Cy        = 0 : ビューポート設定
;		  = 1 : ビューポート初期化
; OUT:	無
; DES:	全
; Setting the viewport
; IN: (HL) Bit 0 = 0: Do not erase
; = 1: Perform erasure
; Bit 1 = 0: Do not draw frame
; = 1: Draw a frame
; (HL + 1): color used for erasing
; (HL + 2): color used to draw frame
; (HL + 3): function used to draw frame
; (HL + 4). W: Leftmost coordinate
; (HL + 6). W: coordinates of the top edge
; (HL + 8). W: Rightmost coordinate
; (HL + 10). W: coordinate at the bottom end
; Cy = 0: viewport setting
; = 1: viewport initialization
; OUT: None
; DES: all
;
_VIEW	EQU	52h

;----------------------------------------------------------------------------
; SCREN
; スクリーンモードの設定
; IN :	A = 0 : アクティブ画面の設定
;		L = アクティブ画面
;	A = 1 : 出力グラフィック画面の設定
;		L[Bit0] = 0 : 標準グラフィック画面を出力
;			= 1 : 拡張グラフィック画面を出力
;		L[Bit1] = 0 : 0,2面を出力しない
;			= 1 : 0,2面を出力する
;		L[Bit2] = 0 : 1,3面を出力しない
;			= 1 : 1,3面を出力する
;		※Bit1,2は320x200・16色モード時のみ有効
;	A = 2 : アクティブプレーンの設定
;		L = アクティブプレーン
;	A = 3 : 出力プレーンの設定
;		L = 第1出力プレーン
;		H = 第1出力プレーン
;	A = FFh : スクリーンモード初期化
;		アクティブ画面 = 第0グラフィック画面
;		出力グラフィック画面 = 標準1面
;		アクティブプレーン = 全プレーン
;		第1出力プレーン = 全プレーン
;		第2出力プレーン = 256色時のみ全プレーン
; OUT:	無
; DES:	全
; Setting Screen Mode
; IN: A = 0: Active screen setting
; L = active screen
; A = 1: Setting of output graphic screen
; L [Bit 0] = 0: Output standard graphics screen
; = 1: Output extended graphics screen
; L [Bit 1] = 0: 0, do not output 2 faces
; = 1: 0, Output 2 faces
; L [Bit 2] = 0: 1, 3 do not output
; = 1: 1, 3 surfaces are output
; * Bits 1 and 2 are valid only in 320 x 200 · 16 color mode
; A = 2: Active plane setting
; L = active plane
; A = 3: Setting of output plane
; L = first output plane
; H = first output plane
; A = FFh: Screen mode initialization
; Active screen = 0 th graphic screen
; Output graphic screen = standard 1 side
; Active plane = all planes
; First output plane = all planes
; 2nd output plane = 256 colors only when all planes
; OUT: None
; DES: all
;
_SCREN	EQU	53h

;----------------------------------------------------------------------------
; COLOR
; パレット設定
; IN :	A = 0 : 標準パレットの設定
;		Cy = 0 : パレット設定
;		  (HL  ) = データ組の数(n)
;		  (HL+1) = パレット番号
;		  (HL+2) = カラーコード
;		    :
;		  (HL+2n+1) = パレット番号
;		  (HL+2n+2) = カラーコード
;		Cy = 1 : 初期化
;	A = 1 : 4096色パレットの設定
;		Cy = 0 : パレット設定
;		  (HL  ) = データ組の数(n)
;		  (HL+1) = パレット番号
;		  (HL+2) = 緑の輝度
;		  (HL+3) = 赤の輝度
;		  (HL+4) = 青の輝度
;		    :
;		  (HL+4n+1) = パレット番号
;		  (HL+4n+2) = 緑の輝度
;		  (HL+4n+3) = 赤の輝度
;		  (HL+4n+4) = 青の輝度
;		Cy = 1 : 初期化
; OUT:	無
; DES:	全
; Palette setting
; IN: A = 0: Standard palette setting
; Cy = 0: Palette setting
; (HL) = number of data sets (n)
; (HL + 1) = pallet number
; (HL + 2) = color code
;;:
; (HL + 2n + 1) = pallet number
; (HL + 2n + 2) = color code
; Cy = 1: initialization
; A = 1: 4096 color palette setting
; Cy = 0: Palette setting
; (HL) = number of data sets (n)
; (HL + 1) = pallet number
; (HL + 2) = green brightness
; (HL + 3) = red brightness
; (HL + 4) = brightness of blue
;;:
; (HL + 4n + 1) = pallet number
; (HL + 4n + 2) = green brightness
; (HL + 4n + 3) = red brightness
; (HL + 4n + 4) = brightness of blue
; Cy = 1: initialization
; OUT: None
; DES: all
;
_COLOR	EQU	54h

;----------------------------------------------------------------------------
; SYMBL
; グラフィック画面に文字列を描画
; IN :	(HL  )   = カラーコード
;	(HL+1)   = 描画機能
;	(HL+2)   = 文字数
;	(HL+3).w = 文字列アドレス
;	(HL+5)   = 縦倍率
;	(HL+6)   = 横倍率
;	(HL+7)   = 角度コード
;		    0 : ノーマル
;		    1 :  90度左回転
;		    2 : 180度左回転
;		    3 : 270度左回転
;	(HL+8)   = フォントフラグ
;		    0 :  8x8
;		    1 : 16x8
; OUT:	無
; DES:	全
; Draw a character string on the graphic screen
; IN: (HL) = color code
; (HL + 1) = drawing function
; (HL + 2) = number of characters
; (HL + 3). W = character string address
; (HL + 5) = longitudinal magnification
; (HL + 6) = lateral magnification
; (HL + 7) = angle code
; 0: Normal
; 1: 90 degrees counterclockwise rotation
; 2: 180 degree counterclockwise rotation
; 3: 270 degrees counterclockwise rotation
; (HL + 8) = font flag
; 0: 8 x 8
; 1: 16 x 8
; OUT: None
; DES: all
;
_SYMBL	EQU	55h

_HVIEW	EQU	56h

_CREP	EQU	57h

_GPUT	EQU	58h

_GGET	EQU	59h

_PENSE	EQU	5Ah

_MOVE	EQU	5Bh

_PRI	EQU	5Ch

_CBLOC	EQU	5Dh

_CRTI	EQU	5Eh

_COCNV	EQU	5Fh

_HROLL	EQU	60h

_GRINI	EQU	63h

;----------------------------------------------------------------------------
; TINIT
; テキスト画面の初期化を行う
; IN :	Cy = 0 : 
;		A[Bit0]   = 0 : 80桁
;			  = 1 : 40桁
;		A[Bit2-1] = 00 : 25行
;			  = 01 : 20行
;			  = 10 : 12行
;		A[Bit3]   = 0 : 8x8ドットフォント使用
;			  = 1 : 16x8ドットフォント使用
;		A[Bit4]   = 0 : ライン・スクロール・モード
;			  = 1 : スムース・スクロール・モード
;	Cy = 1 : 
;		A = 0 :
;		  テキスト画面を8色モードで初期化する
;		  80桁のラインスクロールモードとなる
;		  400ラスタCRT時には25行・16x8ドットフォント
;		  200ラスタCRT時には12行・ 8x8ドットフォント
;		A = 0以外:
;		  テキスト画面を64色モードで初期化する
;		  40桁のラインスクロールモードとなる
;		  400ラスタCRT時には25行・16x8ドットフォント
;		  200ラスタCRT時には12行・ 8x8ドットフォント
; OUT:	無
; DES:	全
; Initialize the text screen
; IN: Cy = 0:
; A [Bit 0] = 0: 80 digits
; = 1: 40 digits
; A [Bit 2 - 1] = 00: 25 lines
; = 01: 20 rows
; = 10: 12 lines
; A [Bit 3] = 0: 8 x 8 dot font used
; = 1: use 16 x 8 dot font
; A [Bit 4] = 0: line scroll mode
; = 1: Smooth scroll mode
; Cy = 1:
; A = 0:
; Initialize text screen in 8 color mode
; 80-digit line scrolling mode is set
; 25 rows at 400 raster CRT · 16 x 8 dot font
; 12 lines at 200 raster CRT · 8 x 8 dot font
; A = other than 0:
; Initialize text screen in 64 color mode
; 40-digit line scrolling mode is set
; 25 rows at 400 raster CRT · 16 x 8 dot font
; 12 lines at 200 raster CRT · 8 x 8 dot font
; OUT: None
; DES: all
;
_TINIT	EQU	64h

;----------------------------------------------------------------------------
; MSGX
; CRTへ文字列を出力する　制御コードを実行しない
; IN :	DE = ASCIIZ文字列アドレス
; OUT:	無
; DES:	AF, IY
; Do not execute control code to output character string to CRT
; IN: DE = ASCIIZ character string address
; OUT: None
; DES: AF, IY
;
_MSGX	EQU	65h

;----------------------------------------------------------------------------
; TMOD
; テキスト画面のモード設定・変更
; IN :	C = 0 : 漢字モード/疑似グラフィックモードの切り替え
;		A = 0    : 疑似グラフィックモード
;		A = 0以外: 漢字モード
;	C = 1 : ファンクションキーリスト表示のON/OFF
;		A = 0 : 表示OFF
;		A = 1 : 表示ON
;		A = 2 : 表示ON + 時計
;	C = 2 : カーソル点滅ON/OFF
;		A = 0 : カーソル点滅OFF
;		A = 1 : カーソル点滅ON
;		A = 2 : キー入力待ち時のみカーソル点滅ON
;	C = 3 : スクロールモード
;		A = 0    : ロック
;		A = 0以外: アンロック
;	C = 4 :
;		A = 0    : 文字のバックは透明
;		A = 0以外: 文字のバックは黒
;	C = 5 :
;		A = 0    : モノクロ・ディスプレイの画面全体をノーマル表示
;		A = 0以外: モノクロ・ディスプレイの画面全体を反転表示
;	C = 6 : バックグラウンドカラー設定
;		CyをBit8, AをBit7-0として設定する
;	C = 7 :
;		A = 0    : モノクロ・ディスプレイにグラフィック画面を重ねる
;		A = 0以外: モノクロ・ディスプレイにグラフィック画面を重ねない
; OUT:	無
; DES:	全
; TMOD
; Set / change mode of text screen
; IN: C = 0: Switch between kanji mode / pseudo graphic mode
; A = 0: pseudo graphic mode
; A = other than 0: Kanji mode
; C = 1: ON / OFF of function key list display
; A = 0: Display OFF
; A = 1: Display ON
; A = 2: Display ON + clock
; C = 2: Cursor blinking ON / OFF
; A = 0: Cursor blinking OFF
; A = 1: Cursor flashing ON
; A = 2: Cursor blinks ON only when waiting for key input
; C = 3: scroll mode
; A = 0: Lock
; A = other than 0: Unlock
; C = 4:
; A = 0: character back is transparent
; A = other than 0: character back is black
; C = 5:
; A = 0: Monochrome · Normal display of the entire screen of the display
; A = other than 0: Monochrome · Highlight the entire screen of the display
; C = 6: background color setting
; Set Cy as Bit 8 and A as Bit 7 - 0
; C = 7:
; A = 0: overlay graphic screen on monochrome display
; A = Other than 0: Monochrome · Do not overlay graphic screen on display
; OUT: None
; DES: all
;
_TMOD	EQU	66h

;----------------------------------------------------------------------------
; GPCG
; 指定された文字コード/PCGセレクト番号に対応する文字のフォントパターンを
; DEで示すバッファに格納する
; IN :	DE = 文字コード
;	B  = PCGセレクト番号(0-3)
;	┌──────┬─┬───────────┬────┐
;	│DE          │B │対象                  │バイト数│
;       ├──────┼─┼───────────┼────┤
;       │   0 - FF   │ 0│PCG0   (8x8ドット)    │    8   │
;       │            │ 1│PCG1   (8x8ドット)    │    8   │
;       │            │ 2│PCG2   (8x8ドット)    │    8   │
;       │            │ 3│PCG3   (8x8ドット)    │    8   │
;       │            │他│PCG1-3 (8x8ドット)    │   24   │
;       ├──────┼─┼───────────┼────┤
;       │ 100 - 1FE  │ 0│PCG0   (16x8ドット)   │   16   │
;       │  (偶数のみ)│ 1│PCG1   (16x8ドット)   │   16   │
;       │            │ 2│PCG2   (16x8ドット)   │   16   │
;       │            │ 3│PCG3   (16x8ドット)   │   16   │
;       │            │他│PCG1-3 (16x8ドット)   │   48   │
;       ├──────┼─┼───────────┼────┤
;       │ 200 - 2FF  │−│ANK ROMCG (8x8ドット) │    8   │
;       ├──────┼─┼───────────┼────┤
;       │ 300 - 3FF  │−│ANK ROMCG (16x8ドット)│   16   │
;       ├──────┼─┼───────────┼────┤
;       │8140 - EA9E │−│漢字 ROMCG            │   32   │
;       │(SHIFT JIS) │  │(16x16ドット)         │        │
;       ├──────┼─┼───────────┼────┤
;       │EC9F - ECFC │−│外字                  │   32   │
;       │ED40 - ED7E │  │(16x16ドット)         │        │
;       │ED80 - EDA2 │  │                      │        │
;       │(SHIFT JIS) │  │                      │        │
;       └──────┴─┴───────────┴────┘
; OUT:	DE = バッファアドレス
; DES:	全
; The font pattern of the character corresponding to the specified character code / PCG select number
; Store in buffer indicated by DE
; IN: DE = character code
; B = PCG select number (0 - 3)
; ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
; │DE │ B │ target │ byte number │
; ├──────────────────────────────────────────
; │ 0 - FF │ 0 │ PCG 0 (8 × 8 dots) │ 8 │
; │ │ 1 | PCG 1 (8 × 8 dots) │ 8 │
; │ │ 2 | PCG 2 (8 × 8 dots) │ 8 │
; │ │ 3 | PCG 3 (8 × 8 dots) │ 8 │
; │ │ other │ PCG 1 - 3 (8 × 8 dots) │ 24 │
; ├──────────────────────────────────────────
; │ 100 - 1 FE │ 0 │ PCG 0 (16 × 8 dots) │ 16 │
; │ (even number only) │ 1 | PCG 1 (16 × 8 dots) │ 16 │
; │ │ 2 | PCG 2 (16 × 8 dots) │ 16 │
; │ │ 3 | PCG 3 (16 × 8 dots) │ 16 │
; │ │ other │ PCG 1 - 3 (16 × 8 dots) │ 48 │
; ├──────────────────────────────────────────
; │ 200 - 2 FF │ - │ANK ROMCG (8 × 8 dots) │ 8 │
; ├──────────────────────────────────────────
; │ 300 - 3 FF │ - │ANK ROMCG (16 × 8 dots) │ 16 │
; ├──────────────────────────────────────────
; │ 8140 - EA 9 E │ - │ Chinese character ROMCG │ 32 │
; │ (SHIFT JIS) │ │ (16 × 16 dots) │ │
; ├──────────────────────────────────────────
; │EC9F - ECFC │ - │ external character │ 32 │
; │ED 40 - ED 7 E │ │ (16 × 16 dots) │ │
; │ED80 - EDA2 │ │ │ │
; │ (SHIFT JIS) │ │ │ │
; └ ─ ─ ─ ─ ─ ─ ______________________________________
; OUT: DE = buffer address
; DES: all
;
_GPCG	EQU	67h

;----------------------------------------------------------------------------
; SPCG
; 指定された文字コード/PCGセレクト番号に対応する外字・PCGに対して
; パターンを設定する
; IN :	DE = 文字コード
;	B  = PCGセレクト番号(0-3)
;	DIRARE(1000h-) = パターン
; OUT:	無
; DES:	全
; For external characters and PCG corresponding to the designated character code / PCG select number
; Set the pattern
; IN: DE = character code
; B = PCG select number (0 - 3)
; DIRARE (1000 h -) = pattern
; OUT: None
; DES: all
;
_SPCG	EQU	68h

;----------------------------------------------------------------------------
; TGET
; テキスト画面からデータを読み出す
; IN :	L = X座標
;	H = Y座標
;	C = バイト数
; OUT:	C  = 取得バイト数
;	DE = バッファアドレス
; DES:	全
; Read data from text screen
; IN: L = X coordinate
; H = Y coordinate
; C = number of bytes
; OUT: C = number of bytes acquired
; DE = buffer address
; DES: all
;
_TGET	EQU	69h

;----------------------------------------------------------------------------
; TSCRN
; テキストの入出力画面の設定変更を行う
; IN :	A[Bit1,0] = 00 : アクティブ画面を変更しない
;		  = 01 : テキスト画面1をアクティブ画面にする
;		  = 10 : テキスト画面2をアクティブ画面にする
;	A[Bit3,2] = 00 : テキスト表示画面の設定を変更しない
;		  = 01 : 第1面のみ出力
;		  = 10 : 第2面のみ出力
;		  = 11 : 第1面・第2面重ね合わせ(第1面優先)
; OUT:	無
; DES:	全
; Change the setting of the text input / output screen
; IN: A [Bit 1, 0] = 00: Do not change active screen
; = 01: Make text screen 1 the active screen
; = 10: Make text screen 2 the active screen
; A [Bit 3, 2] = 00: Do not change the setting on the text display screen
; = 01: Output only on the first side
; = 10: Output only on the second side
; = 11: First side / second side overlapping (first side first)
; OUT: None
; DES: all
;
_TSCRN	EQU	6Ah

;----------------------------------------------------------------------------
; TATR
; 表示中の文字の属性を変更する
; IN :	C = 0 : 文字の色属性を変更
;		A = --GRBGRB (Bit5-3は64色モード時のみ有効)
;	C = 1 : 文字のブリンク属性を変更
;		A = 0    : ノーマル
;		  = 0以外: ブリンク
;	C = 2 : 文字のリバース属性を変更
;		A = 0    : ノーマル
;		  = 0以外: リバース
;	L = 開始X座標
;	H = 開始Y座標
;	E = X方向の長さ
;	D = Y方向の長さ
; OUT:	無
; DES:	全
; Change the attribute of the displayed character
; IN: C = 0: Change color attribute of character
; A = - GRBGRB (Bit 5 - 3 is valid only in 64 color mode)
; C = 1: Change blink attribute of character
; A = 0: Normal
; = Other than 0: Blink
; C = 2: Change reverse attribute of character
; A = 0: Normal
; Other than 0: Reverse
; L = start X coordinate
; H = start Y coordinate
; E = length in X direction
; D = length in Y direction
; OUT: None
; DES: all
;
_TATR	EQU	6Bh

;----------------------------------------------------------------------------
; TWID
; テキスト画面の桁数・行数変更
; IN :	A[Bit0]   =  0 : 80桁
;		  =  1 : 40桁
;	A[Bit2,1] = 00 : 25行
;		  = 01 : 20行
;		  = 10 : 12行
; OUT:	無
; DES:	全
; Change the number of columns and the number of lines on the text screen
; IN: A [Bit 0] = 0: 80 digits
; = 1: 40 digits
; A [Bit 2, 1] = 00: 25 lines
; = 01: 20 rows
; = 10: 12 lines
; OUT: None
; DES: all
;
_TWID	EQU	6Ch

;----------------------------------------------------------------------------
; TWARE
; テキスト画面のスクロールエリアを設定
; IN :	L = 開始X座標 (0-79/0-39)
;	H = 開始Y座標 (0-24/0-19/0-11)
;	E = X方向の長さ (1-80/1-40)
;	D = Y方向の長さ (1-25/1-20/1-12)
; OUT:	無
; DES:	全
; Set scroll area of ​​text screen
; IN: L = start X coordinate (0 - 79/0 - 39)
; H = start Y coordinate (0 - 24/0 - 19/0 - 11)
; E = length in X direction (1-80 / 1-40)
; D = length in Y direction (1-25 / 1-20 / 1-12)
; OUT: None
; DES: all
;
_TWARE	EQU	6Dh

;----------------------------------------------------------------------------
; TDARE
; テキスト画面の物理的表示領域を設定
; IN :	L = 開始X座標 (0-79/0-39)
;	H = 開始Y座標 (0-199)
;	E = X方向の長さ (0-80/0-40)
;	D = Y方向の長さ (0-200)
; OUT:	無
; DES:	全
; Set the physical display area of ​​the text screen
; IN: L = start X coordinate (0 - 79/0 - 39)
; H = start Y coordinate (0-199)
; E = length in X direction (0 - 80/0 - 40)
; D = length in Y direction (0-200)
; OUT: None
; DES: all
;
_TDARE	EQU	6Eh

;----------------------------------------------------------------------------
; CMOV
; カーソル移動
; IN :	L = X座標
;	H = Y座標
; OUT:	無
; DES:	全
; Cursor movement
; IN: L = X coordinate
; H = Y coordinate
; OUT: None
; DES: all
;
_CMOV	EQU	6Fh

;----------------------------------------------------------------------------
; TCLR
; テキスト画面のクリア
; IN :	A[Bit1,0] = 00 : テキスト画面全体をクリア
;		  = 01 : アクティブ画面の文字スクロールエリア内をクリア
;		  = 10 : アクティブ画面の文字スクロールエリア内の指定領域をクリア
;		  = 11 : アクティブ画面の指定領域をクリア
;	A[Bit7]   =  0 : 画面クリア後、カーソルをスクロールエリアの左上に移動
;		  =  1 : 画面クリア後、カーソル位置を変えない
;	L = 開始X座標 (0-79/0-39)
;	H = 開始Y座標 (0-24/0-19)
;	E = X方向の長さ (1-80/1-40)
;	D = Y方向の長さ (1-25/1-20)
; OUT:	無
; DES:	全
; Clear text screen
; IN: A [Bit 1, 0] = 00: Clear the entire text screen
; = 01: Clear the character scroll area of ​​the active screen
; = 10: Clear specified area in character scroll area of ​​active screen
; = 11: Clear specified area of ​​active screen
; A [Bit 7] = 0: After clearing the screen, move the cursor to the upper left of the scroll area
; = 1: Do not change the cursor position after clearing the screen
; L = start X coordinate (0 - 79/0 - 39)
; H = start Y coordinate (0 - 24/0 - 19)
; E = length in X direction (1-80 / 1-40)
; D = length in Y direction (1 - 25/1 - 20)
; OUT: None
; DES: all
;
_TCLR	EQU	70h

;----------------------------------------------------------------------------
; TSCRL
; テキスト画面の文字スクロールエリアをスクロールする
; IN :	A = 0    : 上方向にスクロール
;	  = 0以外: 下方向にスクロール
; OUT:	無
; DES:	全
; Scroll the character scroll area of ​​the text screen
; IN: A = 0: Scroll upward
; = Other than 0: Scroll down
; OUT: None
; DES: all
;
;
_TSCRL	EQU	71h

;----------------------------------------------------------------------------
; CRPUT
; メモリに格納されているテキストデータを指定された矩形領域に表示
; IN :	HL = (略)
; OUT:	無
; DES:	全
; Display text data stored in memory in specified rectangular area
; IN: HL = (short)
; OUT: None
; DES: all
;
;
_CRPUT	EQU	72h

;----------------------------------------------------------------------------
; CRGET
; 指定された矩形領域のテキストデータをメモリに格納
; IN :	HL = (略)
; OUT:	無
; DES:	全
; Store text data of the specified rectangular area in memory
; IN: HL = (short)
; OUT: None
; DES: all
;
;
_CRGET	EQU	73h

;----------------------------------------------------------------------------
; SETCG
; CGROMのフォントパターンをPCG0にロードする
; IN :	A = 0    : MZ-2500用CGフォント(8x8ドット)
;	  = 0以外: MZ-2000/80B用CGフォント
; OUT:	無
; DES:	全
; Load font pattern of CGROM into PCG0
; IN: A = 0: CG font for MZ - 2500 (8 x 8 dots)
; Other than 0: CG font for MZ-2000 / 80B
; OUT: None
; DES: all
;
_SETCG	EQU	74h

;----------------------------------------------------------------------------
; ?TEXT
; 指定座標の文字種類を返す
; IN :	L = X座標
;	H = Y座標
; OUT:	Cy = 0 : ANK/PCG
;	   = 1 : 漢字
;		   Zf = 1 : 漢字左
;		      = 0 : 漢字右
; DES:	全
; Returns the character type of the specified coordinates
; IN: L = X coordinate
; H = Y coordinate
; OUT: Cy = 0: ANK / PCG
; = 1: Chinese character
; Zf = 1: Kanji left
; = 0: Right of Kanji
; DES: all
;
_QTEXT	EQU	75h

;----------------------------------------------------------------------------
; CURBL
; タイマ割り込みによるカーソル点滅制御　※ユーザー使用不可
; IN :	A = 0 : カーソル位置の文字/カーソル パターンを反転
;	  = 1 : カーソル点滅をEnable
;	  = 2 : カーソル点滅をDisable
;	  = 3 : カーソル点滅モードにより、カーソル点滅Enable/Disable
; OUT:	無
; DES:	全
; Cursor blink control by timer interrupt * User unavailable
; IN: A = 0: Character at cursor position / Invert cursor pattern
; = 1: Enable cursor blinking
; = 2: Disable cursor blinking
; = 3: Cursor flashing depending on the cursor flashing mode Enable / Disable
; OUT: None
; DES: all
;
_CURBL	EQU	76h

;----------------------------------------------------------------------------
; TSUB
; テキスト画面コントロール　※ユーザー使用不可
; IN :	C = 0 : 最下行のコントロール
;		B = 00h : ファンクションキーリスト表示
;		  = FEh : 時刻表示の更新
;		  = FFh : ファンクションキーリスト消去
;		  = 他  : ファンクションキーリスト表示(SHIFT)
;	C = 1 : カーソル位置の1文字Del
;	C = 2 : 指定位置の文字パターン取得
;		L = X座標
;		H = Y座標
;		DE = バッファアドレス
;	C = 3 : 行接続コントロール
;		B = 00h : カーソル行と次の行を論理的に切り離す
;		  = 01h : カーソル行と次の行を論理的に接続する
;		  = FFh : カーソル行の行接続状態を返す
; OUT:	C = 2 : C = パターンバイト数
;	C = 3 : A = 0    : 切り離されている
;		  = 0以外: 接続している
; DES:	全
; Text screen control * User unavailable
; IN: C = 0: bottom row control
; B = 00h: Function key list display
; = FEh: Update time display
; = FFh: Clear function key list
; = Other: Function key list display (SHIFT)
; C = 1: One character at the cursor position Del
; C = 2: Character pattern acquisition at specified position
; L = X coordinate
; H = Y coordinate
; DE = buffer address
; C = 3: Line connection control
; B = 00h: Logically separate the cursor line from the next line
; = 01h: Logically connect the cursor line to the next line
; = FFh: Returns the line connection status of the cursor line
; OUT: C = 2: C = number of pattern bytes
; C = 3: A = 0: detached
; = Other than 0: connected
;
_TSUB	EQU	77h

_RS232	EQU	78h

_RTC	EQU	79h

_MOUSE	EQU	7Ah

_IOSUB	EQU	7Bh

_DVCAL	EQU	7Ch

_FDRES	EQU	7Dh

_CMT	EQU	7Eh

_VOICE	EQU	7Fh

