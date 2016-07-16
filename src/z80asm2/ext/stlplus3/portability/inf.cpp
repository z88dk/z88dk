////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   The integer is represented as a sequence of bytes. They are stored such that
//   element 0 is the lsB, which makes sense when seen as an integer offset but
//   is counter-intuitive when you think that a string is usually read from left
//   to right, 0 to size-1, in which case the lsB is on the *left*.

//   This solution is compatible with 32-bit and 64-bit machines with either
//   little-endian or big-endian representations of integers.

//   Problem: I'm using std::string, which is an array of char. However, char is
//   not well-defined - it could be signed or unsigned.

//   In fact, there's no requirement for a char to even be one byte - it can be
//   any size of one byte or more. However, it's just impossible to make any
//   progress with that naffness (thanks to the C non-standardisation committee)
//   and the practice is that char on every platform/compiler I've ever come
//   across is that char = byte.

//   The algorithms here use unsigned char to represent bit-patterns so I have to
//   be careful to type-cast from char to unsigned char a lot. I use a typedef to
//   make life easier.

////////////////////////////////////////////////////////////////////////////////
#include "inf.hpp"
#include <ctype.h>
////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // choose a sensible C type for a byte

  typedef unsigned char byte;

  ////////////////////////////////////////////////////////////////////////////////
  // local functions

  // removes leading bytes that don't contribute to the value to create the minimum string representation
  static void reduce_string(std::string& data)
  {
    while(data.size() > 1 && 
          ((byte(data[data.size()-1]) == byte(0) && byte(data[data.size()-2]) < byte(128)) ||
           (byte(data[data.size()-1]) == byte(255) && byte(data[data.size()-2]) >= byte(128))))
    {
      data.erase(data.end()-1);
    }
  }

  // generic implementations of type conversions from integer type to internal representation
  // data: integer value for conversion
  // result: internal representation

  template <typename T>
  static void convert_from_signed(const T& data, std::string& result)
  {
    result.erase();
    bool lsb_first = little_endian();
    byte* address = (byte*)&data;
    for (size_t i = 0; i < sizeof(T); i++)
    {
      size_t offset = (lsb_first ? i : (sizeof(T) - i - 1));
      result.append(1,address[offset]);
    }
    reduce_string(result);
  }

  template <typename T>
  static void convert_from_unsigned(const T& data, std::string& result)
  {
    result.erase();
    bool lsb_first = little_endian();
    byte* address = (byte*)&data;
    for (size_t i = 0; i < sizeof(T); i++)
    {
      size_t offset = (lsb_first ? i : (sizeof(T) - i - 1));
      result.append(1,address[offset]);
    }
    // inf is signed - so there is a possible extra sign bit to add
    result.append(1,std::string::value_type(0));
    reduce_string(result);
  }

  // generic implementations of type conversions from internal representation to an integer type
  // data : string representation of integer
  // result: integer result of conversion
  // return: flag indicating success - false = overflow

  template <class T>
  bool convert_to_signed(const std::string& data, T& result)
  {
    bool lsb_first = little_endian();
    byte* address = (byte*)&result;
    for (size_t i = 0; i < sizeof(T); i++)
    {
      size_t offset = lsb_first ? i : (sizeof(T) - i - 1);
      if (i < data.size())
        address[offset] = byte(data[i]);
      else if (data.empty() || (byte(data[data.size()-1]) < byte(128)))
        address[offset] = byte(0);
      else
        address[offset] = byte(255);
    }
    return data.size() <= sizeof(T);
  }

  template <class T>
  bool convert_to_unsigned(const std::string& data, T& result)
  {
    bool lsb_first = little_endian();
    byte* address = (byte*)&result;
    for (size_t i = 0; i < sizeof(T); i++)
    {
      size_t offset = lsb_first ? i : (sizeof(T) - i - 1);
      if (i < data.size())
        address[offset] = byte(data[i]);
      else
        address[offset] = byte(0);
    }
    return data.size() <= sizeof(T);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Conversions to string

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

  static void convert_to_string(const stlplus::inf& data, std::string& result, unsigned radix = 10)
    throw(std::invalid_argument)
  {
    // only support the C-style radixes plus 0b for binary
    if (radix != 2 && radix != 8 && radix != 10 && radix != 16)
      throw std::invalid_argument("invalid radix value");
    inf local_i = data;
    // untangle all the options
    bool binary = radix == 2;
    bool octal = radix == 8;
    bool hex = radix == 16;
    // the C representations for binary, octal and hex use 2's-complement representation
    // all other represenations use sign-magnitude
    if (hex || octal || binary)
    {
      // bit-pattern representation
      // this is the binary representation optionally shown in octal or hex
      // first generate the binary by masking the bits
      for (unsigned j = local_i.bits(); j--; )
        result += (local_i.bit(j) ? '1' : '0');
      // the result is now the full width of the type - e.g. int will give a 32-bit result
      // now interpret this as either binary, octal or hex and add the prefix
      if (binary)
      {
        // trim down to the smallest string that preserves the value
        while (true)
        {
          // do not trim to less than 1 bit (sign only)
          if (result.size() <= 1) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        // add the prefix
        result.insert((std::string::size_type)0, "0b");
      }
      else if (octal)
      {
        // the result is currently binary
        // trim down to the smallest string that preserves the value
        while (true)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        // also ensure that the binary is a multiple of 3 bits to make the conversion to octal easier
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
        // similar to octal
        while (true)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        // pad to a multiple of 4 characters
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
      // [sign]magnitude
      bool negative = local_i.negative();
      local_i.abs();
      // create a representation of the magnitude by successive division
      inf inf_radix(radix);
      do
      {
        std::pair<inf,inf> divided = local_i.divide(inf_radix);
        unsigned remainder = divided.second.to_unsigned();
        char digit = to_char[remainder];
        result.insert((std::string::size_type)0, 1, digit);
        local_i = divided.first;
      }
      while(!local_i.zero());
      // add the prefixes
      // add a sign only for negative values
      if (negative)
        result.insert((std::string::size_type)0, 1, '-');
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Conversions FROM string

  void convert_from_string(const std::string& str, inf& result, unsigned radix = 10) throw(std::invalid_argument)
  {
    result = 0;
    // only support the C-style radixes plus 0b for binary
    // a radix of 0 means deduce the radix from the input - assume 10
    if (radix != 0 && radix != 2 && radix != 8 && radix != 10 && radix != 16)
      throw std::invalid_argument("invalid radix value");
    unsigned i = 0;
    // the radix passed as a parameter is just the default - it can be
    // overridden by the C prefix
    // Note: a leading zero is the C-style prefix for octal - I only make this
    // override the default when the default radix is not specified
    // first check for a C-style prefix
    bool c_style = false;
    if (i < str.size() && str[i] == '0')
    {
      // binary or hex
      if (i+1 < str.size() && tolower(str[i+1]) == 'x')
      {
        c_style = true;
        radix = 16;
        i += 2;
      }
      else if (i+1 < str.size() && tolower(str[i+1]) == 'b')
      {
        c_style = true;
        radix = 2;
        i += 2;
      }
      else if (radix == 0)
      {
        c_style = true;
        radix = 8;
        i += 1;
      }
    }
    if (radix == 0)
      radix = 10;
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
            throw std::invalid_argument("invalid binary character in string " + str);
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
          }
        }
      }
      // now convert the value
      result.resize(static_cast<unsigned>(binary.size()));
      for (unsigned j = 0; j < binary.size(); j++)
        result.preset(static_cast<unsigned>(binary.size()) - j - 1, binary[j] == '1');
    }
    else
    {
      // sign-magnitude representation
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
        result *= inf(radix);
        unsigned char ascii = (unsigned char)str[i];
        int ch = from_char[ascii] ;
        if (ch == -1)
          throw std::invalid_argument("invalid decimal character in string " + str);
        result += inf(ch);
      }
      if (negative)
        result.negate();
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
  // constructors - mostly implemented in terms of the assignment operators

  inf::inf(void)
  {
    // void constructor initialises to zero - represented as a single-byte value containing zero
    m_data.append(1,std::string::value_type(0));
  }

  inf::inf(short r)
  {
    operator=(r);
  }

  inf::inf(unsigned short r)
  {
    operator=(r);
  }

  inf::inf(int r)
  {
    operator=(r);
  }

  inf::inf(unsigned r)
  {
    operator=(r);
  }

  inf::inf(long r)
  {
    operator=(r);
  }

  inf::inf(unsigned long r)
  {
    operator=(r);
  }

  inf::inf (const std::string& r) throw(std::invalid_argument)
  {
    operator=(r);
  }

  inf::inf(const inf& r)
  {
#ifdef __BORLANDC__
    // work round bug in Borland compiler - copy constructor fails if string
    // contains null characters, so do my own copy
    for (unsigned i = 0; i < r.m_data.size(); i++)
      m_data += r.m_data[i];
#else
    m_data = r.m_data;
#endif
  }

  ////////////////////////////////////////////////////////////////////////////////

  inf::~inf(void)
  {
  }

  ////////////////////////////////////////////////////////////////////////////////
  // assignments convert from iteger types to internal representation

  inf& inf::operator = (short r)
  {
    convert_from_signed(r, m_data);
    return *this;
  }

  inf& inf::operator = (unsigned short r)
  {
    convert_from_unsigned(r, m_data);
    return *this;
  }

  inf& inf::operator = (int r)
  {
    convert_from_signed(r, m_data);
    return *this;
  }

  inf& inf::operator = (unsigned r)
  {
    convert_from_unsigned(r, m_data);
    return *this;
  }

  inf& inf::operator = (long r)
  {
    convert_from_signed(r, m_data);
    return *this;
  }

  inf& inf::operator = (unsigned long r)
  {
    convert_from_unsigned(r, m_data);
    return *this;
  }

  inf& inf::operator = (const std::string& r) throw(std::invalid_argument)
  {
    convert_from_string(r, *this);
    return *this;
  }

  inf& inf::operator = (const inf& r)
  {
    m_data = r.m_data;
    return *this;
  }

  ////////////////////////////////////////////////////////////////////////////////

  short inf::to_short(bool truncate) const throw(std::overflow_error)
  {
    short result = 0;
    if (!convert_to_signed(m_data, result))
      if (!truncate)
        throw std::overflow_error("stlplus::inf::to_short");
    return result;
  }

  unsigned short inf::to_unsigned_short(bool truncate) const throw(std::overflow_error)
  {
    unsigned short result = 0;
    if (!convert_to_unsigned(m_data, result))
      if (!truncate)
        throw std::overflow_error("stlplus::inf::to_unsigned_short");
    return result;
  }

  int inf::to_int(bool truncate) const throw(std::overflow_error)
  {
    int result = 0;
    if (!convert_to_signed(m_data, result))
      if (!truncate)
        throw std::overflow_error("stlplus::inf::to_int");
    return result;
  }

  unsigned inf::to_unsigned(bool truncate) const throw(std::overflow_error)
  {
    unsigned result = 0;
    if (!convert_to_unsigned(m_data, result))
      if (!truncate)
        throw std::overflow_error("stlplus::inf::to_unsigned");
    return result;
  }

  long inf::to_long(bool truncate) const throw(std::overflow_error)
  {
    long result = 0;
    if (!convert_to_signed(m_data, result))
      if (!truncate)
        throw std::overflow_error("stlplus::inf::to_long");
    return result;
  }

  unsigned long inf::to_unsigned_long(bool truncate) const throw(std::overflow_error)
  {
    unsigned long result = 0;
    if (!convert_to_unsigned(m_data, result))
      if (!truncate)
        throw std::overflow_error("stlplus::inf::to_unsigned_long");
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // resize the inf regardless of the data

  void inf::resize(unsigned bits)
  {
    if (bits == 0) bits = 1;
    unsigned bytes = (bits+7)/8;
    byte extend = negative() ? byte(255) : byte (0);
    while(bytes > m_data.size())
      m_data.append(1,extend);
  }

  // reduce the bit count to the minimum needed to preserve the value

  void inf::reduce(void)
  {
    reduce_string(m_data);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // the number of significant bits in the number

  unsigned inf::bits (void) const
  {
    // The number of significant bits in the integer value - this is the number
    // of indexable bits less any redundant sign bits at the msb
    // This does not assume that the inf has been reduced to its minimum form
    unsigned result = indexable_bits();
    bool sign = bit(result-1);
    while (result > 1 && (sign == bit(result-2)))
      result--;
    return result;
  }

  unsigned inf::size(void) const
  {
    return bits();
  }

  unsigned inf::indexable_bits (void) const
  {
    return 8 * unsigned(m_data.size());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // bitwise operations

  bool inf::bit (unsigned index) const throw(std::out_of_range)
  {
    if (index >= indexable_bits())
      throw std::out_of_range(std::string("stlplus::inf::bit"));
    // first split the offset into byte offset and bit offset
    unsigned byte_offset = index/8;
    unsigned bit_offset = index%8;
    return (byte(m_data[byte_offset]) & (byte(1) << bit_offset)) != 0;
  }

  bool inf::operator [] (unsigned index) const throw(std::out_of_range)
  {
    return bit(index);
  }

  void inf::set (unsigned index)  throw(std::out_of_range)
  {
    if (index >= indexable_bits())
      throw std::out_of_range(std::string("stlplus::inf::set"));
    // first split the offset into byte offset and bit offset
    unsigned byte_offset = index/8;
    unsigned bit_offset = index%8;
    m_data[byte_offset] |= (byte(1) << bit_offset);
  }

  void inf::clear (unsigned index)  throw(std::out_of_range)
  {
    if (index >= indexable_bits())
      throw std::out_of_range(std::string("stlplus::inf::clear"));
    // first split the offset into byte offset and bit offset
    unsigned byte_offset = index/8;
    unsigned bit_offset = index%8;
    m_data[byte_offset] &= (~(byte(1) << bit_offset));
  }

  void inf::preset (unsigned index, bool value)  throw(std::out_of_range)
  {
    if (value)
      set(index);
    else
      clear(index);
  }

  inf inf::slice(unsigned low, unsigned high) const throw(std::out_of_range)
  {
    if (low >= indexable_bits())
      throw std::out_of_range(std::string("stlplus::inf::slice: low index"));
    if (high >= indexable_bits())
      throw std::out_of_range(std::string("stlplus::inf::slice: high index"));
    inf result;
    if (high >= low)
    {
      // create a result the right size and filled with sign bits
      std::string::size_type result_size = (high-low+1+7)/8;
      result.m_data.erase();
      byte extend = bit(high) ? byte(255) : byte (0);
      while (result.m_data.size() < result_size)
        result.m_data.append(1,extend);
      // now set the relevant bits
      for (unsigned i = low; i <= high; i++)
        result.preset(i-low, bit(i));
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // testing operations

  bool inf::negative (void) const
  {
    return bit(indexable_bits()-1);
  }

  bool inf::natural (void) const
  {
    return !negative();
  }

  bool inf::positive (void) const
  {
    return natural() && !zero();
  }

  bool inf::zero (void) const
  {
    for (std::string::size_type i = 0; i < m_data.size(); i++)
      if (m_data[i] != 0)
        return false;
    return true;
  }

  bool inf::non_zero (void) const
  {
    return !zero();
  }

  bool inf::operator ! (void) const
  {
    return zero();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // comparison operators

  bool inf::operator == (const inf& r) const
  {
    // Two infs are equal if they are numerically equal, even if they are
    // different sizes (i.e. they could be non-reduced values).
    // This makes life a little more complicated than if I could assume that values were reduced.
    byte l_extend = negative() ? byte(255) : byte (0);
    byte r_extend = r.negative() ? byte(255) : byte (0);
    std::string::size_type bytes = maximum(m_data.size(),r.m_data.size());
    for (std::string::size_type i = bytes; i--; )
    {
      byte l_byte = (i < m_data.size() ? byte(m_data[i]) : l_extend);
      byte r_byte = (i < r.m_data.size() ? byte(r.m_data[i]) : r_extend);
      if (l_byte != r_byte)
        return false;
    }
    return true;
  }

  bool inf::operator != (const inf& r) const
  {
    return !operator==(r);
  }

  bool inf::operator < (const inf& r) const
  {
    // This could be implemented in terms of subtraction. However, it can be
    // simplified since there is no need to calculate the accurate difference,
    // just the direction of the difference. I compare from msB down and as
    // soon as a byte difference is found, that defines the ordering. The
    // problem is that in 2's-complement, all negative values are greater than
    // all natural values if you just do a straight unsigned comparison. I
    // handle this by doing a preliminary test for different signs.

    // For example, a 3-bit signed type has the coding:
    // 000 = 0
    // ...
    // 011 = 3
    // 100 = -4
    // ...
    // 111 = -1

    // So, for natural values, the ordering of the integer values is the
    // ordering of the bit patterns. Similarly, for negative values, the
    // ordering of the integer values is the ordering of the bit patterns
    // However, the bit patterns for the negative values are *greater than*
    // the natural values. This is a side-effect of the naffness of
    // 2's-complement representation

    // first handle the case of comparing two values with different signs
    bool l_sign = negative();
    bool r_sign = r.negative();
    if (l_sign != r_sign)
    {
      // one argument must be negative and the other natural
      // the left is less if it is the negative one
      return l_sign;
    }
    // the arguments are the same sign
    // so the ordering is a simple unsigned byte-by-byte comparison
    // However, this is complicated by the possibility that the values could be different lengths
    byte l_extend = l_sign ? byte(255) : byte (0);
    byte r_extend = r_sign ? byte(255) : byte (0);
    std::string::size_type bytes = maximum(m_data.size(),r.m_data.size());
    for (std::string::size_type i = bytes; i--; )
    {
      byte l_byte = (i < m_data.size() ? byte(m_data[i]) : l_extend);
      byte r_byte = (i < r.m_data.size() ? byte(r.m_data[i]) : r_extend);
      if (l_byte != r_byte)
        return l_byte < r_byte;
    }
    // if I get here, the two are equal, so that is not less-than
    return false;
  }

  bool inf::operator <= (const inf& r) const
  {
    return !(r < *this);
  }

  bool inf::operator > (const inf& r) const
  {
    return r < *this;
  }

  bool inf::operator >= (const inf& r) const
  {
    return !(*this < r);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // logical operators

  inf& inf::invert (void)
  {
    for (std::string::size_type i = 0; i < m_data.size(); i++)
      m_data[i] = ~m_data[i];
    return *this;
  }

  inf inf::operator ~ (void) const
  {
    inf result(*this);
    result.invert();
    return result;
  }

  inf& inf::operator &= (const inf& r)
  {
    // bitwise AND is extended to the length of the largest argument
    byte l_extend = negative() ? byte(255) : byte (0);
    byte r_extend = r.negative() ? byte(255) : byte (0);
    std::string::size_type bytes = maximum(m_data.size(),r.m_data.size());
    for (std::string::size_type i = 0; i < bytes; i++)
    {
      byte l_byte = (i < m_data.size() ? byte(m_data[i]) : l_extend);
      byte r_byte = (i < r.m_data.size() ? byte(r.m_data[i]) : r_extend);
      byte result = l_byte & r_byte;
      if (i < m_data.size())
        m_data[i] = result;
      else
        m_data.append(1,result);
    }
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator & (const inf& r) const
  {
    inf result(*this);
    result &= r;
    return result;
  }

  inf& inf::operator |= (const inf& r)
  {
    // bitwise OR is extended to the length of the largest argument
    byte l_extend = negative() ? byte(255) : byte (0);
    byte r_extend = r.negative() ? byte(255) : byte (0);
    std::string::size_type bytes = maximum(m_data.size(),r.m_data.size());
    for (std::string::size_type i = 0; i < bytes; i++)
    {
      byte l_byte = (i < m_data.size() ? byte(m_data[i]) : l_extend);
      byte r_byte = (i < r.m_data.size() ? byte(r.m_data[i]) : r_extend);
      byte result = l_byte | r_byte;
      if (i < m_data.size())
        m_data[i] = result;
      else
        m_data.append(1,result);
    }
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator | (const inf& r) const
  {
    inf result(*this);
    result |= r;
    return result;
  }

  inf& inf::operator ^= (const inf& r)
  {
    // bitwise XOR is extended to the length of the largest argument
    byte l_extend = negative() ? byte(255) : byte (0);
    byte r_extend = r.negative() ? byte(255) : byte (0);
    std::string::size_type bytes = maximum(m_data.size(),r.m_data.size());
    for (std::string::size_type i = 0; i < bytes; i++)
    {
      byte l_byte = (i < m_data.size() ? byte(m_data[i]) : l_extend);
      byte r_byte = (i < r.m_data.size() ? byte(r.m_data[i]) : r_extend);
      byte result = l_byte ^ r_byte;
      if (i < m_data.size())
        m_data[i] = result;
      else
        m_data.append(1,result);
    }
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator ^ (const inf& r) const
  {
    inf result(*this);
    result ^= r;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // shift operators all preserve the value by increasing the word size

  inf& inf::operator <<= (unsigned shift)
  {
    // left shift is a shift towards the msb, with 0s being shifted in at the lsb
    // split this into a byte shift followed by a bit shift

    // first expand the value to be big enough for the result
    std::string::size_type new_size = (indexable_bits() + shift + 7) / 8;
    byte extend = negative() ? byte(255) : byte (0);
    while (m_data.size() < new_size)
      m_data.append(1,extend);
    // now do the byte shift
    unsigned byte_shift = shift/8;
    if (byte_shift > 0)
    {
      for (std::string::size_type b = new_size; b--; )
        m_data[b] = (b >= byte_shift) ? m_data[b-byte_shift] : byte(0);
    }
    // and finally the bit shift
    unsigned bit_shift = shift%8;
    if (bit_shift > 0)
    {
      for (std::string::size_type b = new_size; b--; )
      {
        byte current = byte(m_data[b]);
        byte previous = b > 0 ? m_data[b-1] : byte(0);
        m_data[b] = (current << bit_shift) | (previous >> (8 - bit_shift));
      }
    }
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator << (unsigned shift) const
  {
    inf result(*this);
    result <<= shift;
    return result;
  }

  inf& inf::operator >>= (unsigned shift)
  {
    // right shift is a shift towards the lsb, with sign bits being shifted in at the msb
    // split this into a byte shift followed by a bit shift

    // a byte of sign bits
    byte extend = negative() ? byte(255) : byte (0);
    // do the byte shift
    unsigned byte_shift = shift/8;
    if (byte_shift > 0)
    {
      for (std::string::size_type b = 0; b < m_data.size(); b++)
        m_data[b] = (b + byte_shift < m_data.size()) ? m_data[b+byte_shift] : extend;
    }
    // and finally the bit shift
    unsigned bit_shift = shift%8;
    if (bit_shift > 0)
    {
      for (std::string::size_type b = 0; b < m_data.size(); b++)
      {
        byte current = byte(m_data[b]);
        byte next = ((b+1) < m_data.size()) ? m_data[b+1] : extend;
        byte shifted = (current >> bit_shift) | (next << (8 - bit_shift));
        m_data[b] = shifted;
      }
    }
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator >> (unsigned shift) const
  {
    inf result(*this);
    result >>= shift;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // negation operators

  inf& inf::negate (void)
  {
    // do 2's-complement negation
    // equivalent to inversion plus one
    invert();
    operator += (inf(1));
    return *this;
  }

  inf inf::operator - (void) const
  {
    inf result(*this);
    result.negate();
    return result;
  }

  inf& inf::abs(void)
  {
    if (negative()) negate();
    return *this;
  }

  inf abs(const inf& i)
  {
    inf result = i;
    result.abs();
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // addition operators

  inf& inf::operator += (const inf& r)
  {
    // do 2's-complement addition
    // Note that the addition can give a result that is larger than either argument
    byte carry = 0;
    std::string::size_type max_size = maximum(m_data.size(),r.m_data.size());
    byte l_extend = negative() ? byte(255) : byte (0);
    byte r_extend = r.negative() ? byte(255) : byte (0);
    for (std::string::size_type i = 0; i < max_size; i++)
    {
      byte l_byte = (i < m_data.size() ? byte(m_data[i]) : l_extend);
      byte r_byte = (i < r.m_data.size() ? byte(r.m_data[i]) : r_extend);
      // calculate the addition in a type that is bigger than a byte in order to catch the carry-out
      unsigned short result = ((unsigned short)(l_byte)) + ((unsigned short)(r_byte)) + carry;
      // now truncate the result to get the lsB
      if (i < m_data.size())
        m_data[i] = byte(result);
      else
        m_data.append(1,byte(result));
      // and capture the carry out by grabbing the second byte of the result
      carry = byte(result >> 8);
    }
    // if the result overflowed or underflowed, add an extra byte to catch it
    unsigned short result = ((unsigned short)(l_extend)) + ((unsigned short)(r_extend)) + carry;
    if (byte(result) != (negative() ? byte(255) : byte(0)))
      m_data.append(1,byte(result));
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator + (const inf& r) const
  {
    inf result(*this);
    result += r;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // subtraction operators

  inf& inf::operator -= (const inf& r)
  {
    // subtraction is defined in terms of negation and addition
    inf negated = -r;
    operator += (negated);
    return *this;
  }

  inf inf::operator - (const inf& r) const
  {
    inf result(*this);
    result -= r;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // multiplication operators

  inf& inf::operator *= (const inf& r)
  {
    // 2's complement multiplication
    // one day I'll do a more efficient version than this based on the underlying representation
    inf left(*this);
    inf right = r;
    // make the right value natural but preserve its sign for later
    bool right_negative = right.negative();
    right.abs();
    // implemented as a series of conditional additions
    operator = (0);
    //  left.resize(right.bits() + left.bits() - 1);
    left <<= right.bits()-1;
    for (unsigned i = right.bits(); i--; )
    {
      if (right[i]) 
        operator += (left);
      left >>= 1;
    }
    if (right_negative)
      negate();
    // now reduce the result
    reduce();
    return *this;
  }

  inf inf::operator * (const inf& r) const
  {
    inf result(*this);
    result *= r;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // division and remainder operators

  std::pair<inf,inf> inf::divide(const inf& right) const throw(divide_by_zero)
  {
    if (right.zero())
      throw divide_by_zero("stlplus::inf::divide");
    inf numerator(*this);
    inf denominator = right;
    // make the numerator natural but preserve the sign for later
    bool numerator_negative = numerator.negative();
    numerator.abs();
    // same with the denominator
    bool denominator_negative = denominator.negative();
    denominator.abs();
    // the quotient and remainder will form the result
    // start with the quotiont zero and the remainder equal to the whole of the
    // numerator, then do trial subtraction from this
    inf quotient;
    inf remainder = numerator;
    // there's nothing more to do if the numerator is smaller than the denominator
    // but otherwise do the division
    if (numerator.bits() >= denominator.bits())
    {
      // make the quotient big enough to take the result
      quotient.resize(numerator.bits());
      // start with the numerator shifted to the far left
      unsigned shift = numerator.bits() - denominator.bits();
      denominator <<= shift;
      // do the division by repeated subtraction, 
      for (unsigned i = shift+1; i--; )
      {
        if (remainder >= denominator)
        {
          remainder -= denominator;
          quotient.set(i);
        }
        denominator >>= 1;
      }
    }
    // now adjust the signs 
    // x/(-y) == (-x)/y == -(x/y)
    if (numerator_negative != denominator_negative)
      quotient.negate();
    quotient.reduce();
    // x%(-y) == x%y and (-x)%y == -(x%y)
    if (numerator_negative)
      remainder.negate();
    remainder.reduce();
    return std::pair<inf,inf>(quotient,remainder);
  }

  inf& inf::operator /= (const inf& r) throw(divide_by_zero)
  {
    std::pair<inf,inf> result = divide(r);
    operator=(result.first);
    return *this;
  }

  inf inf::operator / (const inf& r) const throw(divide_by_zero)
  {
    std::pair<inf,inf> result = divide(r);
    return result.first;
  }

  inf& inf::operator %= (const inf& r) throw(divide_by_zero)
  {
    std::pair<inf,inf> result = divide(r);
    operator=(result.second);
    return *this;
  }

  inf inf::operator % (const inf& r) const throw(divide_by_zero)
  {
    std::pair<inf,inf> result = divide(r);
    return result.second;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // prefix (void) and postfix (int) operators

  inf& inf::operator ++ (void)
  {
    operator += (inf(1));
    return *this;
  }

  inf inf::operator ++ (int)
  {
    inf old(*this);
    operator += (inf(1));
    return old;
  }

  inf& inf::operator -- (void)
  {
    operator -= (inf(1));
    return *this;
  }

  inf inf::operator -- (int)
  {
    inf old(*this);
    operator -= (inf(1));
    return old;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // string representation and I/O routines

  std::string inf::to_string(unsigned radix) const
    throw(std::invalid_argument)
  {
    std::string result;
    convert_to_string(*this, result, radix);
    return result;
  }

  inf& inf::from_string(const std::string& value, unsigned radix)
    throw(std::invalid_argument)
  {
    convert_from_string(value, *this, radix);
    return *this;
  }

  std::ostream& operator << (std::ostream& str, const inf& i)
  {
    try
    {
      // get radix
      unsigned radix = 10;
      if (str.flags() & std::ios_base::oct)
        radix = 8;
      if (str.flags() & std::ios_base::hex)
        radix = 16;
      // the field width is handled by iostream, so I don't need to handle it as well
      // generate the string representation then print it
      str << i.to_string(radix);
    }
    catch(const std::invalid_argument)
    {
      str.setstate(std::ios_base::badbit);
    }
    return str;
  }

  std::istream& operator >> (std::istream& str, inf& i)
  {
    try
    {
      // get radix
      unsigned radix = 10;
      if (str.flags() & std::ios_base::oct)
        radix = 8;
      if (str.flags() & std::ios_base::hex)
        radix = 16;
      // now get the string image of the value
      std::string image;
      str >> image;
      // and convert to inf
      i.from_string(image, radix);
    }
    catch(const std::invalid_argument)
    {
      str.setstate(std::ios_base::badbit);
    }
    return str;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // diagnostic dump
  // just convert to hex

  std::string inf::image_debug(void) const
  {
    // create this dump in the human-readable form, i.e. msB to the left
    std::string result = "0x";
    for (std::string::size_type i = m_data.size(); i--; )
    {
      byte current = m_data[i];
      byte msB = (current & byte(0xf0)) >> 4;
      result += to_char[msB];
      byte lsB = (current & byte(0x0f));
      result += to_char[lsB];
    }
    return result;
  }

  const std::string& inf::get_bytes(void) const
  {
    return m_data;
  }

  void inf::set_bytes(const std::string& data)
  {
    m_data = data;
  }

} // end namespace stlplus
