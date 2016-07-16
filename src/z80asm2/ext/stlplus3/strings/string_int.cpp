////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_int.hpp"
#include <ctype.h>
#include <stdlib.h>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // character mappings

  static char to_char [] = "0123456789abcdefghijklmnopqrstuvwxyz";
  static int from_char [] = 
  {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, -1, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
  };

  ////////////////////////////////////////////////////////////////////////////////
  // Conversions to string
  // Local generic routines

  // signed version of the generic image generation function for all integer types
  template<typename T>
  static std::string simage (T i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    if (radix < 2 || radix > 36)
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    // untangle all the options
    bool hashed = false;
    bool binary = false;
    bool octal = false;
    bool hex = false;
    switch(display)
    {
    case radix_none:
      break;
    case radix_hash_style:
      hashed = radix != 10;
      break;
    case radix_hash_style_all:
      hashed = true;
      break;
    case radix_c_style:
      if (radix == 16)
        hex = true;
      else if (radix == 8)
        octal = true;
      else if (radix == 2)
        binary = true;
      break;
    case radix_c_style_or_hash:
      if (radix == 16)
        hex = true;
      else if (radix == 8)
        octal = true;
      else if (radix == 2)
        binary = true;
      else if (radix != 10)
        hashed = true;
      break;
    default:
      throw std::invalid_argument("invalid radix display value");
    }
    // create constants of the same type as the template parameter to avoid type mismatches
    const T t_zero(0);
    const T t_radix(radix);
    // the C representations for binary, octal and hex use 2's-complement representation
    // all other represenations use sign-magnitude
    std::string result;
    if (hex || octal || binary)
    {
      // bit-pattern representation
      // this is the binary representation optionally shown in octal or hex
      // first generate the binary by masking the bits
      // ensure that it has at least one bit!
      for (T mask(1); ; mask <<= 1)
      {
        result.insert((std::string::size_type)0, 1, i & mask ? '1' : '0');
        if (mask == t_zero) break;
      }
      // the result is now the full width of the type - e.g. int will give a 32-bit result
      // now interpret this as either binary, octal or hex and add the prefix
      if (binary)
      {
        // the result is already binary - but the width may be wrong
        // if this is still smaller than the width field, sign extend
        // otherwise trim down to either the width or the smallest string that preserves the value
        while (result.size() < width)
          result.insert((std::string::size_type)0, 1, result[0]);
        while (result.size() > width)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        // add the prefix
        result.insert((std::string::size_type)0, "0b");
      }
      else if (octal)
      {
        // the result is currently binary - but before converting get the width right
        // the width is expressed in octal digits so make the binary 3 times this
        // if this is still smaller than the width field, sign extend
        // otherwise trim down to either the width or the smallest string that preserves the value
        // also ensure that the binary is a multiple of 3 bits to make the conversion to octal easier
        while (result.size() < 3*width)
          result.insert((std::string::size_type)0, 1, result[0]);
        while (result.size() > 3*width)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        while (result.size() % 3 != 0)
          result.insert((std::string::size_type)0, 1, result[0]);
        // now convert to octal
        std::string octal_result;
        for (unsigned i = 0; i < result.size()/3; i++)
        {
          // yuck - ugly or what?
          if (result[i*3] == '0')
          {
            if (result[i*3+1] == '0')
            {
              if (result[i*3+2] == '0')
                octal_result += '0';
              else
                octal_result += '1';
            }
            else
            {
              if (result[i*3+2] == '0')
                octal_result += '2';
              else
                octal_result += '3';
            }
          }
          else
          {
            if (result[i*3+1] == '0')
            {
              if (result[i*3+2] == '0')
                octal_result += '4';
              else
                octal_result += '5';
            }
            else
            {
              if (result[i*3+2] == '0')
                octal_result += '6';
              else
                octal_result += '7';
            }
          }
        }
        result = octal_result;
        // add the prefix
        result.insert((std::string::size_type)0, "0");
      }
      else
      {
        // hex - similar to octal
        while (result.size() < 4*width)
          result.insert((std::string::size_type)0, 1, result[0]);
        while (result.size() > 4*width)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        while (result.size() % 4 != 0)
          result.insert((std::string::size_type)0, 1, result[0]);
        // now convert to hex
        std::string hex_result;
        for (unsigned i = 0; i < result.size()/4; i++)
        {
          // yuck - ugly or what?
          if (result[i*4] == '0')
          {
            if (result[i*4+1] == '0')
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '0';
                else
                  hex_result += '1';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += '2';
                else
                  hex_result += '3';
              }
            }
            else
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '4';
                else
                  hex_result += '5';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += '6';
                else
                  hex_result += '7';
              }
            }
          }
          else
          {
            if (result[i*4+1] == '0')
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '8';
                else
                  hex_result += '9';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += 'a';
                else
                  hex_result += 'b';
              }
            }
            else
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += 'c';
                else
                  hex_result += 'd';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += 'e';
                else
                  hex_result += 'f';
              }
            }
          }
        }
        result = hex_result;
        // add the prefix
        result.insert((std::string::size_type)0, "0x");
      }
    }
    else
    {
      // convert to sign-magnitude
      // the representation is:
      // [radix#][sign]magnitude
      bool negative = i < t_zero;
      // DJDM ensure that the initial value is positive, so that we don't have to use abs()
      // the reason I need to do this is that abs doesn't exist for 64-bit numbers (it's called something different)
      // and I've recently added support for long long (which is minimally 64 bit)
      if (negative)
        i = t_zero - i;
      // create a representation of the magnitude by successive division
      do
      {
//        T ch = abs(i % t_radix);
        T ch = i % t_radix;
        i /= t_radix;
        result.insert((std::string::size_type)0, 1, to_char[ch]);
      }
      while(i != t_zero || result.size() < width);
      // add the prefixes
      // add a sign only for negative values
      if (negative)
        result.insert((std::string::size_type)0, 1, '-');
      // then prefix everything with the radix if the hashed representation was requested
      if (hashed)
        result.insert((std::string::size_type)0, unsigned_to_string(radix) + "#");
    }
    return result;
  }

  // unsigned version
  template<typename T>
  static std::string uimage (T i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    if (radix < 2 || radix > 36)
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    // untangle all the options
    bool hashed = false;
    bool binary = false;
    bool octal = false;
    bool hex = false;
    switch(display)
    {
    case radix_none:
      break;
    case radix_hash_style:
      hashed = radix != 10;
      break;
    case radix_hash_style_all:
      hashed = true;
      break;
    case radix_c_style:
      if (radix == 16)
        hex = true;
      else if (radix == 8)
        octal = true;
      else if (radix == 2)
        binary = true;
      break;
    case radix_c_style_or_hash:
      if (radix == 16)
        hex = true;
      else if (radix == 8)
        octal = true;
      else if (radix == 2)
        binary = true;
      else if (radix != 10)
        hashed = true;
      break;
    default:
      throw std::invalid_argument("invalid radix display value");
    }
    // create constants of the same type as the template parameter to avoid type mismatches
    const T t_zero(0);
    const T t_radix(radix);
    // the C representations for binary, octal and hex use 2's-complement representation
    // all other represenations use sign-magnitude
    std::string result;
    if (hex || octal || binary)
    {
      // bit-pattern representation
      // this is the binary representation optionally shown in octal or hex
      // first generate the binary by masking the bits
      // ensure at least one bit
      for (T mask(1); ; mask <<= 1)
      {
        result.insert((std::string::size_type)0, 1, i & mask ? '1' : '0');
        if (mask == t_zero) break;
      }
      // the result is now the full width of the type - e.g. int will give a 32-bit result
      // now interpret this as either binary, octal or hex and add the prefix
      if (binary)
      {
        // the result is already binary - but the width may be wrong
        // if this is still smaller than the width field, zero extend
        // otherwise trim down to either the width or the smallest string that preserves the value
        while (result.size() < width)
          result.insert((std::string::size_type)0, 1, '0');
        while (result.size() > width)
        {
          // do not trim to less than 1 bit (1-bit magnitude)
          if (result.size() <= 1) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != '0') break;
          result.erase(0,1);
        }
        // add the prefix
        result.insert((std::string::size_type)0, "0b");
      }
      else if (octal)
      {
        // the result is currently binary - but before converting get the width right
        // the width is expressed in octal digits so make the binary 3 times this
        // if this is still smaller than the width field, sign extend
        // otherwise trim down to either the width or the smallest string that preserves the value
        // also ensure that the binary is a multiple of 3 bits to make the conversion to octal easier
        while (result.size() < 3*width)
          result.insert((std::string::size_type)0, 1, '0');
        while (result.size() > 3*width)
        {
          // do not trim to less than 1 bit (1-bit magnitude)
          if (result.size() <= 1) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != '0') break;
          result.erase(0,1);
        }
        while (result.size() % 3 != 0)
          result.insert((std::string::size_type)0, 1, '0');
        // now convert to octal
        std::string octal_result;
        for (unsigned i = 0; i < result.size()/3; i++)
        {
          // yuck - ugly or what?
          if (result[i*3] == '0')
          {
            if (result[i*3+1] == '0')
            {
              if (result[i*3+2] == '0')
                octal_result += '0';
              else
                octal_result += '1';
            }
            else
            {
              if (result[i*3+2] == '0')
                octal_result += '2';
              else
                octal_result += '3';
            }
          }
          else
          {
            if (result[i*3+1] == '0')
            {
              if (result[i*3+2] == '0')
                octal_result += '4';
              else
                octal_result += '5';
            }
            else
            {
              if (result[i*3+2] == '0')
                octal_result += '6';
              else
                octal_result += '7';
            }
          }
        }
        result = octal_result;
        // add the prefix if the leading digit is not already 0
        if (result.empty() || result[0] != '0') result.insert((std::string::size_type)0, "0");
      }
      else
      {
        // similar to octal
        while (result.size() < 4*width)
          result.insert((std::string::size_type)0, 1, '0');
        while (result.size() > 4*width)
        {
          // do not trim to less than 1 bit (1-bit magnitude)
          if (result.size() <= 1) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != '0') break;
          result.erase(0,1);
        }
        while (result.size() % 4 != 0)
          result.insert((std::string::size_type)0, 1, '0');
        // now convert to hex
        std::string hex_result;
        for (unsigned i = 0; i < result.size()/4; i++)
        {
          // yuck - ugly or what?
          if (result[i*4] == '0')
          {
            if (result[i*4+1] == '0')
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '0';
                else
                  hex_result += '1';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += '2';
                else
                  hex_result += '3';
              }
            }
            else
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '4';
                else
                  hex_result += '5';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += '6';
                else
                  hex_result += '7';
              }
            }
          }
          else
          {
            if (result[i*4+1] == '0')
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '8';
                else
                  hex_result += '9';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += 'a';
                else
                  hex_result += 'b';
              }
            }
            else
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += 'c';
                else
                  hex_result += 'd';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += 'e';
                else
                  hex_result += 'f';
              }
            }
          }
        }
        result = hex_result;
        // add the prefix
        result.insert((std::string::size_type)0, "0x");
      }
    }
    else
    {
      // convert to sign-magnitude
      // the representation is:
      // [radix#]magnitude
      // create a representation of the magnitude by successive division
      do
      {
        T ch = i % t_radix;
        i /= t_radix;
        result.insert((std::string::size_type)0, 1, to_char[(int)ch]);
      }
      while(i != t_zero || result.size() < width);
      // prefix everything with the radix if the hashed representation was requested
      if (hashed)
        result.insert((std::string::size_type)0, unsigned_to_string(radix) + "#");
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // exported conversions to string

  std::string short_to_string(short i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return simage(i, radix, display, width);
  }

  std::string unsigned_short_to_string(unsigned short i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return uimage(i, radix, display, width);
  }

  std::string int_to_string(int i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return simage(i, radix, display, width);
  }

  std::string unsigned_to_string(unsigned i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return uimage(i, radix, display, width);
  }

  std::string long_to_string(long i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return simage(i, radix, display, width);
  }

  std::string unsigned_long_to_string(unsigned long i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return uimage(i, radix, display, width);
  }

#ifdef CXX11
  std::string longlong_to_string(long long i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return simage(i, radix, display, width);
  }

  std::string unsigned_longlong_to_string(unsigned long long i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return uimage(i, radix, display, width);
  }
#endif

  std::string address_to_string(const void* i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return simage((std::ptrdiff_t)i, radix, display, width);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Conversions FROM string
  // local template function
  // Note: this has been copied and modified for the inf class - so any changes here must be made there too

  // signed version
  template<typename T>
  static T svalue(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    if (radix != 0 && (radix < 2 || radix > 36))
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    std::string::size_type i = 0;
    // the radix passed as a parameter is just the default - it can be
    // overridden by either the C prefix or the hash prefix. Note: a leading zero
    // is the C-style prefix for octal - I only make this override the default
    // when the default prefix is not specified
    // First check for a C-style prefix
    bool c_style = false;
    if (i < str.size() && str[i] == '0')
    {
      // octal, binary or hex
      if (i+1 < str.size() && tolower(str[i+1]) == 'x')
      {
        radix = 16;
        i += 2;
        c_style = true;
      }
      else if (i+1 < str.size() && tolower(str[i+1]) == 'b')
      {
        radix = 2;
        i += 2;
        c_style = true;
      }
      else if (radix == 0)
      {
        radix = 8;
        i += 1;
        c_style = true;
      }
    }
    // now check for a hash-style prefix if a C-style prefix was not found
    if (i == 0)
    {
      // scan for the sequence {digits}#
      bool hash_found = false;
      std::string::size_type j = i;
      for (; j < str.size(); j++)
      {
        if (!isdigit(str[j]))
        {
          if (str[j] == '#')
            hash_found = true;
          break;
        }
      }
      if (hash_found)
      {
        // use the hash prefix to define the radix
        // i points to the start of the radix and j points to the # character
        std::string slice = str.substr(i, j-i);
        radix = string_to_unsigned(slice);
        i = j+1;
      }
    }
    if (radix == 0)
      radix = 10;
    if (radix < 2 || radix > 36)
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    T val(0);
    if (c_style)
    {
      // the C style formats are bit patterns not integer values - these need
      // to be sign-extended to get the right value
      std::string binary;
      if (radix == 2)
      {
        for (std::string::size_type j = i; j < str.size(); j++)
        {
          switch(str[j])
          {
          case '0':
            binary += '0';
            break;
          case '1':
            binary += '1';
            break;
          default:
            throw std::invalid_argument("invalid binary character in string " + str);
            break;
          }
        }
      }
      else if (radix == 8)
      {
        for (std::string::size_type j = i; j < str.size(); j++)
        {
          switch(str[j])
          {
          case '0':
            binary += "000";
            break;
          case '1':
            binary += "001";
            break;
          case '2':
            binary += "010";
            break;
          case '3':
            binary += "011";
            break;
          case '4':
            binary += "100";
            break;
          case '5':
            binary += "101";
            break;
          case '6':
            binary += "110";
            break;
          case '7':
            binary += "111";
            break;
          default:
            throw std::invalid_argument("invalid octal character in string " + str);
            break;
          }
        }
      }
      else
      {
        for (std::string::size_type j = i; j < str.size(); j++)
        {
          switch(tolower(str[j]))
          {
          case '0':
            binary += "0000";
            break;
          case '1':
            binary += "0001";
            break;
          case '2':
            binary += "0010";
            break;
          case '3':
            binary += "0011";
            break;
          case '4':
            binary += "0100";
            break;
          case '5':
            binary += "0101";
            break;
          case '6':
            binary += "0110";
            break;
          case '7':
            binary += "0111";
            break;
          case '8':
            binary += "1000";
            break;
          case '9':
            binary += "1001";
            break;
          case 'a':
            binary += "1010";
            break;
          case 'b':
            binary += "1011";
            break;
          case 'c':
            binary += "1100";
            break;
          case 'd':
            binary += "1101";
            break;
          case 'e':
            binary += "1110";
            break;
          case 'f':
            binary += "1111";
            break;
          default:
            throw std::invalid_argument("invalid hex character in string " + str);
            break;
          }
        }
      }
      // now sign-extend to the right number of bits for the type
      while (binary.size() < sizeof(T)*8)
        binary.insert((std::string::size_type)0, 1, binary.empty() ? '0' : binary[0]);
      // now convert the value
      for (std::string::size_type j = 0; j < binary.size(); j++)
      {
        val *= 2;
        int ch = from_char[(unsigned char)binary[j]] ;
        val += T(ch);
      }
    }
    else
    {
      // now scan for a sign and find whether this is a negative number
      bool negative = false;
      if (i < str.size())
      {
        switch (str[i])
        {
        case '-':
          negative = true;
          i++;
          break;
        case '+':
          i++;
          break;
        }
      }
      for (; i < str.size(); i++)
      {
        val *= T(radix);
        int ch = from_char[(unsigned char)str[i]] ;
        if (ch == -1 || (unsigned)ch >= radix)
          throw std::invalid_argument("invalid character in string " + str);
        val += T(ch);
      }
      if (negative)
        val = -val;
    }
    return val;
  }

  // unsigned version
  template<typename T>
  static T uvalue(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    if (radix != 0 && (radix < 2 || radix > 36))
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    unsigned i = 0;
    // the radix passed as a parameter is just the default - it can be
    // overridden by either the C prefix or the hash prefix. Note: a leading
    // zero is the C-style prefix for octal - I only make this override the
    // default when the default prefix is not specified
    // First check for a C-style prefix
    bool c_style = false;
    if (i < str.size() && str[i] == '0')
    {
      // binary or hex
      if (i+1 < str.size() && tolower(str[i+1]) == 'x')
      {
        radix = 16;
        i += 2;
        c_style = true;
      }
      else if (i+1 < str.size() && tolower(str[i+1]) == 'b')
      {
        radix = 2;
        i += 2;
        c_style = true;
      }
      else if (radix == 0)
      {
        radix = 8;
        i += 1;
        c_style = true;
      }
    }
    // now check for a hash-style prefix if a C-style prefix was not found
    if (i == 0)
    {
      // scan for the sequence {digits}#
      bool hash_found = false;
      unsigned j = i;
      for (; j < str.size(); j++)
      {
        if (!isdigit(str[j]))
        {
          if (str[j] == '#')
            hash_found = true;
          break;
        }
      }
      if (hash_found)
      {
        // use the hash prefix to define the radix
        // i points to the start of the radix and j points to the # character
        std::string slice = str.substr(i, j-i);
        radix = string_to_unsigned(slice);
        i = j+1;
      }
    }
    if (radix == 0)
      radix = 10;
    if (radix < 2 || radix > 36)
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    T val(0);
    if (c_style)
    {
      // the C style formats are bit patterns not integer values - these need
      // to be sign-extended to get the right value
      std::string binary;
      if (radix == 2)
      {
        for (unsigned j = i; j < str.size(); j++)
        {
          switch(str[j])
          {
          case '0':
            binary += '0';
            break;
          case '1':
            binary += '1';
            break;
          default:
            throw std::invalid_argument("invalid hex character in string " + str);
            break;
          }
        }
      }
      else if (radix == 8)
      {
        for (unsigned j = i; j < str.size(); j++)
        {
          switch(str[j])
          {
          case '0':
            binary += "000";
            break;
          case '1':
            binary += "001";
            break;
          case '2':
            binary += "010";
            break;
          case '3':
            binary += "011";
            break;
          case '4':
            binary += "100";
            break;
          case '5':
            binary += "101";
            break;
          case '6':
            binary += "110";
            break;
          case '7':
            binary += "111";
            break;
          default:
            throw std::invalid_argument("invalid octal character in string " + str);
            break;
          }
        }
      }
      else
      {
        for (unsigned j = i; j < str.size(); j++)
        {
          switch(tolower(str[j]))
          {
          case '0':
            binary += "0000";
            break;
          case '1':
            binary += "0001";
            break;
          case '2':
            binary += "0010";
            break;
          case '3':
            binary += "0011";
            break;
          case '4':
            binary += "0100";
            break;
          case '5':
            binary += "0101";
            break;
          case '6':
            binary += "0110";
            break;
          case '7':
            binary += "0111";
            break;
          case '8':
            binary += "1000";
            break;
          case '9':
            binary += "1001";
            break;
          case 'a':
            binary += "1010";
            break;
          case 'b':
            binary += "1011";
            break;
          case 'c':
            binary += "1100";
            break;
          case 'd':
            binary += "1101";
            break;
          case 'e':
            binary += "1110";
            break;
          case 'f':
            binary += "1111";
            break;
          default:
            throw std::invalid_argument("invalid hex character in string " + str);
            break;
          }
        }
      }
      // now zero-extend to the right number of bits for the type
      while (binary.size() < sizeof(T)*8)
        binary.insert((std::string::size_type)0, 1, '0');
      // now convert the value
      for (unsigned j = 0; j < binary.size(); j++)
      {
        val *= 2;
        int ch = from_char[(unsigned char)binary[j]] ;
        val += T(ch);
      }
    }
    else
    {
      // now scan for a sign and find whether this is a negative number
      if (i < str.size())
      {
        switch (str[i])
        {
        case '-':
          throw std::invalid_argument("invalid sign character in string " + str + " for unsigned value");
          i++;
          break;
        case '+':
          i++;
          break;
        }
      }
      for (; i < str.size(); i++)
      {
        val *= T(radix);
        int ch = from_char[(unsigned char)str[i]] ;
        if (ch == -1 || (unsigned)ch >= radix)
        {
          throw std::invalid_argument("invalid character in string " + str);
        }
        val += T(ch);
      }
    }
    return val;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // exported functions

  short string_to_short(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return svalue<short>(str, radix);
  }

  unsigned short string_to_unsigned_short(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return uvalue<unsigned short>(str, radix);
  }

  int string_to_int(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return svalue<int>(str, radix);
  }

  unsigned string_to_unsigned(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return uvalue<unsigned>(str, radix);
  }

  long string_to_long(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return svalue<long>(str, radix);
  }

  unsigned long string_to_unsigned_long(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return uvalue<unsigned long>(str, radix);
  }

  void* string_to_address(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return (void*)svalue<std::ptrdiff_t>(str, radix);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
