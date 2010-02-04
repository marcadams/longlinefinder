#!/usr/bin/env python
# encoding: utf-8
"""
test_longlinefinder.py

Created by Marc Adams on 2010-02-02
"""

import unittest
import longlinefinder

ordered_string_list = ["1", "22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999", "0000000000"]
unordered_string_list = ["333", "1", "0000000000", "666666", "22", "4444", "88888888", "55555", "7777777", "999999999"]
expected_result_10 = "0000000000\n999999999\n88888888\n7777777\n666666\n55555\n4444\n333\n22\n1"
expected_result_5 = "0000000000\n999999999\n88888888\n7777777\n666666"

class testLineFinder(unittest.TestCase):
  def setUp(self):
    self.finder = longlinefinder.LineFinder()

  def testParseOrderedString(self):
    result = self.finder.parse(ordered_string_list)
    self.assertEqual(expected_result_10, result)

  def testParseUnorderedString(self):
    result = self.finder.parse(unordered_string_list)
    self.assertEqual(expected_result_10, result)

  def testLimitReturnedStringCount(self):
    finder = longlinefinder.LineFinder("/does/not/matter.atall", 5)
    result = finder.parse(ordered_string_list)
    self.assertEqual(expected_result_5, result)


if __name__ == '__main__':
  unittest.main()