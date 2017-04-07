#define LAST_CHOICE 1

unsigned char menu (void) {
	// Set palettes
	SMS_loadBGPalette (palette_2);
	
	// Load patterns for tiles. TITLE_NPATTERNS tiles, 32 bytes per tile.
	SMS_loadTiles (title_patterns, 0, TITLE_NPATTERNS * 32);

	// Directly copy nametable to VRAM, FULL 1536 bytes
	SMS_loadTileMap (0, 0, title_nametable, 1534);	// Last tile is a black square. I won't be copying it
	SMS_setTileatXY (31, 23, 0x1000 + 0); 			// So I print a blank by hand.

	// Turn screen on
	SMS_displayOn ();

	// Murcia stuff
	PSGPlay (m_title [tv_system]);

	while (1) {
		// Move sprite cursor
		gpint = SMS_getKeysStatus ();

		// Silly, but maybe someday there's more than 1 option
		if ((gpint & PORT_A_KEY_UP) || (gpint & PORT_B_KEY_UP)) 
			if (menu_choice) { menu_choice --; PSGSFXPlay (s_select [tv_system], SFX_CHANNEL2); }
		if ((gpint & PORT_A_KEY_DOWN) || (gpint & PORT_B_KEY_DOWN)) 
			if (menu_choice < LAST_CHOICE) { menu_choice ++; PSGSFXPlay (s_select [tv_system], SFX_CHANNEL2); }
		if ((gpint & PORT_A_KEY_1) || (gpint & PORT_B_KEY_1)) { PSGSFXPlay (s_select [tv_system], SFX_CHANNEL2); break; }

		// Sprite to highlight menu choice
		SMS_initSprites ();
		SMS_addSprite (72, (menu_choice << 4) + 112, 0);
		SMS_finalizeSprites ();

		// Wait for VSync and update SAT
		SMS_waitForVBlank ();
		SMS_copySpritestoSAT ();

		// Murcia stuff
		PSGFrame ();
		PSGSFXFrame (); 
	}

	PSGStop ();
	
	// Wait 1 second
	wait_frames (50);
	PSGSFXStop ();

	// Last tile is a black tile.
	effect (TITLE_NPATTERNS - 1);
	SMS_displayOff ();

	return menu_choice;
}

void do_vs_screen (void) {
	// Who won?
	if (friends [0] == friends [1]) {
		who_won = 2;
	} else {
		who_won = friends [0] < friends [1];
		won [who_won] ++;
	}

	// Set palettes
	SMS_loadBGPalette (palette_4);

	// Load patterns for tiles. VS_SCR_NPATTERNS tiles, 32 bytes per tile
	SMS_loadTiles (vs_scr_patterns, 0, VS_SCR_NPATTERNS * 32);

	// Clear nametable to char 0
	cls ();

	/*SMS_setNextTileatXY (0, 0);
	for (gpit = 0; gpit < VS_SCR_NPATTERNS; gpit ++) SMS_setTile (gpit);
	*/

	// Draw context dependent stuff
	if (who_won == 1) {
		print_str (14, 2, "WAW");
		SMS_loadTileMapArea (12, 6, vs_scr_sect_01, 8, 12);
	} else if (who_won == 0) {
		print_str (13, 2, "MOGGY");
		SMS_loadTileMapArea (12, 6, vs_scr_sect_00, 8, 12);
	}

	// Draw fixed stuff
	// Moggy stats
	print_str (1, 5, "1UP MOGGY");
	SMS_setTileatXY (3, 7, VS_SCR_NPATTERNS - 3);
	SMS_setTile (59);
	print_3digits_next (friends [0]);
	write_big_num (3, 9, score [0]);
	print_str (3, 11, "TOTAL");
	thick_number (2, 13, won [0] / 10, VS_SCR_NPATTERNS - 2);
	thick_number (6, 13, won [0] % 10, VS_SCR_NPATTERNS - 2);

	// Waw stats
	print_str (23, 5, "2UP WAW");
	SMS_setTileatXY (24, 7, VS_SCR_NPATTERNS - 3);
	SMS_setTile (59);
	print_3digits_next (friends [1]);
	write_big_num (24, 9, score [1]);
	print_str (24, 11, "TOTAL");
	thick_number (23, 13, won [1] / 10, VS_SCR_NPATTERNS - 2);
	thick_number (27, 13, won [1] % 10, VS_SCR_NPATTERNS - 2);

	// General
	if (who_won != 2) {
		print_str (13, 4, "WINS!!");
	} else {
		print_str (13, 4, "DRAW!!");
	}
	if (do_game) {
		print_str (11, 21, "DALE FRAN!");
	} else {
		print_str (11, 21, "GAME OVER!");
	}

	// Screen on
	SMS_displayOn ();

	// Murcia stuff
	PSGPlay (m_vs [tv_system]);

	// Wait input
	wait_button ();

	PSGStop ();
	PSGSFXPlay (s_start [tv_system], SFX_CHANNEL2);
	wait_frames (50);

	// Last tile is a black tile.
	effect (VS_SCR_NPATTERNS - 1);
	SMS_displayOff ();
}
