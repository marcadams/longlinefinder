#!/usr/bin/env ruby

# generate_file.rb
#
# Created by Marc Adams on 2010-02-02

=begin rdoc
  = GenerateFile - Random Alphanumeric String File Generator

  This script can be used to generate a text file filled with any number of lines. Each line generated will consist of random
  alphanumeric characters.

  The number of lines, minimum line length and maximum line length can all be configured via command line options.

  == Usage

  *Options*
  -o::  The output file. (default is data/largefile.txt)
  -l::  The number of lines. (default is 1000)
  -m::  The minimum number of alphanumeric characters per line. (default is 1)
  -M::  The maximum number of alphanumeric characters per line. (default is 1000)

  *Example*

      % ruby generate_file.rb -o /path/to/output.txt -l 1000 -m 1 -M 1000

  These options will configure the output as follows:
  1. The output file will be written to /path/to/output.txt.
  2. The file will have one thousand lines.
  3. The minimum line length will be one alphanumeric character.
  4. The maximum line length will be one thousand alphanumeric characters.

  == Generating File for Long Line Finder

  This script was created to generate a file for the Long Line Finder program included.

  Given the requirements that the line finder program operate on roughly a 1GB file, use the following command to generate a file in that range:

      % ruby generate_file.rb -o tall.txt -l 2000000 -M 1000

  This will generate a file with two million lines with a maximum of one thousand alphanumeric characters per line. This is a good example of a "tall" file to parse.

  If you want to generate a "wide" example to parse use:

      % ruby generate_file.rb -o wide.txt -l 20000 -M 100000

  This will generate a file with twenty thousand lines with a maximum of one hundred thousand alphanumeric characters per line.

  == Disclaimer

  While this isn't a memory intensive process it *is* CPU intensive. On a multi-core system you shouldn't have any problems. On less powerful systems you
  won't be able to do much else while the generator is running.

  Depending on the parameters of the file you're generating it could take several minutes or more to generate the file.
=end

require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pathname'

=begin rdoc
  Extension to the String class that will build a random length string between the supplied min and max values.
=end
class String

=begin rdoc
Generates a random length string of alphanumeric characters.

*Arguments*
min::  The shortest number of alphanumeric characters the string can be (default 1)
max:: The longest number of alphanumeric characters the string can be (default 20)
=end
  def self.random(min=1, max=20)
    @@chars ||= ('a'..'z').to_a + ('A'..'Z').to_a + ("0".."9").to_a # Cache the characters to minimize memory consumption
    (min..rand(max)).map { @@chars[rand(@@chars.size)] }.to_s
  end
end

=begin rdoc
  Used to generate a text file of random length strings for each line generated.

  For convenience, each generated line will have the line number appended to the beginning of the line and
  the length of the line appended to the end.

  *Example*
  *  33_UlGddxhLEjEYOp961nMlNVqABB1KeK1QpGqecH_38 - Where 33 is the line number and 38 is the generated length.
=end
class GenerateFile

=begin rdoc
  GenerateFile constructor

  *Arguments*
  args::  Expects the ARGV array passed to the script command or an Array with the specific values. See #parse below
=end
  def initialize(args=[])
    parse(args) # Parse the arguments
    generate_file # Generate the output file
  end

=begin rdoc
  Parses the ARGV hash and determines if any arguments were passed in to the calling command that affects the output of the generator.

  *Arguments*
  args::  Expects the ARGV array or an Array with the specific options and any values needed

  *Array Values*
  The command options when running the script are:
  -o::  (*output_file*) The file that will be written to.
  -l::  (*output_lines*) The number of lines that will be written to the output file.
  -m::  (*min_line_length*) The minimum length of each generated line.
  -M::  (*max_line_length*) The maximum length of each generated line.

  *Examples*
  1. ["-o", "/path/to/file.txt"] - will set the output file to /path/to/file.txt.
  2. ["-l", "1000"] - will print one thousand random lines in the output file.
  3. ["-l", "1000000", "-m", "5", "-M", "1000"] - will print one million lines of random strings to the output file, the minimum length of each string will be five alphanumeric characters and the maximum length will be no more than one thousand alphanumeric characters.
=end
  def parse(args=[])
    options = OpenStruct.new
    options.output_file = get_data_path("largefile.txt")
    options.output_lines = 10
    options.min_line_length = 1
    options.max_line_length = 1000
    options.version = 1.0

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: generate_file.rb [options]"

      opts.separator ""
      opts.separator "Specific options:" # Specific being options that change the output of the generator.

      # Optional argument; Sets the output file
      opts.on("-o", "--output_file outputfile.txt", "Specify a different file name and/or location (default #{options.output_file})") do |outfile|
        options.output_file = outfile
      end

      # Optional argument; Sets the number of output lines
      opts.on("-l", "--output_lines N", "The number of lines to generate (default #{options.output_lines})") do |outlines|
        options.output_lines = outlines.to_i
      end
      # Optional argument; Sets the minimum line length
      opts.on("-m", "--min_line_length N", "The shortest string length allowed for any given line (default #{options.min_line_length})") do |minlinelength|
        options.min_line_length = minlinelength.to_i
      end

      # Optional argument; Sets the maximum line length
      opts.on("-M", "--max_line_length N", "The longest string length allowed for any given line (default #{options.max_line_length})") do |maxlinelength|
        options.max_line_length = maxlinelength.to_i
      end

      opts.separator ""
      opts.separator "Common options:" # Common being options that don't affect the output of the generator.

      # No argument, shows the usage help
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # No argument, shows the version number
      opts.on_tail("--version", "Show version") do
        puts options.version
        exit
      end
    end

    opts.parse!(args)
    @options = options # Set the options at the class level so that they can be accessed within the class.
  end

=begin rdoc
  Generates the data file with random strings
=end
  def generate_file
    open(get_data_path(@options.output_file), 'w') { |f|
      (1..@options.output_lines).each { |j|
        string = String.random(@options.min_line_length, @options.max_line_length)
        f.puts "#{j}_#{string}_#{string.length}" # Putting the line number and string length on here adds several characters to each line that aren't included in the
                                                 # random calculation, thus the actual line in the file could exceed the maximum character limit.
      }
    }
  end

=begin rdoc
  Gets the path to the file to create/overwrite with random generated strings

  *Arguments*
  file_name::  The name of the file to create without any path specifications. i.e. largefile.txt
=end
  def get_data_path(file_name)
    final_path = nil # Initialize the final path
    if file_name.include?(File::SEPARATOR) # If the file name includes a path separator, then we won't force where to put the file.
      final_path = file_name
    else
      path = Pathname.new(File.dirname(__FILE__))
      data_path = "#{File.expand_path(path.parent)}#{File::SEPARATOR}data"

      # If the data path doesn't exist or isn't accessible from where we are, we'll just put the output file in the current directory
      unless File.exists?(data_path)
        data_path = path
      end

      final_path = "#{data_path}#{File::SEPARATOR}#{file_name}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  GenerateFile.new(ARGV)
end
