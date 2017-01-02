#define __HAVESEED

#include <stdlib.h>
#include <sms.h>

#define VDP_REG_HBL_COUNTER 0x8A

unsigned char pal1[] = {0x2A, 0x3F, 0x0F, 0x00, 0x01, 0x02, 0x03, 0x17,
				0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x03};

unsigned char pal2[] = {0x2A, 0x3F, 0x0F, 0x00, 0x10, 0x20, 0x30, 0x35,
				0x15, 0x35, 0x1D, 0x3D, 0x17, 0x10, 0x20, 0x03};

unsigned int road_pattern[] = {0x0001, 0x0002,
							   0x0000, 0x0000};

unsigned int top_sidewalk_pattern[] = {0x0004,
							   		   0x0004,
							   		   0x0005};

unsigned int bottom_sidewalk_pattern[] = {0x0006,
							   		   	  0x0004};

unsigned int central_strip_pattern[] = {0x0003};

unsigned int car1_map_r[] = {0x0008, 0x0009};
unsigned int car1_map_l[] = {0x0209, 0x0208};

extern unsigned char chicken_graphics[];


int rand_speed() {
	return (rand() & 0x3F) + 0x0A;
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
	int raster[10], speeds[10], *p, *p2;
	char *c;


	for (y = 2; y < 22; y += 2) {
		for (x = 0; x != 32; x += 2) {
			set_bkg_map(road_pattern, x, y, 2, 2);
		}
		for (x = 0; x != 32; x += 4) {
			if (y < 12) {
				set_bkg_map(car1_map_r, x, y+1, 2, 1);
			} else {
				set_bkg_map(car1_map_l, x, y+1, 2, 1);
			}
		}
	}

	for (x = 0; x != 32; x ++) {
		set_bkg_map(top_sidewalk_pattern, x, 0, 1, 3);
		set_bkg_map(bottom_sidewalk_pattern, x, 22, 1, 3);
		set_bkg_map(central_strip_pattern, x, 12, 1, 1);
	}

	for (i = 0, p2 = speeds; i != 5; i++, p2++) {
		(*p2) = rand_speed();
	}
	for (i = 0; i != 5; i++, p2++) {
		(*p2) = -rand_speed();
	}

	set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN);

	load_tiles(chicken_graphics, 0, 255, 4);
	load_palette(pal1, 0, 16);
	load_palette(pal2, 16, 16);

//	add_pause_int(pause_handler);

	for (;;) {
		p = raster;
		p2 = speeds;
		j = 0;
		x = 1;
		y = 16;
		while (get_vcount() != 0) {
		}
		x = (*p) >> 4;
		while (y < 176) {
			while (get_vcount() < y) {
			}
			if (j & 0x01) {
				load_palette(pal1, 0, 16);
			} else {
				load_palette(pal2, 0, 16);
			}
			scroll_bkg(x, y);
			(*p) += (*p2);
			p++;
			p2++;
			x = (*p) >> 4;
			y += 14;
			j++;

			while (get_vcount() < y) {
			}
			scroll_bkg(0, 0);
			y += 2;
		}
		load_palette(pal1, 0, 16);
		scroll_bkg(0, 0);

		wait_vblank_noint();
	}
}
