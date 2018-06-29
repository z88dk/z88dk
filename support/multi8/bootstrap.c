/*
 * Bootstrap program for loading larger programs in 64k mode
 * on the Mitsubishi Multi8
 *
 * zcc +multi8 bootstrap.c -create-app
 */

#include <stdio.h>
#include <arch/multi8.h>


extern void start() @ 0x0000;

#pragma define CRT_ENABLE_STDIO=0
#pragma redirect fputc_cons=fputc_cons_native

static void setup_memory_map() __naked
{
#asm
	; Here we need to switch to 64k RAM mode
	; We have no access to the display (unless we page it in)
	di
	ld	a,@00100000	;bit 5 set = RAM
				;bit 4 reset = RAM
	out	($2a),a
	ret
#endasm
}

static void reset_memory_map() __naked
{
#asm
	; Here we need to switch to 64k RAM mode
	; We have no access to the display (unless we page it in)
	ld	a,@00010000	;bit 5 set = RAM
				;bit 4 reset = RAM
	out	($2a),a
	ei
	ret
#endasm
}

static void write_string(unsigned char *str) __z88dk_fastcall 
{
    while (*str)
       fputc_cons(*str++);
}

int main() 
{
    write_string("z88dk Multi8 bootstrap starting\n");
    setup_memory_map();
    if ( tape_load() == 0 ) {
        start();
    } else {
        reset_memory_map();
        write_string("Loading failed\n");
    }
}
