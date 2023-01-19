// Empathic Qubit - Jan. 2023

#include <fcntl.h>
#include "ticalc_fcntl.h"

long fdtell(int handle)
{
	TIFILE *file = &_ti_opened_files[handle];
	if(!file->open) {
		return -1;
	}

	return file->position;
}
