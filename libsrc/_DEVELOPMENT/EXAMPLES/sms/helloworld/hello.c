#include <stdio.h>
#include <stropts.h>
#include <arch/sms.h>
#include <rect.h>
#include <z80.h>

const unsigned char author[] = "z88dk";
const unsigned char name[] = "Hello World";
const unsigned char description[] = "Test program for the output terminal.";

const struct r_Rect8 rect = {0, 32, 0, 24};

extern unsigned char font_8x8_clairsys[];
extern unsigned char font_8x8_clairsys_end[];

const unsigned char palette[] = {0x00,0x01,0x05,0x15,0x24,0x25,0x29,0x39,0x16,0x1a,0x1b,0x2a,0x3a,0x3e,0x2b,0x3f};

void main(void)
{
	sms_memcpy_mem_to_cram(0, palette, 16);
	sms_memcpy_mem_to_cram(16, palette, 16);

	sms_vdp_set_write_address(0x0000);
	sms_copy_font_8x8_to_vram(font_8x8_clairsys, 127, 0, 1);
	
	sms_display_on();
	sms_border(4);
	
	// clear entire screen with # character
	
	sms_cls_wc(&rect,'#' - 32);
	
	// clear terminal only
	
	ioctl(1, IOCTL_OTERM_CLS);
	ioctl(1, IOCTL_OTERM_PAUSE, 0);

	while (1)
	{
		printf("SMS says Hello World!\n");
		z80_delay_ms(250);
		printf("Something else...\n");
		z80_delay_ms(250);
	}
}
