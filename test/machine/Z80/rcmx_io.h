#ifndef RCMX_IO__H
#define RCMX_IO__H

#include "Z80.h"

void rcmx_io_init();

byte rcmx_io_internal_in(word A);

byte rcmx_io_external_in(word A);

void rcmx_io_internal_out(word A, byte V);

void rcmx_io_external_out(word A, byte V);

#endif
