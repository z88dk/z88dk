        SECTION code_clib
	PUBLIC	fill
   PUBLIC   _fill
	EXTERN	w_pixeladdress
	EXTERN swapgfxbk
	EXTERN swapgfxbk1

	EXTERN	l_cmp

	INCLUDE "graphics/grafix.inc"

;.sline 	defs 320 * 2 * 3
;.sline2	defs 320 * 2 * 3

.fill
._fill
		pop bc
		pop de  ; y
		pop hl  ; x
		push hl
		push de
		push bc
		
;		xor a
;		or d
;		ret nz	; ret if y>255
		
		
;		push    de
;		ld      de,maxx
;		call    l_cmp
;		pop     de
;		ret c	; ret if x>320

        ld      (curx),hl
        ld      (cury),de
		call w_pixeladdress
		ld b,a
		ld a,1
		jr z,cont; pixel is at bit 0...
.loop3
		rrca		; rightmost pixel is the more significant bit
		djnz loop3
.cont

;		ld hl,sline

        ld      hl,-maxx * 2 * 3    ; create buffer 2 on stack
        add     hl,sp               ; The stack size depends on the display height.
        ld      (sl2ptr+1),hl       ; We don't undersize it because we have lots of RAM
        ld      sp,hl

        ld      hl,-maxx * 2 * 3	; create buffer 1 on stack
        add     hl,sp
        ld      sp,hl
		ld      (w_sline+3),hl

		ld (ws1),hl
		ld b,a
		set 2,c ; semafor = 1
		res 3,c ; indeks_ws = 0
		call segm

.petelka
		bit 3,c; indeks_ws1 == 0
		jr nz,noret
		
		ld      hl,maxx * 2 * 3 * 2
		add     hl,sp
		ld		sp,hl
		ret

.noret
		res 3,c; indeks_ws1 = 0
.dalej2
		push hl
		pop ix; W = ws1
		ld hl,(ws1)
		ld (index),hl
		bit 2,c
		jr z,w_sline
		res 2,c
.sl2ptr
;		ld hl,sline2
		ld hl,0
		ld (ws1),hl
		jr inner_loop
.w_sline
		set 2,c
		;ld hl,sline
		ld hl,0
		ld (ws1),hl

.inner_loop
		ld a,(index)
		cp ixl
		jr nz,dalej
		ld a,(index+1)
		cp ixh
		jr z,petelka
.dalej
		dec ix
		ld d,(ix+0)
		dec ix
		ld e,(ix+0)
		dec ix
		ld b,(ix+0)
		call segm
		jr inner_loop

.write
		ld (hl),b
		inc hl
		ld (hl),e
		inc hl
		ld (hl),d
		inc hl
		set 3,c
		ret

.test_up_down
		call swapgfxbk
		ld a,(de)
		or b
		ld (de),a ; plot(x,y)
		call swapgfxbk1
		push de
		call decy
		jr c, down
		call swapgfxbk
		ld a,(de)
		call swapgfxbk1
		and b ; point(x, y - 1)
		jr z, test_write
		set 0,c
		jr down

.test_write
		bit 0,c; if (is_above) {
		jr z,down
		res 0,c  ; is_above = 0;
		call write

.down
		pop de
		push de
		call incy
		jr c,wypad

		call swapgfxbk
		ld a,(de)
		call swapgfxbk1
		and b ; point(x, y + 1)
		jr z, test_write2
		set 1,c
		jr wypad

.test_write2
		bit 1,c; if (is_below) {
		jr z,wypad
		res 1,c  ; is_below = 0;
		call write
.wypad
		pop de
		ret


.segm
; de - address
; b - mask of the pixel
		set 0,c
		set 1,c; is_above = 1, is_below = 1
		push de
		ld a,b
		push af
.loop1
		call swapgfxbk
		ld a,(de)
		call swapgfxbk1
		and b
		jr nz,right
		call test_up_down
		call decx
		jr nc,loop1

.right
		pop af
		ld b,a
		pop de
.loop2
		call incx
		ret c
		call swapgfxbk
		ld a,(de)
		call swapgfxbk1
		and b
		ret nz
		call test_up_down
		jr loop2


; enter: de = valid screen address
;        b = uchar mask
; exit : carry = moved off screen
;        de = new screen address left one pixel
;        b = new bitmask left one pixel
; uses : af, b, de

.decx
        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
         ;push bc
         push de
         ex	af,af
         ld      hl,(curx)
         ld      de,-8
         add     hl,de
		 jr		nc,overflow
         ld      de,(cury)
         ld      (curx),hl
         call    w_pixeladdress
         ;ld      h,d
         ;ld      l,e
         ex	af,af
         pop   de
         ;pop   bc
        ;@@@@@@@@@@
		scf
		ret


; b mask
; de - screen address
.incx
        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
         ;push bc
         push de
         ex	af,af
         ld      hl,(curx)
         ld      de,8
         add     hl,de
		 jr		c,overflow
         ld      de,(cury)
         ld      (curx),hl
         call    w_pixeladdress
         ;ld      h,d
         ;ld      l,e
         ex	af,af
         pop   de
         ;pop   bc
        ;@@@@@@@@@@
		scf
		ret

.overflow
		ex af,af
         pop   de
         pop   bc
		 or a
		 ret

; enter: de = valid screen address
; exit : carry = moved off screen
;        de = new screen address one pixel up
; uses : af, de
.decy
        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
        ;push bc
        push de
		ex af,af
         ld      hl,(curx)
         ld      de,(cury)
         dec     de
		 xor	a
		 or		d
		 jr		nz,overflow
         ld      (cury),de
         call    w_pixeladdress
;         ld      h,d
;         ld      l,e
		ex af,af
        pop de
        ;pop bc
        ;@@@@@@@@@@
		scf
		ret


; in: de - address
; exit : carry = moved off screen
;        de = new screen address one pixel up
; uses : af, de
.incy
        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
        ;push bc
        push de
		ex af,af
         ld      hl,(curx)
         ld      de,(cury)
         inc     de
		 ; TODO: overflow check
         ld      (cury),de
         call    w_pixeladdress
         ;ld      h,d
         ;ld      l,e
		ex af,af
        pop de
        ;pop bc
        ;@@@@@@@@@@
		scf
		ret

;#define TEST_UP_DOWN \
;if (y > 0) { \
;	if (point(xs, y - 1)) is_above = 1; \
;	else if (is_above) { \
;		is_above = 0; \
;		ws1->xs = xs; \
;		ws1->y = y - 1; \
;		ws1++; \
;		indeks_ws1++; \
;	}; \
;} \
;if (y < 191) { \
;	if (point(xs, y + 1)) is_below = 1; \
;	else if (is_below) { \
;		is_below = 0; \
;		ws1->xs = xs; \
;		ws1->y = y + 1; \
;		ws1++; \
;		indeks_ws1++; \
;	} \
;}

;struct segment {
;	int xs;
;	int y;
;};


;struct segment sline[2 * 2 * 512 + 4];
;struct segment *ws1 = sline;
;int indeks_ws1 = 0;

;void
;seg(int xs, int y)
;{
;	int txs = xs;
;	char is_above = 1;
;	char is_below = 1;

;	for(; xs > 0; xs--) {
;		if (point(xs, y)) break;
;		plot(xs, y);
;		TEST_UP_DOWN;
;	}

;	xs = txs;
;	if (xs == 511) return;
;	++xs;
;	for (; xs < 511; xs++) {
;		if (point(xs, y)) return;
;		plot(xs, y);
;		TEST_UP_DOWN;
;	}
;}

;void
;fill3(int x, int y)
;{
;	char l;
;	int indeks;
;	struct segment *W;
;	int semafor = 1;
;
;	ws1 = sline;
;	indeks_ws1 = 0;
;	seg(x, y);

;	while (indeks_ws1 != 0) {
;		W = ws1;
;		indeks = indeks_ws1;
;		indeks_ws1 = 0;
;		if (semafor == 1) {
;			semafor = 0;
;			ws1 = &sline[2 * 256 + 2];
;		} else {
;			semafor = 1;
;			ws1 = sline;
;		}
;		while ((indeks--) > 0) {
;			W--;
;			seg(W->xs, W->y);
;		}
;	}
;}

;main()
;{
;	clg();
;	drawb(20, 20, 260, 120);
;	fill(128, 128);
;}

	SECTION  bss_clib
	
.ws1	defw 0
.index	defw 0
.curx	defw   0
.cury	defw   0

