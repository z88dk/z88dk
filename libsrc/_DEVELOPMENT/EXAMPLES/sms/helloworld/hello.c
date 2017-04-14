// zcc +sms -v -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 hello.c -o hello -pragma-include:zpragma.inc -create-app

#include <stdio.h>
#include <compress/zx7.h>
#include <stropts.h>
#include <arch/sms.h>
#include <intrinsic.h>

extern unsigned char sms_default_font_zx7[];
extern unsigned char sms_default_font[];
extern unsigned char sms_default_font_end[];

const unsigned char author[] = "z88dk";
const unsigned char name[] = "Hello World";
const unsigned char description[] = "Test program for the output terminal.";

const unsigned char palette[] = {0x00,0x01,0x05,0x15,0x24,0x25,0x29,0x39,0x16,0x1a,0x1b,0x2a,0x3a,0x3e,0x2b,0x3f};

void main(void)
{
	sms_memcpy_mem_to_cram(0, palette, 16);
	sms_memcpy_mem_to_cram(16, palette, 16);
	//sms_dzx7_standard_vram(sms_default_font_zx7, 0);
	sms_memcpy_mem_to_vram(0, sms_default_font, sms_default_font_end - sms_default_font);
	
	// must turn on the display!
	
	IO_VDP_COMMAND = 0xc0;
	IO_VDP_COMMAND = 0x81;
	
	ioctl(1, IOCTL_OTERM_CLS);
	ioctl(1, IOCTL_OTERM_PAUSE, 0);

	while (1)
	{
		printf("SMS says Hello World!\n");
		printf("Something else...\n");
	}
}
