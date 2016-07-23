//-----------------------------------------------------------------------------
// re2c source to parse command line arguments
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

/*!max:re2c*/
/*!types:re2c*/

#include <iostream>
#include <fstream>
#include <string>
#include "cmdline.hpp"
#include "messages.hpp"
#include "util.hpp"

static void usage()
{
	g_messages.information(MES_COPYRIGHT);
	g_messages.plaintext("");
	g_messages.information(MES_USAGE);
}

static void help()
{
	g_messages.information(MES_COPYRIGHT);
	g_messages.plaintext("");
	g_messages.information(MES_USAGE);
	g_messages.plaintext("");
	g_messages.information(MES_HELP);
}

// append a file or the list of files from a '@'-list into the passed vector
static bool insert_file(std::string filename, 
						std::vector<std::string> & list)
{
	std::size_t size = filename.size();
	char prefix = (size == 0) ? '\0' : filename[0];
	
	if (size == 0 || prefix == '#' || prefix == ';') {
		// ignore
	}
	else if (prefix == '@') {
		filename.erase(0, 1);					// remove '@'
		
		std::ifstream file(filename.c_str());	// open list file
		if (!file.good()) {
			g_errors.error(ERR_READ_FILE, filename);
			return false;
		}
		else {
			std::string line;
			unsigned line_nr = 0;
			unsigned col_nr = 1;
			while (safeGetline(file, line)) {
				line_nr++;
				stlplus::message_position pos(filename, line_nr, col_nr);
				g_errors.push_context(pos, ERR_READ_CONTEXT, filename);
				insert_file(line, list);
				g_errors.pop_context();
			}
		}
	}
	else {
		list.push_back(filename);
	}
	
	return true;
}

// parse command line, accumulate arguments and options in out_args
// return false if no further processing should be done - error or usage/help
bool parse_cmdline(int argc, char *argv[], args_t& out_args)
{
	int arg;
	
	if (argc <= 1) {
		usage();
		return false;
	}

	// parse each argument
	int cond = yycinit;
	for (arg = 1; arg < argc; arg++) {
		const char *YYCURSOR = argv[arg];
		const char *YYMARKER;
		//const char *YYCTXMARKER;
		/*!re2c
			re2c:define:YYCTYPE = char;
			re2c:yyfill:enable = 0;
			re2c:define:YYGETCONDITION = "cond";
			re2c:define:YYGETCONDITION:naked = 1;
			re2c:define:YYSETCONDITION = "cond = @@;";
			re2c:define:YYSETCONDITION:naked = 1;
			re2c:indent:string = "\t\t\t";
			
			end = "\x00";
			
			<*> * 		{ 	g_errors.error(ERR_INVALID_OPTION, argv[arg]); 
							return false; 
						}
			
			<init> "-h"     end 
				 | "--help" end	
						{ 	help(); 
							return false; 
						}
						
			<init> "-"	{ 	g_errors.error(ERR_INVALID_OPTION, argv[arg]); 
							return false; 
						}
				
			<init> .	{ 	if (!insert_file(YYCURSOR - 1, out_args.files))
								return false;
							continue; 
						}
			
		*/
	}
	return true;
}
