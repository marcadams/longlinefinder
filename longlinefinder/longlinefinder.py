#!/usr/bin/env python
# encoding: utf-8
"""
longlinefinder.py

Created by Marc Adams on 2010-02-02
"""

import sys
import os.path
import getopt
import heapq

VERSION = '1.0'
__all__ = ['LineFinderError', 'LineFinder']

help_message = """
  Parses a text file and prints out the 10 longest lines in the file.

    Usage:
       python longlinefinder.py -i "/path/to/file" -l 10

    Options:
       -i - The full path to the text file to parse. If this is not supplied the script will
            look for 'data/largefile.txt' in the same directory as the script.

       -l - The number of lines to print. Defaults to 10 if not provided.

"""

fnf_message = " is not a valid file. Did you generate a data file using util/generate_file.rb or supply the path to a file using the -i option?"

def default_file_path():
  """
  Gets the path to the default data file path which is either ../data/largefile.txt if you're in the same
  directory as the script, or data/largefile.txt if you're in the parent directory. (The project root)
  """
  default_path = "data/largefile.txt"
  if os.path.isfile(default_path):
    return default_path
  else:
    return "../" + default_path


class LineFinderError(Exception):
    """
    A custom exception class for the LineFinder class
    """
    def __init__(self, msg):
        self.msg = msg

class LineFinder(object):
    """
    Finds x longest lines in a text file.

    Keyword arguments:
    input_file -- The full path and name of the text file to parse (default data/largefile.txt)
    line_count -- The number of long lines to display (default 10)
    """

    def __init__(self, input_file='', line_count=10):
        self.input_file = input_file
        self.line_count = line_count

    def parse(self, list=None):
        """
        Parses a list of strings and returns a string containing the x longest of the supplied strings. The list argument is
        optional, the supplied input_file will be used by default.

        Keyword arguments:
        list -- A list of strings (default The input_file contents)
        """

        # If a list isn't provided as an argument, then we should parse the input_file
        if list == None:
          list = open(self.input_file)

        heap = []
        heap = heapq.nlargest(self.line_count, list, len)
        return "\n".join(heap)

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hi:l:", ["help", "input_file=", "line_count="])
        except getopt.error, msg:
            raise LineFinderError(msg)

        input_file = default_file_path()
        line_count = 10

        for option, value in opts:
            if option in ("-i", "--input_file="):
                print "Parsing: " + value
                input_file = value
            elif option in ("-l", "--line_count="):
                print "Showing " +  value + " lines"
                line_count = int(value)
            elif option in ("-h", "--help"):
                raise LineFinderError(help_message)
            else:
              print opts

        if os.path.isfile(input_file) == False:
          raise LineFinderError(input_file + fnf_message)

        llf = LineFinder(input_file, line_count)
        print llf.parse()

    except LineFinderError, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        print >> sys.stderr, "\t for help use --help"
        return 2

if __name__ == "__main__":
    sys.exit(main())
