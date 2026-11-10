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
	JR	NZ,restart	; Retry

	pop	bc
	inc	b		; track++
	ld	a,b
	cp	+((__DATA_END_tail - CRT_ORG_CODE) / 4096) + 2	; Round up to 4k
	jr	nz,readloop

	; MAIN START
	JP	CRT_ORG_CODE

	;-----------------------
	; disk read sub
	; Reads the 16 sectors of the track (4096 bytes) to DE with one multiple record command.
	; The controller would then look for sector 17 for five turns of the disk (a second) before it stopped:
	; the command is stopped (Force Interrupt) once the last byte is in, and its status is looked at first.
	; Out: Z if the track was read
Z0003:	LD	A,C		; セクタ指定
	OUT	(032H),A	; Sector Reg

	LD	A,D
	ADD	A,010H
	LD	H,A
	LD	L,E		; HL: where DE is when the 4096 bytes are in
	LD	A,092H		; Read Data Command(マルチレコードモード)
	JR	Z0005		; Disk READ
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
	; IN:HL...DE after the last byte

Z0005:	LD	C,034H		; IRQ / DRQレジスタ
	OUT	(030H),A	; Command
	NOP			; Wait

Z0008:	IN	B,(C)		; IRQ / DRQレジスタ
	JR	Z,Z0007		; DRQ
	JP	M,Z000E		; IRQフラグ: the command ended before the track was in
	IN	B,(C)		; IRQ / DRQレジスタ
	JP	NZ,Z0008	; データ待ちループ

Z0007:	IN	A,(033H)	; Disk Data
	LD	(DE),A		; 読み込んだデータをメモリへ
	INC	DE		;
	LD	A,D
	CP	H
	JR	NZ,Z000F
	LD	A,E
	CP	L
	JR	Z,Z0009		; the last byte
Z000F:	IN	B,(C)		; IRQ / DRQレジスタ
	JP	NZ,Z0008

	JR	Z0007

Z0009:	LD	B,40		; the controller checks the sector's CRC
Z000A:	DJNZ	Z000A
	IN	A,(030H)
	AND	01CH		; lost data, CRC error, record not found
	LD	B,A
	LD	A,0D0H		; Force Interrupt
	OUT	(030H),A
Z000B:	IN	A,(030H)
	RRCA
	JR	C,Z000B		; until it is idle
	LD	A,B
	OR	A		; Z: a good track
	RET

Z000E:	OR	1		; NZ: not the whole track
	RET
	;-----------------------

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

