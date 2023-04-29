#include <math/math_fix88.h>

fix88_t fix88_exp(fix88_t fp) __z88dk_fastcall
{
	fix88_t k, z, R, xp;

	if (fp == 0)
		return (FIX88_ONE);
	k = (mulfix88(abs(fp), FIX88_INV_LN2) + FIX88_HALF) & 0xff00;
	if (fp < 0)
		k = -k;
	fp -= mulfix88(k, FIX88_LN2);
	z = mulfix88(fp, fp);
	/* Taylor */
	R = FIX88_ONE + FIX88_ONE +
	    mulfix88(z, 0x2b + mulfix88(z, 0xffff));
	xp = FIX88_ONE + divfix88(mulfix88(fp, FIX88_ONE + FIX88_ONE), R - fp);
	if (k < 0)
		k = FIX88_ONE >> (-k >> 8);
	else
		k = FIX88_ONE << (k >> 8);
	return (mulfix88(k, xp));
}

