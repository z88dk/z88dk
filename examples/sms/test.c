#include <sms.h>

unsigned char pal1[] = {0x00, 0x20, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
				0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char pal2[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
				0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char chr1[] = {0x81, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x81,
                        0xC3, 0xC3, 0xFF, 0xFF, 0xC3, 0xC3, 0xC3, 0x00};

unsigned int bg1[] = {0x0001, 0x0001, 0x0001, 0x0001,
                      0x0001, 0x0001, 0x0001, 0x0001,
                      0x0001, 0x0001, 0x0001, 0x0001,
                      0x0001, 0x0001, 0x0001, 0x0001};

char hello[] = {'H',0,'E',0,'L',0,'L',0,'O',0,',',0,' ',0,'W',0,'O',0,'R',0,'L',0,'D',0,'!',0};
char test[] = "this is a test";
char test2[] = "PAUSE";
char test3[] = "VBL";

void vbl_handler() {
	int i;
	int y;
	char *c;

	for (i = 48, y = 12, c = test3; *c; i--, y += 12, c++) {
		set_sprite(i, 12, y, *c);
	}
}

void pause_handler() {
	int i;
	int y;
	char *c;

	for (i = 63, y = 12, c = test2; *c; i--, y += 12, c++) {
		set_sprite(i, 12, y, *c);
	}
}

void main() {
	int x = 0;
	int y = 0;
	int	 i, j;
	int ply_x = 120;
	int ply_y = 92;
	int ply_tile = 'H';
	int ply2_x = 120;
	int ply2_y = 100;
	int ply2_tile = 'H';
	char *c;

	set_vdp_reg(VDP_REG_HINT_COUNTER, 0xFF);
	set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN/* | VDP_REG_FLAGS1_VINT*/);
	set_bkg_map(bg1, 0, 0, 4, 4);
	set_bkg_map(hello, 0, 6, 13, 1);
	load_tiles(standard_font, 0, 255, 1);
	load_palette(pal1, 0, 16);
	load_palette(pal2, 16, 16);

//	add_raster_int(vbl_handler);
	add_pause_int(pause_handler);

	for (;;) {
		i = read_joypad1();
		if (i & JOY_UP) {
			ply_y--;
		}
		if (i & JOY_DOWN) {
			ply_y++;
		}
		if (i & JOY_LEFT) {
			ply_x--;
		}
		if (i & JOY_RIGHT) {
			ply_x++;
		}
		if (i & JOY_FIREA) {
			ply_tile--;
		}
		if (i & JOY_FIREB) {
			ply_tile++;
		}

		i = read_joypad2();
		if (i & JOY_UP) {
			ply2_y--;
		}
		if (i & JOY_DOWN) {
			ply2_y++;
		}
		if (i & JOY_LEFT) {
			ply2_x--;
		}
		if (i & JOY_RIGHT) {
			ply2_x++;
		}
		if (i & JOY_FIREA) {
			ply2_tile--;
		}
		if (i & JOY_FIREB) {
			ply2_tile++;
		}

		wait_vblank_noint();

		scroll_bkg(x, y);
		x++;
		y += 2;
		if (y > 223) { // The BKG is 224 pixels tall.
			y = 0;
		}

		i = 0;
		j = -(x+x);
		for (c = test; *c; c++) {
			set_sprite(i, j, y, *c);
			i++;
			j += 8;
		}
		set_sprite(i, ply_x, ply_y, ply_tile);
		set_sprite(i+1, ply2_x, ply2_y, ply2_tile);
	}
}
