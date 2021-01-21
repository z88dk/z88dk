; 
; Disk bootstrap for the pc88
;

	SECTION	BOOTSTRAP
	EXTERN	__DATA_END_tail

	; The code is loaded to $c000 by default, we copy up
	org	$f000
	
	di
	ld	hl,$c000
	ld	de,$f000
	ld	bc,512
	ldir
	jp	entry
entry:
	ld	hl,CRT_ORG_CODE
	ld	b, +((__DATA_END_tail - CRT_ORG_CODE) / 256) + 1
	ld	c,0
	ld	de,2		;Start sector 2, track 0
	call	DISK_Load
	jp	CRT_ORG_CODE


; hl = address
; b = number of sectors
; c = drive
; d = start track
; e = start sectors

;ディスクからデータをロード
; HL: ロードするアドレス
;  B: セクタ数 C: ドライブ D: トラック E: セクタ
DISK_Load:
	ld			a,$02					;コマンド 2 Read Data
	call		DISK_SdCmd
	ld			a,b						;セクタ数　1<=sec(s)<=16
	cp			17
	jr			c,load2
	ld			a,17					;16を超える場合は 17-StartSector だけ読んで次トラックへ
	sub			e
load2:
	call		DISK_SdData1
	ld			a,c						;ドライブ
	call		DISK_SdData1
	ld			a,d						;トラック
	call		DISK_SdData1
	ld			a,e						;セクタ
	call		DISK_SdData1

	ld			a,$12					;コマンド 18 Fast Send Data
	call		DISK_SdCmd

loop1:
	push		bc
	ld			b,128					; 128 * 2bytes  受信
loop2:
	call		DISK_RdData2
	djnz		loop2					; セクタ内ループ

	inc			e
	ld			a,e
	cp			17						; 17に到達->次のトラックへ移行
	jr			z,next
	pop			bc
	djnz		loop1					; セクタ数分ループ
	ret

;次のトラックへ
next:
	inc			d						;次のトラックから
	ld			e,1						;セクタは1から
	pop			bc
	dec			b
	jr			nz,DISK_Load
	ret

; サブシステムにコマンド送信
; a=コマンド番号
DISK_SdCmd:
	push		af
	ld			a,%00001111				;Attention=1
	out			($FF),a
wait1:
	in			a,($FE)
	bit			1,a						;Ready for Data?
	jr			z,wait1

	ld			a,%00001110				;Attention=0
	out			($FF),a
	jr			DISK_SdData1sub

;1バイト送信
DISK_SdData1:
	push		af
wait1_1:
	in			a,($FE)
	bit			1,a						;Ready for Data
	jr			z,wait1_1

DISK_SdData1sub:
	pop			af
	out			($FD),a					;コマンド

	ld			a,%00001001				;Data Valid
	out			($FF),a
wait2:
	in			a,($FE)
	bit			2,a						;Data Accepted?
	jr			z,wait2

	ld			a,%00001000				;Data Valid
	out			($FF),a
wait3:
	in			a,($FE)
	bit			2,a						;Data Accepted?
	jr			nz,wait3
	ret


;2バイト受信
DISK_RdData2:
	ld			a,%00001011				;Ready for Data
	out			($FF),a
wait1_3:
	in			a,($FE)
	rrca								;Data Valid?
	jr			nc,wait1_3

	ld			a,%00001010				;Ready for Data=0
	out			($FF),a

	in			a,($FC)					;データ受信
	ld			(hl),a
	inc			hl
	ld			a,%00001101				;Data Valid=1
	out			($FF),a
wait2_1:
	in			a,($FE)
	rrca
	jr			c,wait2_1

	in			a,($FC)
	ld			(hl),a
	inc			hl
	ld			a,%00001100				;Data Accepted
	out			($FF),a
	ret
