////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "cli_parser.hpp"
#include "file_system.hpp"
#include "dprintf.hpp"
////////////////////////////////////////////////////////////////////////////////

namespace stlplus 
{

  ////////////////////////////////////////////////////////////////////////////////
  // cli_definition internals

  const std::string& stlplus::cli_definition::name(void) const
  {
    return m_name;
  }

  stlplus::cli_kind_t stlplus::cli_definition::kind(void) const
  { 
    return m_kind;
  }

  stlplus::cli_mode_t stlplus::cli_definition::mode(void) const
  {
    return m_mode;
  }

  const std::string& stlplus::cli_definition::message(void) const
  {
    return m_message;
  }

  const std::string& stlplus::cli_definition::default_value(void) const
  {
    return m_default;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // internal data structures

  class cli_value
  {
  public:
    unsigned m_definition;
    std::string m_value;
    unsigned m_level;
    std::string m_source;

    cli_value(unsigned definition, const std::string& value, unsigned level, const std::string& source) :
      m_definition(definition), m_value(value), m_level(level), m_source(source) 
      {
      }
  };

  ////////////////////////////////////////////////////////////////////////////////

  class cli_parser_data
  {
  public:
    message_handler& m_messages;
    std::string m_executable;
    cli_parser::definitions m_definitions;
    std::vector<cli_value> m_values;
    unsigned m_level;
    bool m_valid;
    std::vector<std::string> m_ini_files;

  public:

    cli_parser_data(message_handler& messages) : 
      m_messages(messages), m_level(1), m_valid(true)
      {
        // ensure that the CLI's messages are in the message handler - these
        // can be overridden from a file later - see message_handler
        if (!m_messages.message_present("CLI_VALUE_MISSING"))
          m_messages.add_message("CLI_VALUE_MISSING", "option @0 requires a value - end of line was reached instead");
        if (!m_messages.message_present("CLI_UNRECOGNISED_OPTION"))
          m_messages.add_message("CLI_UNRECOGNISED_OPTION", "@0 is not a recognised option for this command");
        if (!m_messages.message_present("CLI_NO_VALUES"))
          m_messages.add_message("CLI_NO_VALUES", "argument @0 is invalid - this program doesn't take command-line arguments");
        if (!m_messages.message_present("CLI_USAGE_PROGRAM"))
          m_messages.add_message("CLI_USAGE_PROGRAM", "usage:\n\t@0 { arguments }");
        if (!m_messages.message_present("CLI_USAGE_DEFINITIONS"))
          m_messages.add_message("CLI_USAGE_DEFINITIONS", "arguments:");
        if (!m_messages.message_present("CLI_USAGE_VALUES"))
          m_messages.add_message("CLI_USAGE_VALUES", "values:");
        if (!m_messages.message_present("CLI_USAGE_VALUE_RESULT"))
          m_messages.add_message("CLI_USAGE_VALUE_RESULT", "\t@0 : from @1");
        if (!m_messages.message_present("CLI_USAGE_SWITCH_RESULT"))
          m_messages.add_message("CLI_USAGE_SWITCH_RESULT", "\t-@0 : from @1");
        if (!m_messages.message_present("CLI_USAGE_OPTION_RESULT"))
          m_messages.add_message("CLI_USAGE_OPTION_RESULT", "\t-@0 @1 : from @2");
        if (!m_messages.message_present("CLI_INI_HEADER"))
          m_messages.add_message("CLI_INI_HEADER", "configuration files:");
        if (!m_messages.message_present("CLI_INI_FILE_PRESENT"))
          m_messages.add_message("CLI_INI_FILE_PRESENT", "\t@0");
        if (!m_messages.message_present("CLI_INI_FILE_ABSENT"))
          m_messages.add_message("CLI_INI_FILE_ABSENT", "\t@0 (not found)");
        if (!m_messages.message_present("CLI_INI_VARIABLE"))
          m_messages.add_message("CLI_INI_VARIABLE", "unknown variable \"@0\" found in Ini file");
      }

    unsigned add_definition(const cli_parser::definition& definition)
      {
        m_definitions.push_back(definition);
        return static_cast<unsigned>(m_definitions.size())-1;
      }

    std::string name(unsigned i) const throw(cli_index_error)
      {
        if (i >= m_values.size()) throw cli_index_error("Index " + dformat("%u",i) + " out of range");
        return m_definitions[m_values[i].m_definition].name();
      }

    unsigned id(unsigned i) const throw(cli_index_error)
      {
        if (i >= m_values.size()) throw cli_index_error("Index " + dformat("%u",i) + " out of range");
        return m_values[i].m_definition;
      }

    cli_parser::kind_t kind(unsigned i) const throw(cli_index_error)
      {
        if (i >= m_values.size()) throw cli_index_error("Index " + dformat("%u",i) + " out of range");
        return m_definitions[m_values[i].m_definition].kind();
      }

    cli_parser::mode_t mode(unsigned i) const throw(cli_index_error)
      {
        if (i >= m_values.size()) throw cli_index_error("Index " + dformat("%u",i) + " out of range");
        return m_definitions[m_values[i].m_definition].mode();
      }

//     unsigned add_definition(const std::string& name,
//                             cli_parser::kind_t kind,
//                             cli_parser::mode_t mode,
//                             const std::string& message)
//       {
//         return add_definition(cli_parser::definition(name, kind, mode, message));
//       }

    unsigned find_definition(const std::string& name)
      {
        // this does substring matching on the definitions and returns the first
        // match - however, it requires at least one character in the substring so
        // that the "" convention for command line arguments doesn't match with
        // anything. It returns size() if it fails
        for (unsigned i = 0; i < m_definitions.size(); i++)
        {
          std::string candidate = m_definitions[i].name();
          if ((candidate.empty() && name.empty()) ||
              (!name.empty() && candidate.size() >= name.size() && candidate.substr(0,name.size()) == name))
            return i;
        }
        return static_cast<unsigned>(m_definitions.size());
      }

    void clear_definitions(void)
      {
        m_definitions.clear();
        m_values.clear();
        reset_level();
        set_valid();
      }

    void reset_level(void)
      {
        // the starting level is 1 so that later functions can call clear_level with
        // a value of m_level-1 without causing underflow
        m_level = 1;
      }

    void increase_level(void)
      {
        m_level++;
      }

    void clear_level(unsigned definition, unsigned level)
      {
        // clears all values with this definition at the specified level or below
        for (std::vector<cli_value>::iterator i = m_values.begin(); i != m_values.end(); )
        {
          if (i->m_definition == definition && i->m_level <= level)
            i = m_values.erase(i);
          else
            i++;
        }
      }

    void set_valid(void)
      {
        m_valid = true;
      }

    void set_invalid(void)
      {
        m_valid = false;
      }

    bool valid(void) const
      {
        return m_valid;
      }

    unsigned add_value(unsigned definition, const std::string& value, const std::string& source)
      {
        // behaviour depends on mode:
        //  - single: erase all previous values
        //  - multiple: erase values at a lower level than current
        //  - cumulative: erase no previous values
        switch (m_definitions[definition].mode())
        {
        case cli_single_mode:
          clear_level(definition, m_level);
          break;
        case cli_multiple_mode:
          clear_level(definition, m_level-1);
          break;
        case cli_cumulative_mode:
          break;
        }
        m_values.push_back(cli_value(definition,value,m_level,source));
        return static_cast<unsigned>(m_values.size())-1;
      }

    unsigned add_switch(unsigned definition, bool value, const std::string& source)
      {
        return add_value(definition, value ? "on" : "off", source);
      }

    void erase_value(unsigned definition)
      {
        // this simply erases all previous values
        clear_level(definition, m_level);
      }

    void add_ini_file(const std::string& file)
      {
        m_ini_files.push_back(file);
      }

    unsigned ini_file_size(void) const
      {
        return static_cast<unsigned>(m_ini_files.size());
      }

    const std::string& ini_file(unsigned i) const
      {
        return m_ini_files[i];
      }

    unsigned add_checked_definition(const cli_parser::definition& definition) throw(cli_mode_error)
      {
        // check for stupid combinations
        // at this stage the only really stupid one is to declare command line arguments to be switch mode
        if (definition.name().empty() && definition.kind() == cli_switch_kind) 
        {
          set_invalid();
          throw cli_mode_error("CLI arguments cannot be switch kind");
        }
        // add the definition to the set of all definitions
        unsigned i = add_definition(definition);
        // also add it to the list of values, but only if it has a default value
        if (!definition.default_value().empty())
          add_value(i, definition.default_value(), "builtin default");
        return i;
      }

    bool switch_value(unsigned i) const throw(cli_mode_error,cli_index_error)
      {
        if (i >= m_values.size()) throw cli_index_error("Index " + dformat("%u",i) + " out of range");
        if (kind(i) != cli_switch_kind) throw cli_mode_error(name(i) + " is not a switch kind");
        std::string value = m_values[i].m_value;
        return value == "on" || value == "true" || value == "1";
      }

    std::string string_value(unsigned i) const throw(cli_mode_error,cli_index_error)
      {
        if (i >= m_values.size()) throw cli_index_error("Index " + dformat("%u",i) + " out of range");
        if (kind(i) != cli_value_kind) throw cli_mode_error(name(i) + " is not a value kind");
        return m_values[i].m_value;
      }

    void set_defaults(const ini_manager& defaults, const std::string& ini_section) throw()
      {
        // import default values from the Ini Manager
        increase_level();
        // get the set of all names from the Ini manager so that illegal names generate meaningful error messages
        std::vector<std::string> names = defaults.variable_names(ini_section);
        for (unsigned i = 0; i < names.size(); i++)
        {
          std::string name = names[i];
          unsigned definition = find_definition(name);
          if (definition == (unsigned)-1)
          {
            // not found - give an error report
            message_position position(defaults.variable_filename(ini_section,name),
                                      defaults.variable_linenumber(ini_section,name),
                                      0);
            m_messages.error(position,"CLI_INI_VARIABLE", name);
          }
          else
          {
            // found - so add the value
            // multi-valued variables are entered as a comma-separated list and this is then turned into a vector
            // the vector is empty if the value was empty
            std::vector<std::string> values = defaults.variable_values(ini_section, name);
            // an empty string is used to negate the value
            if (values.empty())
              erase_value(definition);
            else
            {
              std::string source = filespec_to_relative_path(defaults.variable_filename(ini_section, name));
              for (unsigned j = 0; j < values.size(); j++)
                add_value(definition, values[j], source);
            }
          }
        }
        // add the set of ini files to the list for usage reports
        for (unsigned j = 0; j < defaults.size(); j++)
          add_ini_file(defaults.filename(j));
      }

    bool parse(char* argv[]) throw(cli_argument_error,message_handler_id_error,message_handler_format_error)
      {
        bool result = true;
        if (!argv) throw cli_argument_error("Argument vector cannot be null");
        increase_level();
        if (argv[0])
          m_executable = argv[0];
        for (unsigned i = 1; argv[i]; i++)
        {
          std::string name = argv[i];
          if (!name.empty() && name[0] == '-')
          {
            // we have a command line option
            unsigned found = find_definition(name.substr(1, name.size()-1));
            if (found < m_definitions.size())
            {
              // found it in its positive form
              switch (m_definitions[found].kind())
              {
              case cli_switch_kind:
                add_switch(found, true, "command line");
                break;
              case cli_value_kind:
                // get the next argument in argv as the value of this option
                // first check that there is a next value
                if (!argv[i+1])
                  result &= m_messages.error("CLI_VALUE_MISSING", name);
                else
                  add_value(found, argv[++i], "command line");
                break;
              }
            }
            else if (name.size() > 3 && name.substr(1,2) == "no")
            {
              found = find_definition(name.substr(3, name.size()-3));
              if (found < m_definitions.size())
              {
                // found it in its negated form
                switch (m_definitions[found].kind())
                {
                case cli_switch_kind:
                  add_switch(found, false, "command line");
                  break;
                case cli_value_kind:
                  erase_value(found);
                  break;
                }
              }
              else
              {
                // could not find this option in either its true or negated form
                result &= m_messages.error("CLI_UNRECOGNISED_OPTION", name);
              }
            }
            else
            {
              // could not find this option and it could not be negated
              result &= m_messages.error("CLI_UNRECOGNISED_OPTION", name);
            }
          }
          else
          {
            // we have a command-line value which is represented internally as an option with an empty string as its name
            // some very obscure commands do not have values - only options, so allow for that case too
            unsigned found = find_definition("");
            if (found < m_definitions.size())
              add_value(found, name, "command line");
            else
              result &= m_messages.error("CLI_NO_VALUES", name);
          }
        }
        if (!result) set_invalid();
        return result;
      }

    void usage(void) const throw(std::runtime_error)
      {
        m_messages.information("CLI_USAGE_PROGRAM", m_executable);
        m_messages.information("CLI_USAGE_DEFINITIONS");
        for (unsigned d = 0; d < m_definitions.size(); d++)
          m_messages.information(m_definitions[d].message());
        if (m_values.size() != 0)
        {
          m_messages.information("CLI_USAGE_VALUES");
          for (unsigned v = 0; v < m_values.size(); v++)
          {
            std::string source = m_values[v].m_source;
            std::string key = name(v);
            if (key.empty())
            {
              // command-line values
              m_messages.information("CLI_USAGE_VALUE_RESULT", string_value(v), source);
            }
            else if (kind(v) == cli_switch_kind)
            {
              // a switch
              m_messages.information("CLI_USAGE_SWITCH_RESULT", (switch_value(v) ? name(v) : "no" + name(v)), source);
            }
            else
            {
              // other values
              std::vector<std::string> args;
              args.push_back(name(v));
              args.push_back(string_value(v));
              args.push_back(source);
              m_messages.information("CLI_USAGE_OPTION_RESULT", args);
            }
          }
        }
        if (ini_file_size() > 0)
        {
          m_messages.information("CLI_INI_HEADER");
          for (unsigned i = 0; i < ini_file_size(); i++)
          {
            if (file_exists(ini_file(i)))
              m_messages.information("CLI_INI_FILE_PRESENT", filespec_to_relative_path(ini_file(i)));
            else
              m_messages.information("CLI_INI_FILE_ABSENT", filespec_to_relative_path(ini_file(i)));
          }
        }
      }

  private:
    // make this class uncopyable
    cli_parser_data(const cli_parser_data&);
    cli_parser_data& operator = (const cli_parser_data&);
  };

  ////////////////////////////////////////////////////////////////////////////////

  cli_parser::cli_parser(message_handler& messages) throw() : 
    m_data(new cli_parser_data(messages))
  {
  }

  cli_parser::cli_parser(cli_parser::definitions_t definitions, message_handler& messages) throw(cli_mode_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
  }

  cli_parser::cli_parser(cli_parser::definitions_t definitions, const ini_manager& defaults, const std::string& ini_section, message_handler& messages)  throw(cli_mode_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
    set_defaults(defaults, ini_section);
  }

  cli_parser::cli_parser(char* argv[], cli_parser::definitions_t definitions, message_handler& messages)  throw(cli_mode_error,message_handler_id_error,message_handler_format_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
    parse(argv);
  }

  cli_parser::cli_parser(char* argv[], cli_parser::definitions_t definitions, const ini_manager& defaults, const std::string& ini_section, message_handler& messages)  throw(cli_mode_error,message_handler_id_error,message_handler_format_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
    set_defaults(defaults, ini_section);
    parse(argv);
  }

  cli_parser::cli_parser(cli_parser::definitions definitions, message_handler& messages) throw(cli_mode_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
  }

  cli_parser::cli_parser(cli_parser::definitions definitions, const ini_manager& defaults, const std::string& ini_section, message_handler& messages)  throw(cli_mode_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
    set_defaults(defaults, ini_section);
  }

  cli_parser::cli_parser(char* argv[], cli_parser::definitions definitions, message_handler& messages)  throw(cli_mode_error,message_handler_id_error,message_handler_format_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
    parse(argv);
  }

  cli_parser::cli_parser(char* argv[], cli_parser::definitions definitions, const ini_manager& defaults, const std::string& ini_section, message_handler& messages)  throw(cli_mode_error,message_handler_id_error,message_handler_format_error) : 
    m_data(new cli_parser_data(messages))
  {
    add_definitions(definitions);
    set_defaults(defaults, ini_section);
    parse(argv);
  }

  cli_parser::~cli_parser(void) throw()
  {
  }

  void cli_parser::add_definitions(cli_parser::definitions_t definitions) throw(cli_mode_error)
  {
    m_data->clear_definitions();
    // the definitions array is terminated by a definition with a null name pointer
    for (unsigned i = 0; definitions[i].m_name; i++)
      add_definition(definitions[i]);
  }

  unsigned cli_parser::add_definition(const cli_parser::definition_t& definition) throw(cli_mode_error,cli_argument_error)
  {
    std::string name = definition.m_name ? definition.m_name : "";
    std::string message = definition.m_message ? definition.m_message : "";
    std::string value = definition.m_default ? definition.m_default : "";
    return add_definition(cli_parser::definition(name, definition.m_kind, definition.m_mode, message, value));
  }

  void cli_parser::add_definitions(cli_parser::definitions definitions) throw(cli_mode_error)
  {
    m_data->clear_definitions();
    for (unsigned i = 0; i < definitions.size(); i++)
      add_definition(definitions[i]);
  }

  unsigned cli_parser::add_definition(const cli_parser::definition& definition) throw(cli_mode_error)
  {
    return m_data->add_checked_definition(definition);
  }

  void cli_parser::set_defaults(const ini_manager& defaults, const std::string& ini_section) throw()
  {
    m_data->set_defaults(defaults, ini_section);
  }

  bool cli_parser::parse(char* argv[]) throw(cli_argument_error,message_handler_id_error,message_handler_format_error)
  {
    return m_data->parse(argv);
  }

  bool cli_parser::valid(void) throw()
  {
    return m_data->valid();
  }

  unsigned cli_parser::size(void) const throw()
  {
    return static_cast<unsigned>(m_data->m_values.size());
  }

  std::string cli_parser::name(unsigned i) const throw(cli_index_error)
  {
    return m_data->name(i);
  }

  unsigned cli_parser::id(unsigned i) const throw(cli_index_error)
  {
    return m_data->id(i);
  }

  cli_parser::kind_t cli_parser::kind(unsigned i) const throw(cli_index_error)
  {
    return m_data->kind(i);
  }

  bool cli_parser::switch_kind(unsigned i) const throw(cli_index_error)
  {
    return kind(i) == cli_switch_kind;
  }

  bool cli_parser::value_kind(unsigned i) const throw(cli_index_error)
  {
    return kind(i) == cli_value_kind;
  }

  cli_parser::mode_t cli_parser::mode(unsigned i) const throw(cli_index_error)
  {
    return m_data->mode(i);
  }

  bool cli_parser::single_mode(unsigned i) const throw(cli_index_error)
  {
    return mode(i) == cli_single_mode;
  }

  bool cli_parser::multiple_mode(unsigned i) const throw(cli_index_error)
  {
    return mode(i) == cli_multiple_mode;
  }

  bool cli_parser::cumulative_mode(unsigned i) const throw(cli_index_error)
  {
    return mode(i) == cli_cumulative_mode;
  }

  bool cli_parser::switch_value(unsigned i) const throw(cli_mode_error,cli_index_error)
  {
    return m_data->switch_value(i);
  }

  std::string cli_parser::string_value(unsigned i) const throw(cli_mode_error,cli_index_error)
  {
    return m_data->string_value(i);
  }

  ////////////////////////////////////////////////////////////////////////////////

  void cli_parser::usage(void) const throw(std::runtime_error)
  {
    m_data->usage();
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
