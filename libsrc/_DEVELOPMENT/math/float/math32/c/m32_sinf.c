
#include	<math.h>

float sinf (float f) __z88dk_fastcall
{
	float	y, y_squared;
	int16_t	sect, e;

	if(f < 0.0) {
		f = -f;
		sect = 2;
	} else
		sect = 0;
	f *= .63661977237;
	if(f > 4.0)
		f -= 4.0 * floorf(f/4.0);
	if(f > 2.0) {
		f -= 2.0;
		sect = 2 - sect;
	}
	y = f - (float)(e = (int16_t)f);
	sect = (e + sect) % 4;
	if(sect & 1)
		y = 1.0 - y;
	if(sect & 2)
		y = -y;
	y_squared = y * y;
	return y * polyf(y_squared, m32_coeff_sin_a, 4) / polyf(y_squared, m32_coeff_sin_b, 4);
}
