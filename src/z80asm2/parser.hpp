//-----------------------------------------------------------------------------
// Parse asm code
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef PARSER_HPP
#define PARSER_HPP

#include "module.hpp"

extern bool parse_line(Module& module, unsigned file_id, unsigned line_nr, 
					   const char *line);					   

#endif /* ndef PARSER_HPP */
