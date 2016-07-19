//-----------------------------------------------------------------------------
// Global data
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "global.hpp"
#include <iostream>

// information and error messages channels
stlplus::message_handler g_messages(std::cout);
stlplus::message_handler g_errors(std::cerr);
