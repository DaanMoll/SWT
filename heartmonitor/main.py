# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

import random


def heart(number):
    if (number >= 60 and number <= 100):
        print("Normal heart rate")
    elif (number >= 40 and number <= 59):
        print("Normal heart rate for active individuals")
    elif (number <= 39):
        print("WARNING! Heart rate is low")
    elif (number >= 100 and number <= 120):
        print("WARNING! Heart rates have increased")
    elif (number > 120 and number <= 140):
        print("WARNING! Heart rate is constantly increasing")
    elif number > 140:
        print("Warning, the situation is critical!!")


def oxygen(number):
    if number >= 95:
        print("Normal oxygen")
    elif (number < 95 and number >= 85):
        print("WARNING! Oxygen in body NOT ENOUGH")
    else:
        print("WARNING! Situation is very critical.")

def blood_pressure(number):
    numbers = number.split("/")
    print(numbers)

    first = int(numbers[0])
    second = int(numbers[1])

    """
    can it be 100/50? is that a thing or are they correlated?
    from reading online i think they are correlated
    but still, check if valid input?
    """

    if first <= 90 and second <= 60:
        print("WARNING! Low bloodpressure! seek medical attention!")
    elif first >= 140 and second >= 90:
        print("WARNING! High bloodpressure! Seek medical attention!")
    elif first >= 140 and second <= 90 and second >= 60:
        print("Isolated systolic hypertension! Normal for older people, but further tests should be done.")
    else:
        print("Blood pressure is normal")
    pass


if __name__ == '__main__':
    #pulse = random.randint(30, 150)
    pulse = int(input("Add pulse number (e.g. 70): "))
    #o2 = random.randint(75, 100)
    o2 = int(input("Add oxygen number (e.g. 96): "))
    #blood_p = str(random.randint(30, 250)) + "/" + str(random.randint(30, 160))
    blood_p = input("Add blood pressure number (e.g. 100/80): ")
    print("Patient's heart rate number is: ", pulse)
    heart(pulse)
    print("Patient's oxygen number is: ", o2)
    oxygen(o2)
    print("Patient's blood pressure is: ", blood_p)
    blood_pressure(blood_p)
