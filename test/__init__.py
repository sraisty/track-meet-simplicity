# This is a blank file that needs to be present to create a "test package"
# With this file here, we can now put all tests in the "test" directory
# and have the python unittest library automatically find and run them
# from the command line from the top-level project directory (not within the
# test subdirectory) via the following:
#
# to run all tests:
#  $  python3 -m unittest
# or
# $ python3 -m unittest discover

# to run all tests within a single testfile:
# $ python3 -m unittest test.test_filename1

# to run a specific TestSuite within a single testfile:
# $ python3 -m unittest test.test_filename1.TestMyCase1
# $ python3 -m unittest test.test_filename1.TestMyCase1.test_method1


# Other notes: python3 -m unittest discover will find and run tests in the
# test directory if they are named test*.py.

# If you named the subdirectory tests (note the plural s at end), use
# $ python -m unittest discover -s tests

# if you named the test files antigravity_test.py, use
# $ python -m unittest discover -s tests -p '*test.py'

# File names can use underscores but not dashes.
