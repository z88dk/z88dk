// zcc +sms -v -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 hello.c -o hello -pragma-include:zpragma.inc -create-app

#include <stdio.h>
#include <compress/zx7.h>
#include <stropts.h>

extern unsigned char sms_default_font_zx7[];

const unsigned char author[] = "z88dk";
const unsigned char name[] = "Hello World";
const unsigned char description[] = "Test program for the output terminal.";

void main(void)
{
	sms_dzx7_standard_vram(sms_default_font_zx7, 0);
	
	ioctl(1, IOCTL_OTERM_CLS);

	while (1)
		printf("SMS says Hello World!\n");
}
