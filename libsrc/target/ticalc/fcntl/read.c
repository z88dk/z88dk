// Empathic Qubit - Jan. 2023

#include <sys/types.h>
#include <fcntl.h>
#include "ticalc_fcntl.h"

/** Read bytes from an AppVar */
ssize_t read(int fd, void *ptr, size_t len) __smallc
{
	unsigned char *p = ptr;
	for(; len > 0; len--) {
		int byte = readbyte(fd);
		if(byte < 0) {
			return p - ((char*)ptr);
		}

		*p = (unsigned char)byte;
		p++;
	}
	return p - ((char*)ptr);
}
