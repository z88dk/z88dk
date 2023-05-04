#define DISABLE_NATIVE_ACCUM 1
#include <math/math_fix88.h>
#include <stdlib.h>

fix16_t fix16_exp(fix16_t fp) __z88dk_fastcall
{
	fix16_t k, z, R, xp;

	if (fp == 0)
		return (FIX16_ONE);
	k = (mulk(abs(fp), FIX16_INV_LN2) + FIX16_HALF) & 0xff00;
	if (fp < 0)
		k = -k;
	fp -= mulk(k, FIX16_LN2);
	z = mulk(fp, fp);
	/* Taylor */
	R = FIX16_ONE + FIX16_ONE +
	    mulk(z, 0x2b + mulk(z, 0xffff));
	xp = FIX16_ONE + divk(mulk(fp, FIX16_ONE + FIX16_ONE), R - fp);
	if (k < 0)
		k = FIX16_ONE >> (-k >> 8);
	else
		k = FIX16_ONE << (k >> 8);
	return (mulk(k, xp));
}

