/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Move the screen cursor to a given position
	
	$Id: vdp_vfill_v.c,v 1.2 2016-06-16 20:54:25 dom Exp $
*/

#include <video/tms99x8.h>

#pragma codeseg code_video_vdp
#pragma constseg rodata_video_vdp
#pragma bssseg bss_video_vdp
#pragma dataseg data_video_vdp

void vdp_vfill_v(unsigned int addr, unsigned int value, unsigned int count) {
	unsigned int diff;

	diff = addr & 7;
	if (diff) {
		diff = 8 - diff;
		if (diff > count)
			diff = count;
		vdp_vfill(addr, value, diff);
		addr = (addr & ~(7)) + 256;
		count -= diff;
	}

	diff = count >> 3;
	while (diff--) {
		vdp_vfill(addr, value, 8);
		addr += 256;
		count -= 8;	
	}

	if (count > 0)
		vdp_vfill(addr, value, count);

}
