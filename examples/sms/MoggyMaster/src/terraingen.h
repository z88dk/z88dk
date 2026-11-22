// Generates a height-based pseudo lame terrain
#define RAISERS 32

unsigned int bc;
signed char tx, ty, tx0, ty0;
unsigned char patterns [] = {
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 1, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 1, 0, 0,
	0, 1, 2, 1, 0,
	0, 0, 1, 0, 0,
	0, 0, 0, 0, 0,
	0, 1, 1, 1, 0,
	1, 1, 2, 1, 1,
	1, 2, 3, 2, 1,
	1, 1, 2, 1, 1,
	0, 1, 1, 1, 0,
	0, 0, 1, 1, 0,
	0, 1, 2, 2, 1,
	1, 1, 2, 3, 1,
	0, 0, 1, 2, 0,
	0, 0, 0, 1, 0
};

void terraingen () {
	// Initialize a plain terrain, terrain is 32x24 (768)
	gpp = field;
	bc = 768; while (bc --) *gpp ++ = 1;

	// Plant raisers
	for (gpit = 0; gpit < RAISERS; gpit ++) {
		tx0 = (rand () & 31) - 2;
		ty0 = (rand () & 15) + (rand () & 7) - 2;

		gpp = patterns + 25 * (rand () & 3);
		for (tx = tx0; tx < tx0 + 5; tx ++) {
			for (ty = ty0; ty < ty0 + 5; ty ++) {
				if (tx > 0 && tx < 32 && ty > 0 && ty < 24) {
					gpp2 = field + (ty << 5) + tx;
					*gpp2 += *gpp;
					if (*gpp2 > 4) *gpp2 = 4;
				}
				gpp ++;
			}
		}
	}
}

void add_item (unsigned char n, unsigned char t) {
	gpit = n; while (gpit --) {
		do {
			gpint = 32 + (rand () % 736);
		} while (field [gpint] > 4 || gpint == 367 || gpint == 368 || gpint == 399 || gpint == 400);
		field [gpint] = t;
	}
}

void add_schrooms (unsigned char n) {
	gpit = n; while (gpit --) {
		do {
			gpint = 32 + (rand () % 704);
		} while (field [gpint] > 4 || field [gpint + 1] > 4 || field [gpint + 32] > 4 || field [gpint + 33] > 4 || gpint == 367 || gpint == 368 || gpint == 399 || gpint == 400);
		gpjt = 8 + ((rand () & 1) << 2);
		field [gpint ++] = gpjt ++;
		field [gpint] = gpjt ++; gpint += 31;
		field [gpint ++] = gpjt ++;
		field [gpint] = gpjt;
	}
}
