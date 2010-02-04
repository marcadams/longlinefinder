#!/usr/bin/env python

"""
Distutils setup script for longlinefinder module.
"""

from distutils.core import setup
import sys

sys.path.insert(0, 'longlinefinder')
import longlinefinder


setup(name='longlinefinder',
      version=longlinefinder.VERSION,
      author='Marc Adams',
      author_email='marc.adams@gmail.com',
      package_dir={'': 'longlinefinder'},
      py_modules=['longlinefinder'],
      provides=['longlinefinder'],
     )
