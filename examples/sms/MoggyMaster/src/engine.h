void update_hud () {
	if (game_mode == GAME_A) {
		if (score [0] > hi_score) hi_score = score [0];
		SMS_setTileatXY (6, 0, 0x1000 + 35);
		SMS_setTile (0x1000 + 37);
		SMS_setTile (0x1000 + 34);
		write_big_num (9, 0, score [0]);
		SMS_setTileatXY (15, 0, 0x1000 + 27);
		SMS_setTile (0x1010 + plives [0]);
		SMS_setTileatXY (18, 0, 0x1000 + 32);
		SMS_setTile (0x1000 + 33);
		SMS_setTile (0x1000 + 34);
		write_big_num (21, 0, hi_score);
	} else {
		if (score [0] > hi_score) hi_score = score [0];
		if (score [1] > hi_score) hi_score = score [1];
		SMS_setTileatXY (0, 0, 0x1000 + 35);
		SMS_setTile (0x1000 + 37);
		SMS_setTile (0x1000 + 34);
		write_big_num (3, 0, score [0]);
		SMS_setTileatXY (9, 0, 0x1000 + 27);
		SMS_setTile (0x1010 + plives [0]);
		SMS_setTileatXY (12, 0, 0x1000 + 32);
		SMS_setTile (0x1000 + 33);
		SMS_setTile (0x1000 + 34);
		write_big_num (15, 0, hi_score);
		SMS_setTileatXY (21, 0, 0x1000 + 36);
		SMS_setTile (0x1000 + 37);
		SMS_setTile (0x1000 + 34);
		write_big_num (24, 0, score [1]);
		SMS_setTileatXY (30, 0, 0x1000 + 27);
		SMS_setTile (0x1010 + plives [1]);		
	}
}

void one_life_less (unsigned char p) {
	if (plives [p]) plives [p] --;
}

void init_rano () {
	rx = rand () & 63;
	ry = rand () & 63;
	rmx = 1;
	rmy = 1;
	rframeam = 0;
}

void move_rano () {
	rx += rmx;
	ry += rmy;
	if (rx == 0 || rx == 240) rmx = -rmx;
	if (ry == 0 || ry == 176) rmy = -rmy;

	if (ppx [0] + 7 >= rx && ppx [0] < rx + 15 && ppy [0] + 7 >= ry && ppy [0] < ry + 15 && pactive [0]) {
		pvx [0] = -pvx [0]; pvy [0] = -pvy [0];
		rmx = -rmx; rmy = -rmy;
		PSGSFXPlay (s_psg3 [tv_system], SFX_CHANNEL2);
		one_life_less (0);
		update_hud ();
	}
	if (game_mode == GAME_B) {
		if (ppx [1] + 7 >= rx && ppx [1] < rx + 15 && ppy [1] + 7 >= ry && ppy [1] < ry + 15 && pactive [1]) {
			pvx [1] = -pvx [1]; pvy [1] = -pvy [1];
			rmx = -rmx; rmy = -rmy;
			PSGSFXPlay (s_psg3 [tv_system], SFX_CHANNEL2);
			one_life_less (1);
			update_hud ();
		}
	}

	if ((rand () & 7) == 3) rframeam = 1 - rframeam;

	rframe = RBASE + (rframeam << 2);
}

void draw_terrain () {
	gpp = field;
	SMS_setTileatXY (0, 0, (unsigned int) (*gpp ++));
	gpint = 767; while (gpint --) SMS_setTile (*gpp ++);
}

unsigned char attr (unsigned char x, unsigned char y) {
	return field [x + (y << 5)];
}

void init_moggys () {
	if (game_mode == GAME_A) {
		ppx [0] = 124;
		ppy [0] = 92;
		px [0] = ppx [0] << 6;
		py [0] = ppy [0] << 6;
		pvx [0] = 0;
		pvy [0] = 0;
		pframe [0] = 0;
	} else {
		ppx [0] = 116;
		ppy [0] = ppy [1] = 92;
		ppx [1] = 132;
		
		for (gpit = 0; gpit < 2; gpit ++) {
			px [gpit] = ppx [gpit] << 6;
			py [gpit] = ppy [gpit] << 6;
			pvx [gpit] = 0;
			pvy [gpit] = 0;
			if (pactive [gpit]) pframe [gpit] = 0; else pframe [gpit] = 6;
		}
	}
}

void eat (unsigned char p, unsigned char x, unsigned char y) {
	field [x + (y << 5)] = 7;
	SMS_setTileatXY (x, y, 7);
	friends [p] ++;
	score [p] = score [p] + 1 + rano + level;
	pframe [p] = 0;
	update_hud ();
	PSGSFXPlay (s_psg1 [tv_system], SFX_CHANNEL2);
}

void die (unsigned char p, unsigned char x, unsigned char y) {
	field [x + (y << 5)] = 7;
	SMS_setTileatXY (x, y, 7);
	one_life_less (p);
	pframe [p] = 5;
	update_hud ();
	PSGSFXPlay (s_psg2 [tv_system], SFX_CHANNEL2);
}

void collide_moggies (void) {
	if (ppx [0] + 7 >= ppx [1] && ppx [0] <= ppx [1] + 7 &&
		ppy [0] + 7 >= ppy [1] && ppy [0] <= ppy [1] + 7) {
		
		// Momentum conservation law for equal masses
		// Velocities just... swap! Rocket!!
		aux = pvx [0]; pvx [0] = pvx [1]; pvx [1] = aux;
		aux = pvy [0]; pvy [0] = pvy [1]; pvy [1] = aux;

		// After collision, make sure they don't overlap
		// In the most cheesy manner possible.
		px [0] = pcx [0]; ppx [0] = px [0] >> 6;
		py [0] = pcy [0]; ppy [0] = py [0] >> 6;
		px [1] = pcx [1]; ppx [1] = px [1] >> 6;
		py [1] = pcy [1]; ppy [1] = py [1] >> 6;
	}
}

void move_moggy (unsigned char p) {
	pcx [p] = px [p];
	pcy [p] = py [p];

	if (!pactive [p]) {
		pframe [p] = 6;
		return;
	}

	gpint = SMS_getKeysStatus ();
	phit = 0;

	// =========================================================================
	// H Axis
	// =========================================================================

	px [p] += pvx [p];
	if (px [p] < 0) { px [p] = 0; pvx [p] = 0; }
	if (px [p] > 15872) { px [p] = 15872; pvx [p] = 0; }

	// Collision

	ppx [p] = px [p] >> 6;
	ppy [p] = py [p] >> 6;	
	ptx1 = (ppx [p] + 1) >> 3;
	ptx2 = (ppx [p] + 6) >> 3;
	pty1 = (ppy [p] + 1) >> 3;
	pty2 = (ppy [p] + 6) >> 3;

	if (pvx [p] < 0) {
		// Collide left
		pstop = 0;
		switch (gpit = attr (ptx1, pty1)) {
			case 5:
				eat (p, ptx1, pty1);
				break;
			case 6:
				die (p, ptx1, pty1);
				break;
		}
		pstop = (gpit > 7);
		switch (gpit = attr (ptx1, pty2)) {
			case 5:
				eat (p, ptx1, pty2);
				break;
			case 6:
				die (p, ptx1, pty2);
				break;
		}
		if (gpit > 7 || pstop) {
			// Stop
			ppx [p] = ((ptx1 + 1) << 3) - 1;
			px [p] = ppx [p] << 6;
		}
	} else if (pvx [p] > 0) {
		// Collide right
		pstop = 0;
		switch (gpit = attr (ptx2, pty1)) {
			case 5:
				eat (p, ptx2, pty1);
				break;
			case 6:
				die (p, ptx2, pty1);
				break;
		}
		pstop = (gpit > 7);
		switch (gpit = attr (ptx2, pty2)) {
			case 5:
				eat (p, ptx2, pty2);
				break;
			case 6:
				die (p, ptx2, pty2);
				break;
		}
		if (gpit > 7 || pstop) {
			// Stop
			ppx [p] = ((ptx2 - 1) << 3) + 1;
			px [p] = ppx [p] << 6;
		}
	}

	// Read controller

	if (gpint & player_controller_KEY_LEFT [p]) {
		pframe [p] = 3;
		if (pvx [p] > -PLAYER_MAX_V) pvx [p] -= PLAYER_A;
	} else if (gpint & player_controller_KEY_RIGHT [p]) {
		pframe [p] = 1;
		if (pvx [p] < PLAYER_MAX_V) pvx [p] += PLAYER_A;
	}

	// =========================================================================
	// V Axis
	// =========================================================================

	py [p] += pvy [p];
	if (py [p] < 0) { py [p] = 0; pvy [p] = 0; }
	if (py [p] > 11776) { py [p] = 11776; pvy [p] = 0; }

	// Collision

	ppx [p] = px [p] >> 6;
	ppy [p] = py [p] >> 6;	
	ptx1 = (ppx [p] + 1) >> 3;
	ptx2 = (ppx [p] + 6) >> 3;
	pty1 = (ppy [p] + 1) >> 3;
	pty2 = (ppy [p] + 6) >> 3;

	if (pvy [p] < 0) {
		// Collide up
		pstop = 0;
		switch (gpit = attr (ptx1, pty1)) {
			case 5:
				eat (p, ptx1, pty1);
				break;
			case 6:
				die (p, ptx1, pty1);
				break;
		}
		pstop = (gpit > 7);
		switch (gpit = attr (ptx2, pty1)) {
			case 5:
				eat (p, ptx2, pty1);
				break;
			case 6:
				die (p, ptx2, pty1);
				break;
		}
		if (gpit > 7 || pstop) {
			// Stop
			ppy [p] = ((pty1 + 1) << 3) - 1;
			py [p] = ppy [p] << 6;
		}
	} else if (pvy [p] > 0) {
		// Collide down
		pstop = 0;
		switch (gpit = attr (ptx1, pty2)) {
			case 5:
				eat (p, ptx1, pty2);
				break;
			case 6:
				die (p, ptx1, pty2);
				break;
		}
		pstop = (gpit > 7);
		switch (gpit = attr (ptx2, pty2)) {
			case 5:
				eat (p, ptx2, pty2);
				break;
			case 6:
				die (p, ptx2, pty2);
				break;
		}
		if (gpit > 7 || pstop) {
			// Stop
			ppy [p] = ((pty2 - 1) << 3) + 1;
			py [p] = ppy [p] << 6;
		}
	}

	// Read controller

	if (gpint & player_controller_KEY_UP [p]) {
		pframe [p] = 4;
		if (pvy [p] > -PLAYER_MAX_V) pvy [p] -= PLAYER_A;
	} else if (gpint & player_controller_KEY_DOWN [p]) {
		pframe [p] = 2;
		if (pvy [p] < PLAYER_MAX_V) pvy [p] += PLAYER_A;
	}

}
