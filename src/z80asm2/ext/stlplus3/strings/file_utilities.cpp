////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Andy Rushton           2013 onwards
//   License:   BSD License, see ../docs/license.html

//   Short-cut functions for managing text files

////////////////////////////////////////////////////////////////////////////////

#include "file_utilities.hpp"
#include <fstream>

////////////////////////////////////////////////////////////////////////////////

stlplus::text stlplus::read_text(std::istream& device)
{
  stlplus::text result;
  while (!device.eof())
  {
    std::string line;
    getline(device, line);
    result.push_back(line);
  }
  return result;
}

stlplus::text stlplus::read_text(std::string filename) throw(std::invalid_argument)
{
  std::ifstream input(filename.c_str());
  if (input.fail())
    throw std::invalid_argument("failed to open file " + filename);
  return read_text(input);
}

bool stlplus::write_text(const stlplus::text& file, std::ostream& device)
{
  for (stlplus::text::const_iterator i = file.begin(); i != file.end(); i++)
    device << *i << std::endl;
  return true;
}

bool stlplus::write_text(const stlplus::text& file, std::string filename) throw(std::invalid_argument)
{
  std::ofstream device(filename.c_str());
  if (device.fail())
    throw std::invalid_argument("failed to open file " + filename);
  return write_text(file, device);
}

////////////////////////////////////////////////////////////////////////////////
