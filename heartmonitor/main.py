# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

import random


def heart(number):
    def __init__(self):
        self.number = number

    print("Random heart rate number: ", number)
    if (number >= 60 and number <= 100):
        print("Normal heart rate")
    elif (number >= 40 and number <= 59):
        print("Normal heart rate")
    elif (number <= 39):
        print("WARNING! Heart rate is low")
    elif (number >= 100 and number <= 120):
        print("WARNING! Heart rates have increased")
    elif (number > 120 and number <= 140):
        print("WARNING! Heart rates constantly increasing")
    elif number > 140:
        print("Warning, situation is critical!!")


def oxygen(number):
    def __init__(self):
        self.number = number

    print("Random oxygen number: ", number)
    if number >= 95:
        print("Normal oxygen")
    elif (number < 95 and number >= 85):
        print("WARNING! Oxygen in body NOT ENOUGH")
    else:
        print("WARNING! Situation is very critical.")


if __name__ == '__main__':
    n = random.randint(0, 190)
    k = random.randint(0, 100)
    heart(n)
    oxygen(k)
