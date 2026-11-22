
// int  bit_load_msx(char *name, size_t loadstart, size_t len);

// Stefano Bodrato,  Feb, 2023

// We get any file matching with the (even partial) filespec in *name.
// If *name is an empty string, we pick the first file in BLOAD mode
// If len is zero, we pick it from the header


#include <sound.h>


int bit_load_msx(char *name, void *loadstart, size_t len)
{
	int ld_flag;
	int x;
	unsigned int start,end;
	
	ld_flag=0;
	while (!ld_flag) {
		if (bit_tapion()==-1) return (-1);
		
		// bit_tapin() is a bit 'more lag tolerant' than bit_tapion(),
		// Under some circumstance an immediate read after bit_tapion() may help
		
		// The block type is repeated 10 times, then a filename follows
		for (x=0; x<10; x++) {
			if (bit_tapin() != 0xD0) {
				ld_flag=1;
				break;
			}
		}
		
		for (x=0; x<6; x++) {
			if (!name[x]) break;
			if (name[x]!=bit_tapin()) ld_flag=1;
		}
		
		bit_tapiof();


		if (!ld_flag) {
			if (bit_tapion()==-1) return (-1);
			start=bit_tapin()+256*bit_tapin();
			end=bit_tapin()+256*bit_tapin();
			bit_tapin(); bit_tapin();		//exec=bit_tapin()+256*bit_tapin();
			if (!len) len=end-start;
			for (x=0; x<len; x++)
				loadstart[x]=bit_tapin();
			bit_tapiof();
			ld_flag=2;
		} else
			ld_flag=0;	// no data loaded, stay in the loop
	}
	
	return (len);
}


