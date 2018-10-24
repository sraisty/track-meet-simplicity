"""
Module: util.py

Utility functions used by tms project
Author: Sue Raisty

"""

INFO_LEVEL = 'all'
# valid values: 'errors-only', 'warn-and-errors-only', 'all', 'none'


def print_and_log(level, message, repr_string):
    """ prints and logs warning/error/info messages """
    # TODO - add logging
    print(f"*** {level.upper()}: {message}")
    if repr_string:
        print(f"*** Object: {repr_string}")


def error(message, repr_string=""):
    """ prints and logs the message with "ERROR" prefix """
    if INFO_LEVEL != "none":
        print_and_log("error", message, repr_string)
    # raise Exception(f"{message} {repr_string}")


def warning(message, repr_string=""):
    """ prints and logs the message with "WARNING" prefix """
    if INFO_LEVEL == "warn-and-errors-only" or INFO_LEVEL == "all":
        print_and_log("warning", message, repr_string)


def info(message, repr_string=""):
    if INFO_LEVEL == "all":
        print_and_log("info", message, repr_string)
