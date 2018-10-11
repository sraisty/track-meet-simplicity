"""
Module: util.py

Utility functions used by tms project
Author: Sue Raisty

"""


def print_and_log(level, message, repr_string):
    """ prints and logs warning/error/info messages """
    # TODO - add logging
    print(f"*** {level.upper()}: {message}")
    if repr_string:
        print(f"*** Object: {repr_string}")


def error(message, repr_string=""):
    """ prints and logs the message with "ERROR" prefix """
    print_and_log("error", message, repr_string)


def warning(message, repr_string=""):
    """ prints and logs the message with "WARNING" prefix """
    print_and_log("warning", message, repr_string)


def info(message, repr_string=""):
    print_and_log("info", message, repr_string)
