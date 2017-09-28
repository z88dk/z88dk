#include <stdio.h>
#include <sound.h>

unsigned char buffer[100];
unsigned char c;

/*
#define __VGL_KEY_STATUS_ADDRESS  0xdb00
#define __VGL_KEY_CURRENT_ADDRESS  0xdb01

#define __VGL_DISPLAY_COLS  20
#define __VGL_DISPLAY_ROWS  4
#define __VGL_DISPLAY_CONTROL_PORT  0x0a
#define __VGL_DISPLAY_REFRESH_ADDRESS  0xdcf0
#define __VGL_DISPLAY_CURSOR_X_ADDRESS  0xdcf4
#define __VGL_DISPLAY_CURSOR_Y_ADDRESS  0xdcf5
#define __VGL_DISPLAY_CURSOR_MODE_ADDRESS  0xdcf6
#define __VGL_DISPLAY_CLEAR_ADDRESS  0xdcf7
#define __VGL_VRAM_ADDRESS_START  0xdca0

#define __VGL_SYSTEM_ARCHITECTURE_0006 0x0006
#define __VGL_SYSTEM_ARCHITECTURE_0038 0x0038
#define __VGL_SYSTEM_ARCHITECTURE_4000 0x4000
#define __VGL_SYSTEM_ARCHITECTURE_801E 0x801E

#define __VGL_DISPLAY_CURSOR_OFFSET_MODEL2000 0xdcef		// Current column + 64*row
#define __VGL_DISPLAY_CURSOR_MODE_MODEL2000 0xdced		// Show cursor (0=off, 1=block 2=line)


void delay_0x010f() {
	// Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
	#asm
		push	hl
		ld	hl, 010fh
	_delay_010f_loop1:
		dec	l
		jr	nz, _delay_010f_loop1
		dec	h
		jr	nz, _delay_010f_loop1
		pop	hl
	#endasm
}

unsigned char sys_getType() {
	
	// Returns 2 for MODEL2000, 3 for MODEL4000
	
	
	// checkArchitecture1(): Check 10x byte at [0038 + x*3]. If all are 0xc3 return A=3, else return A=2
	#asm
		push	bc
		push	de
		push	hl
	
		ld	de, 3h
		ld	b, 0ah
		ld	hl, __VGL_SYSTEM_ARCHITECTURE_0038
		
		_ca1_loop:
			ld	a, (hl)
			cp	0c3h	; check if [HL] == 0xc3	(This is the case for MODEL2000 and MODEL4000)
			jr	nz, _ca1_ret2	; if not: set a:=2 and return
			add	hl, de	; increment by 3
		djnz	_ca1_loop
		
		; They have all evaluated to 0xc3
		ld	a, 03h	; set a:=3
		jr	_ca1_retA
		
		_ca1_ret2:
		ld	a, 02h
		
		_ca1_retA:
		pop	hl
		pop	de
		pop	bc
		
		;ret
		
		; Store result
		xor	h
		ld	l, a
	#endasm
	
	// checkArchitecture2(A): call checkArchitecture3_A2/3 accordingly
	#asm
		push	af
		push	hl
		; The next check depends on the previous result (A=2 or A=3)
		cp	02h
		jr	z, _ca3A2	; if a == 2: checkArchitecture3_A2(): Probe CPU and ROM, continue at checkArchitecture5()
		call	_ca3A3	; checkArchitecture3A3(): Set A to ([0x0006] & 0x7f >> 4)
		jr	_ca5
	#endasm
	
	// checkArchitecture3_A2(): Probe CPU and ROM, continue at checkArchitecture5()
	#asm
		_ca3A2:
			call	_ca4A2	; checkArchitecture4_A2(): Probe CPU (out (0x01), 0x01), check [0x4003]: Return A=1 for 0x02 and A=2 for 0x01 else A=that value
			jr	_ca5	; checkArchitecture5(): Probe ROM header, reset if 0x801e <> A
	#endasm

	// checkArchitecture3_A3(): Set A to ([0x0006] & 0x7f >> 4)
	#asm
		_ca3A3:
			ld	a, (__VGL_SYSTEM_ARCHITECTURE_0006)
			and	7fh
			srl	a
			srl	a
			srl	a
			srl	a
		ret
	#endasm
	
	
	// checkArchitecture4_A2(): Probe CPU (out (0x01), 0x01), check [0x4003]: Return A=1 for 0x02 and A=2 for 0x01 else A=that value
	#asm
		_ca4A2:
			push	hl
			ld	hl, __VGL_SYSTEM_ARCHITECTURE_4000
			ld	a, 01h	; out 0x01, 0x01: Get model? language?
			out	(01h), a
			push	bc
			ld	bc, 0003h
			add	hl, bc
			pop	bc
			ld	a, (hl)	; get value at 0x4003
			cp	02h
			jr	z, _ca4A2_ret1	; return 1
			cp	01h
			jr	z, _ca4A2_ret2	; return 2
			jr	_ca4A2_retA	; break
			
		_ca4A2_ret1:
			ld	a,01h
			jr	_ca4A2_retA	; break
			
		_ca4A2_ret2:
			ld	a,02h
			
		_ca4A2_retA:
			pop	hl
		ret
	#endasm
	
	// checkArchitecture5(): Probe ROM header, reset if 0x801e <> A
	#asm
		_ca5:
			ld	hl, __VGL_SYSTEM_ARCHITECTURE_801E	; This is inside the header at the beginning of the ROM, Right after the PC-PROGCARD-text
			cp	(hl)
			jp	nz,0000h	; reset if [801e] > 0 (it is in fact 01h)
			pop	hl
			pop	af
		
		_ca_end:
			; Store result
			xor	h
			ld	l, a
	#endasm
}

void test() {

	c = sys_getType();
	
	#asm
	
	; Refresh all
	ld a, 0x01
	ld (__VGL_DISPLAY_REFRESH_ADDRESS),a
	ld (__VGL_DISPLAY_REFRESH_ADDRESS+1),a
	ld (__VGL_DISPLAY_REFRESH_ADDRESS+2),a
	ld (__VGL_DISPLAY_REFRESH_ADDRESS+3),a
	
	call _delay_0x010f
	
	
	;;cursor_reset
	;xor	a
	;ld	(0dcedh),a
	;ld	(0dceeh),a
	;ld	(0dcefh),a
	;ld	(0dcf0h),a	; This also refreshes row 0 on MODEL 4000, because that is its refresh-location! (fo..f3)
	
	
	ld a, 1
	ld (__VGL_DISPLAY_CURSOR_MODE_ADDRESS), a
	
	ld a, 10
	ld (__VGL_DISPLAY_CURSOR_X_ADDRESS), a
	ld a, 1
	ld (__VGL_DISPLAY_CURSOR_Y_ADDRESS), a
	
	ld a, 0x40*1
	ld (__VGL_DISPLAY_CURSOR_OFFSET_MODEL2000), a
	ld a, 1
	ld (__VGL_DISPLAY_CURSOR_MODE_MODEL2000), a
	
	
	call _delay_0x010f
	
	ld a, 0x41
	out (0x0b), a
	call _delay_0x010f
	
	
	;ld a, 0
	;out (0x01), a
	;call _delay_0x010f
	
	;ld a, 0
	;out (0x03), a
	;call _delay_0x010f
	
	#endasm
	
	getchar();
}

*/

void main(void) {
	
	
	//test();
	
	printf("Hello, World!\n");
	
	getchar();
	
	/*
	printf("Beeping...");
	bit_beep(100, 880);
	printf("!\n");
	*/
	
	printf("Enter something: ");
	gets(buffer);
	printf("You entered: \"%s\"\n", buffer);
	
	
	while(1) {
		
		printf("key>");
		
		//c = getc(stdin);
		c = getchar();
		
		sprintf(buffer, "%d:\"%c\"\n", c, c);
		printf(buffer);
		
	}
	
}
