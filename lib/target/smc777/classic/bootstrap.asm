	;
	; SMC-777のIPL
	;
	; テキストに起動メッセージを表示して、フロッピーディスクのtrack1, sector1からtrack14までを$1000に読み込み、
	; $2000にJumpする
	;
	; MEMO:SMC-777のBIOSは起動時にフロッピーのtrack0/sector1の256Byteを
	; $0000に読み込みJumpするので、最初のプログラムは256バイト以内に収めること
	;
	; Taken from: https://github.com/moriyan6001/smc-777_ipl/blob/master/smc-777_ipl.z80


	SECTION BOOTSTRAP
	EXTERN  __DATA_END_tail

	ORG	$0000

restart:
	di
	im	1
	ld	sp,$0000

	call	setup

	; ここからディスク読み込み処理
	; FDCはMB8877A
	; 1track = 4096byte

	XOR	A		; Drive Select 0
	OUT	(034H),A	;

	CALL	disc_ckready		; NOT READY & BUSY Check

;	LD	A,0FH		; COMMAND: Disk RESTORE(track0にヘッドを移動)
;	CALL	Z0002		; SONY FILERだとこれを実行してる

	LD	DE,CRT_ORG_CODE ; 読み込み先アドレス
	LD	BC,0101H	; Track 1, Sector 1から読み込み
readloop:
	push	bc

	LD	A,B		; track指定
	OUT	(033H),A	; Track Reg

	CALL	disc_ckready	; NOT READY & BUSY Check

	LD	A,01FH		; COMMAND:Disk SEEK(指定トラックまで移動)
	CALL	Z0002		;

	IN	A,(030H)	; ステータスレジスタ
	AND	091H		; 1001_0001(NOT READY & SEEK ERROR & BUSY)
	JR	NZ,restart	; Retry

	PUSH	BC
	CALL	Z0003		; Disk Read Sub.
	POP	BC
	JR	Z,restart	; Retry

	pop	bc
	inc	b		; track++
	ld	a,b
	cp	+((__DATA_END_tail - CRT_ORG_CODE) / 4096) + 2	; Round up to 4k
	jr	nz,readloop

	; MAIN START
	JP	CRT_ORG_CODE

	;-----------------------
	; disk read sub
	; Creg... sector番号
Z0003:	LD	A,C		; セクタ指定
	OUT	(032H),A	; Sector Reg

	LD	A,092H		; Read Data Command(マルチレコードモード)
	CALL	Z0005		; Disk READ

	IN	A,(030H)	; ステータスレジスタ
	AND	010H		; 0001_0000(RECORD NOT FOUND)
	RET
	;-----------------------

	;-----------------------
	; NOT READY & BUSY Check
disc_ckready:	
        IN	A,(030H)	; ステータスレジスタ
	AND	081H		; 1000_0001(NOT READY & BUSY)
	JR	NZ,disc_ckready
	RET
	;-----------------------

	;-----------------------
	; disk command送出
Z0002:	OUT	(030H),A	; Disk Command
	NOP			; wait
Z0006:	IN	A,(034H)	; IRQ/DRQ STATUS
	RLCA
	JR	NC,Z0006	;
	RET
	;-----------------------

	;-----------------------
	; disk read Sub
	; IN:Areg...Command
	; IN:DE...読み込み先アドレス

Z0005:	LD	C,034H		; IRQ / DRQレジスタ
	OUT	(030H),A	; Command
	NOP			; Wait

Z0008:	IN	B,(C)		; IRQ / DRQレジスタ
	JR	Z,Z0007		; IRQフラグチェック
	RET	M		; コマンドの実行終了 -> RET
	IN	B,(C)		; IRQ / DRQレジスタ
	JP	NZ,Z0008	; データ待ちループ

Z0007:	IN	A,(033H)	; Disk Data
	LD	(DE),A		; 読み込んだデータをメモリへ
	INC	DE		;
	IN	B,(C)		; IRQ / DRQレジスタ
	JP	NZ,Z0008

	JR	Z0007

setup:
	; cursor off
	ld	a,10
	out	($18),a
	ld	a,$20
	out	($19),a

	; TEXT VRAMに起動メッセージを書き込む
	LD	HL,IPLBOOTMSG
	; TEXT VRAM [1,0]の位置に該当する
	; BCregのBregとCregが入れ替わってVRAMに接続されている
	; 40x25モードのPAGE0は偶数アドレス単位で指定する
	LD	BC,$0000
BOOT1:	LD	A,(HL)
	OUT	(C),A
	INC	HL
	INC	B
	INC	B
	OR	A
	JR	NZ,BOOT1

	ret

	;------------------------
	; DATA
	;------------------------

IPLBOOTMSG:
	defm	"SMC-777 z88dk Bootstrap via @moriyan6001"
	defb	0

