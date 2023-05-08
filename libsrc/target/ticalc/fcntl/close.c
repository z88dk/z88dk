// Empathic Qubit - Jan. 2023

#include <fcntl.h>
#include "ticalc_fcntl.h"

int close(int fd)
{
	TIFILE *file = &_ti_opened_files[fd];
	file->open = 0;

	return 0;
}
