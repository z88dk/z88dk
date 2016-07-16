#ifndef STLPLUS_STRING_UTILITIES
#define STLPLUS_STRING_UTILITIES
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Utilities for manipulating std::strings

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "format_types.hpp"
#include <vector>
#include <string>
#include <stdexcept>
#include <time.h>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Padding function allows a string to be printed in a fixed-width field
  ////////////////////////////////////////////////////////////////////////////////

  // The definitions for the alignment are declared in format_types.hpp
  // Any other value will cause std::invalid_argument to be thrown

  std::string pad(const std::string& str,
                  alignment_t alignment,
                  unsigned width,
                  char padch = ' ')
    throw(std::invalid_argument);

  ////////////////////////////////////////////////////////////////////////////////
  // whitespace trimming
  ////////////////////////////////////////////////////////////////////////////////

  std::string trim_left(const std::string& val);
  std::string trim_right(const std::string& val);
  std::string trim(const std::string& val);

  ////////////////////////////////////////////////////////////////////////////////
  // case conversion for std::strings
  ////////////////////////////////////////////////////////////////////////////////

  std::string lowercase(const std::string& val);
  std::string uppercase(const std::string& val);

  ////////////////////////////////////////////////////////////////////////////////
  // character translation - inspired by Unix 'tr' command
  ////////////////////////////////////////////////////////////////////////////////

  // convert characters represented in from_set to the characters in the same position in to_set
  // for example:
  //   filename = translate(filename,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  // converts the filename to uppercase and returns the result (Note that the
  // uppercase function does this more easily). If the from_set is longer than
  // the to_set, then the overlap represents characters to delete (i.e. they map
  // to nothing)

  std::string translate(const std::string& input,
                        const std::string& from_set,
                        const std::string& to_set = std::string());

  ////////////////////////////////////////////////////////////////////////////////
  // wildcard matching
  ////////////////////////////////////////////////////////////////////////////////

  // this function does wildcard matching of the wildcard expression against the candidate std::string
  // wildcards are NOT regular expressions
  // the wildcard characters are * and ? where * matches 1 or more characters and ? matches only one
  // there are also character sets [a-z] [qwertyuiop] etc. which match 1 character
  // TODO: character sets like [:alpha:]
  // TODO eventually: regular expression matching and substitution (3rd party library?)

  bool match_wildcard(const std::string& wild,
                      const std::string& match);

  ////////////////////////////////////////////////////////////////////////////////
  // Perl-inspired split/join functions
  ////////////////////////////////////////////////////////////////////////////////

  // splits the string at every occurance of splitter and adds it as a separate string to the return value
  // the splitter is removed
  // a string with no splitter in it will give a single-value vector
  // an empty string gives an empty vector

  std::vector<std::string> split (const std::string& str,
                                  const std::string& splitter = "\n");

  // the reverse of the above
  // joins the string vector to create a single string with the joiner inserted between the joins
  // Note: the joiner will not be added at the beginning or the end
  // However, there are optional fields to add such prefix and suffix strings

  std::string join (const std::vector<std::string>&,
                    const std::string& joiner = "\n",
                    const std::string& prefix = "",
                    const std::string& suffix = "");

  ////////////////////////////////////////////////////////////////////////////////
  // special displays
  ////////////////////////////////////////////////////////////////////////////////

  // display the parameter as a number in bytes, kbytes, Mbytes, Gbytes depending on range

  std::string display_bytes(long bytes);

  // display the parameter in seconds as a string representation in weeks, days, hours, minutes, seconds
  // e.g. "1d 1:01:01" means 1 day, 1 hour, 1 minute and 1 second

  std::string display_time(time_t seconds);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
