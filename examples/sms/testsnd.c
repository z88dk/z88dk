#include <sms.h>

void main() {
	int i, j;

	for (i = 0; i != 3; i++) {
		set_sound_freq(i, 300*(i+1));
		set_sound_volume(i, 0x0F);
		for (j = 0; j != 70; j++) {
			wait_vblank_noint();
		}
	}

	for (j = 0; j != 140; j++) {
		wait_vblank_noint();
	}
	for (i = 0; i != 4; i++) {
		set_sound_volume(i, 0);
	}

	set_sound_freq(3, 0x04);
	set_sound_volume(3, 0x0F);
	for (j = 0; j != 140; j++) {
		wait_vblank_noint();
	}
	set_sound_volume(3, 0);

	while (1) {
	}
}
