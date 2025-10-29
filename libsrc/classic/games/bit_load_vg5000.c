
// int  bit_load_vg5000(char *name, size_t loadstart, size_t len);

// Stefano Bodrato,  Feb, 2023

// We get any file matching with the (even partial) filespec in *name.
// If *name is an empty string, we pick the first file in BLOAD mode
// If len is zero, we pick it from the header
// If a valid header was found but the load fails we try to force the return value to zero


#include <sound.h>


int bit_load_vg5000(char *name, void *loadstart, size_t len)
{
	int ld_flag;
	int x;
	unsigned int start,size;
	
	ld_flag=0;
	while (!ld_flag) {
		if (bit_tapion()==-1) return (-1);
		
		// bit_tapin() is a bit 'more lag tolerant' than bit_tapion(),
		// Under some circumstance an immediate read after bit_tapion() may help
		
		// The block type is repeated 10 times, then a filename follows
		for (x=0; x<10; x++) {
			if (bit_tapin() != 0xD3) {
				ld_flag=1;
				break;
			}
		}
		
		// Must be a 'CLOADM' file 
		if (bit_tapin()!='M') ld_flag=1;

		for (x=0; x<6; x++) {
			if (!name[x]) break;
			if (name[x]!=bit_tapin()) ld_flag=1;
		}

		// Skip BASIC related and useless stuff
		for (x=0; x<9; x++)
			bit_tapin();

		start=bit_tapin()+256*bit_tapin();
		size=bit_tapin()+256*bit_tapin();
		// Let's ignore the checksum
		//cksum=bit_tapin()+256*bit_tapin();
		if (!len) len=size;
		
		bit_tapiof();


		if (!ld_flag) {
			if (bit_tapion()==-1) return (-1);

			// The block type is repeated 10 times, then a filename follows
			for (x=0; x<10; x++) {
				if (bit_tapin() != 0xD6) {
					ld_flag=1;
					break;
				}
			}

			if (!ld_flag)
				for (x=0; x<len; x++)
					loadstart[x]=bit_tapin();
			else len=0;
			bit_tapiof();
			ld_flag=2;
		} else
			ld_flag=0;	// no data loaded, stay in the loop
	}
	
	return (len);
}

