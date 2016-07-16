//-----------------------------------------------------------------------------
// Dummy module test
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.hpp"
#include "dummy.hpp"

int main() 
{
	is(dummy(), 42);
	
	done_testing();
	return exit_status();
}
