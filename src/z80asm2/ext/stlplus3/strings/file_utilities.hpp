#ifndef STLPLUS_FILE_UTILITIES
#define STLPLUS_FILE_UTILITIES
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Andy Rushton           2013 onwards
//   License:   BSD License, see ../docs/license.html

//   Short-cut functions for managing text files

////////////////////////////////////////////////////////////////////////////////

#include "strings_fixes.hpp"
#include <string>
#include <vector>
#include <iostream>
#include <stdexcept>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{
  // text is a sequence of lines separated by EOFs
  // it is represented in memory as a vector of strings
  typedef std::vector<std::string> text;

  // read text from any istream
  text read_text(std::istream& device);
  // read text from a file, given the filename
  // throws an exception if the file does not exist
  text read_text(std::string filename) throw(std::invalid_argument);

  // write text to any ostream
  bool write_text(const text& file, std::ostream& device);
  // write text to a file, given the filename
  // throws an exception if the file could not be created
  bool write_text(const text& file, std::string filename) throw(std::invalid_argument);

}

#endif
