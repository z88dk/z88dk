//-----------------------------------------------------------------------------
// Main executable for z80asm
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include "dummy.hpp"

int main(int argc, char *argv[])
{
	std::cout << "The answer is " << dummy() << std::endl;
	return dummy()==42 ? 0 : -1;
}
