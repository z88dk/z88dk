// wtf, 1st SMS game
// Copy [p]left 2015 The Mojon Twins

const unsigned char wtf_name[] = "Moggy";
const unsigned char wtf_author[] = "MojonTwins";
const unsigned char wtf_description[] = "Pero que seto";

#include <arch/sms/SMSlib.h>
#include <arch/sms/PSGlib.h>
#include <stdlib.h>

#include "definitions.h"

#include "bank2.h"
#include "bank3.h"
#include "music_defs.h"
#include "palettes.h"
#include "tiles.h"
#include "sprites.h"
#include "title.h"
#include "vs_scr.h"

#include "printer.h"
#include "menu.h"
#include "terraingen.h"
#include "engine.h"

void main (void) {
	// Check TV system
	tv_system = (SMS_VDPType () & VDP_NTSC) ? 1 : 0;

	// Fixed. This is the only banking I need for this game.
	SMS_mapROMBank (2 + tv_system);

	// Initialize
	hi_score = 0;
	player_controller_KEY_LEFT [0] = PORT_A_KEY_LEFT;
	player_controller_KEY_LEFT [1] = PORT_B_KEY_LEFT;
	player_controller_KEY_RIGHT [0] = PORT_A_KEY_RIGHT;
	player_controller_KEY_RIGHT [1] = PORT_B_KEY_RIGHT;
	player_controller_KEY_UP [0] = PORT_A_KEY_UP;
	player_controller_KEY_UP [1] = PORT_B_KEY_UP;
	player_controller_KEY_DOWN [0] = PORT_A_KEY_DOWN;
	player_controller_KEY_DOWN [1] = PORT_B_KEY_DOWN;

	// Sprites will not change, nor the sprites palette, so 
	// I load them here:
	SMS_loadSpritePalette (palette_1);
	SMS_loadTiles (sprites, 256, 32 * 32);

	// Main, infinite loop
	while (1) {
		level = 0;
		score [0] = score [1] = 0;
		won [0] = won [1] = 0;
		nn = 5;
		rano = 0;

		// testing
		game_mode = menu ();

		game_over = 0;
		do_game = 1;
		plives [0] = plives [1] = 5;
		pactive [0] = pactive [1] = 1;
		
		while (do_game) {
			
			// Draw shit
			terraingen ();
			add_schrooms (8);
			add_item (nn, 5);
			add_item (nn, 6);
			draw_terrain ();
			update_hud ();

			// Init
			init_moggys ();
			if (rano) init_rano ();

			// Set palette
			SMS_loadBGPalette (palette_0);

			// Load patterns for tiles. 48 tiles, 32 bytes per tile.
			SMS_loadTiles (tiles, 0, 48 * 32);

			// Show shit
			SMS_displayOn ();

			friends [0] = friends [1] = 0;
			do_level = 1;
			
			PSGPlay (m_ingame [tv_system]);

			while (do_level) {
				// Update sprites
				SMS_initSprites ();
				if (game_mode == GAME_A) {
					SMS_addSprite (ppx [0], ppy [0], pframe [0]);
				} else {
					SMS_addSprite (ppx [0], ppy [0], pframe [0]);
					SMS_addSprite (ppx [1], ppy [1], 16 + pframe [1]);
				}
				if (rano) {
					SMS_addSprite (rx, ry, rframe);
					SMS_addSprite (rx + 8, ry, rframe + 1);
					SMS_addSprite (rx, ry + 8, rframe + 2);
					SMS_addSprite (rx + 8, ry + 8, rframe + 3);
				}
				SMS_finalizeSprites ();

				// Game logic
				move_moggy (0);
				if (game_mode == GAME_B) {
					move_moggy (1);
					collide_moggies ();
				}
				if (rano) move_rano ();

				if (game_mode == GAME_A) {
					if (friends [0] == nn) do_level = 0;
					if (plives [0] == 0) { do_level = 0; game_over = 1; PSGSFXPlay (s_psg4 [tv_system], SFX_CHANNEL2); }
				} else {
					if (friends [0] + friends [1] == nn) do_level = 0;
					if (pactive [0] && plives [0] == 0) { pactive [0] = 0; PSGSFXPlay (s_psg4 [tv_system], SFX_CHANNEL2); do_game = 0; }
					if (pactive [1] && plives [1] == 0) { pactive [1] = 0; PSGSFXPlay (s_psg4 [tv_system], SFX_CHANNEL2); do_game = 0; }
					if (pactive [0] == 0 && pactive [1] == 0) { game_over = 1; do_level = 0; }
				}

				// Wait for VSync and update SAT
				SMS_waitForVBlank ();
				SMS_copySpritestoSAT ();

				// Murcia stuff
				PSGFrame ();
				PSGSFXFrame (); 
			}

			PSGStop ();
			PSGSFXStop ();

			// Remove sprites
			SMS_initSprites ();
			SMS_finalizeSprites ();
			SMS_waitForVBlank ();
			SMS_copySpritestoSAT ();
			
			if (game_over) {
				do_game = 0;
				
				SMS_waitForVBlank ();
				SMS_setTileatXY (15, 12, 0x1000 + 29);
				SMS_setTile (0x1000 + 30);
				SMS_setTile (0x1000 + 31);

				PSGPlay (m_gover [tv_system]);
				wait_button ();
				PSGStop ();
			} else {
				level ++;
				nn = nn + 5;
				if (0 == (nn & 1)) nn ++;	// Make odd!
				rano = rand () & 1;
				if (game_mode == GAME_A || pactive [0]) score [0] = score [0] + 10;
				if (game_mode == GAME_B && pactive [1]) score [1] = score [1] + 10;
			}

			// Disable screen
			effect (28);
			SMS_displayOff ();

			if (game_mode == GAME_B) do_vs_screen ();
		}
	}
}
