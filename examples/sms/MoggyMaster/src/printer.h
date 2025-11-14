void write_big_num (unsigned char x, unsigned char y, unsigned int big_num) {
	SMS_setTileatXY (x, y, 16 + big_num / 10000);
	SMS_setTile (0x1010 + (big_num % 10000) / 1000);
	SMS_setTile (0x1010 + (big_num % 1000) / 100);
	SMS_setTile (0x1010 + (big_num % 100) / 10);
	SMS_setTile (0x1010 + big_num % 10);
}

void effect (unsigned char t) {
	for (gpit = 0; gpit < 12; gpit ++) {
		SMS_waitForVBlank ();
		for (gpjt = gpit; gpjt < 32 - gpit; gpjt ++) {
			SMS_setTileatXY (gpjt, gpit, 0x1000 + t);
			SMS_setTileatXY (gpjt, 23 - gpit, 0x1000 + t);
		}
		for (gpjt = gpit; gpjt < 24 - gpit; gpjt ++) {
			SMS_setTileatXY (gpit, gpjt, 0x1000 + t);
			SMS_setTileatXY (31 - gpit, gpjt, 0x1000 + t);
		}
	}
}

// Assumes ASCII font @ 0 from space onwards (-32)
void print_str (unsigned char x, unsigned char y, unsigned char *s) {
	SMS_setNextTileatXY (x, y);
	while ( gpit = *s ++ ) SMS_setTile (gpit - 32);
}

// CLS
void cls (void) {
	SMS_setNextTileatXY (0, 0);
	for (gpint = 0; gpint < 768; gpint ++) SMS_setTile (0);
}

// Big numbers
unsigned char bn [] = {
	1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 
	0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 
	1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 
	1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 
	1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 
	1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 
	1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 
	1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 
	1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 
	1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1
};
void thick_number (unsigned char x, unsigned char y, unsigned char n, unsigned char t) {
	gpp = bn + n * 15;
	for (gpjt = 0; gpjt < 5; gpjt ++) {
		SMS_setNextTileatXY (x, y + gpjt);
		for (gpit = 0; gpit < 3; gpit ++) SMS_setTile (*gpp ++ ? t : 0);
	}
}

// Print 3 digits number at current pos
void print_3digits_next (unsigned char big_num) {
	SMS_setTile (0x1010 + big_num / 100);
	SMS_setTile (0x1010 + (big_num % 100) / 10);
	SMS_setTile (0x1010 + big_num % 10);
}

// Waits for 1 in either pad
void wait_button (void) {
	while (1) {
		gpint = SMS_getKeysStatus ();
		SMS_waitForVBlank ();
		PSGFrame ();
		PSGSFXFrame (); 
		if ((gpint & PORT_A_KEY_1) || (gpint & PORT_B_KEY_1)) break;
	}
	do {
		SMS_waitForVBlank ();
		PSGFrame ();
		PSGSFXFrame (); 
		gpint = SMS_getKeysStatus ();
	} while ((gpint & PORT_A_KEY_1) || (gpint & PORT_B_KEY_1));
}

void wait_frames (unsigned char frames) {
	while (frames --) {
		SMS_waitForVBlank ();
		PSGSFXFrame (); 
	}
}