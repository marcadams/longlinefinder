###############################################################################
# Long Line Finder                                                            #
#                                                                             #
# Parses text files and prints out the longest lines in file                  #
#                                                                             #
# Marc Adams - marc.adams@gmail.com                                           #
###############################################################################

Requirements
-------------------------------------------------------------------------------
1. Python (http://www.python.org/)
2. A large text file


Usage
-------------------------------------------------------------------------------
From a terminal Run:
  python longlinefinder/longlinefinder.py

By default the script will look for a file named largefile.txt in the directory
you execute it from. You can also supply the path to a file with the -i option:

  python longlinefinder/longlinefinder.py -i /path/to/file.ext

The 10 longest lines will be printed out from the text file. You can print out
a different number of lines with the -l option:

  python longlinefinder/longlinefinder.py -i /path/to/file.ext -l 30


Running Tests
-------------------------------------------------------------------------------
Included are some simple tests to run these tests you need to install the script
into the python libraries:

  python setup.py install

Once installed you can run the tests:

  python test/test_longlinefinder.py


Generating a Text File
-------------------------------------------------------------------------------
See: util/doc/index.html
