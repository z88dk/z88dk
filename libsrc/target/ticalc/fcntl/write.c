#include <sys/types.h>
#include <fcntl.h>
#include <errno.h>

#include "ticalc_fcntl.h"

ssize_t write(int fd, void *ptr, size_t len)
{
	TIFILE *file = &_ti_opened_files[fd];
	if(file->mode == O_RDONLY || file->page) {
		errno = EACCES;
		return -1;
	}

	unsigned int new_size = file->position + len;
	if(new_size > file->size) {
		if(_ti_insert_mem(file->ref + file->size, new_size - file->size)) {
			*(unsigned int*)(file->ref - 2) = file->size = new_size;
		}
	}

	unsigned char *p = ptr;
	for(; len > 0; len--) {
		if(writebyte(fd, *p) != 0) {
			return p - ((char*)ptr);
		}
		p++;
	}

	return p - ((char*)ptr);
}
