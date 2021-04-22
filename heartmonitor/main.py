# This program simulates the controller of a heart monitoring device.
# It reads the pulse, the oxygen level as well as the blood pressure.
# Its main purpose is to raise alarms if there is something seriously wrong.

import random

def heart(number):
    if (number >= 60 and number <= 100):
        print("Heart rate is normal.")
    elif (number >= 40 and number <= 59):
        print("Heart rate is low, but it can be normal for active individuals.")
    elif (number <= 39):
        print("WARNING! Heart rate is low.")
    elif (number >= 101 and number <= 120):
        print("WARNING! Heart rates have increased.")
    elif (number > 120 and number <= 140):
        print("WARNING! Heart rate is constantly increasing.")
    elif number > 140:
        print("Warning! The situation is critical!! The heart rate is extremely high!!")

        
def blood_pressure(number):
    numbers = number.split("/")

    first = int(numbers[0])
    second = int(numbers[1])
    
    if first < 90 and second < 60:
        print("WARNING! Low bloodpressure! seek medical attention!")
        if first - second > 60:
            print("WARNING! Wide pulse pressure! Seek medical attention!")
    elif first > 140 and second > 90:
        print("WARNING! High bloodpressure! Seek medical attention!")
        if first - second > 60:
            print("WARNING! Wide pulse pressure! Seek medical attention!")
    elif first > 140 and second <= 90 and second >= 60:
        print("Isolated systolic hypertension! Normal for older people, but further tests should be done.")
        if first - second > 60:
            print("WARNING! Wide pulse pressure! Seek medical attention!")
    elif first <= 140 and first >= 90 and second < 60:
        print("Isolated diastolic blood pressure! Seek medical attention.")
        if first - second > 60:
            print("WARNING! Wide pulse pressure! Seek medical attention!")
    elif first <= 140 and first >= 90 and second <= 90 and second >= 60:
        print("Blood pressure is normal.")
        if first - second > 60:
            print("WARNING! Wide pulse pressure! Seek medical attention!")
    else:
        if first - second > 60:
            print("WARNING! Wide pulse pressure! Seek medical attention!")
    pass


def oxygen(number):
    if number >= 95:
        print("Oxygen level is normal.")
    elif (number < 95 and number >= 85):
        print("WARNING! Not enough Oxygen in blood!")
    else:
        print("WARNING! Situation is very critical.")


if __name__ == '__main__':
    print()
    
    pulse = input("Enter heart rate per minute, (e.g. 70): ")
    if not (pulse.isnumeric()):
        while not(pulse.isnumeric()):
            print("The pulse number should be a positive integer number.")
            pulse = input("Enter heart rate per minute, (e.g. 70): ")
    
    if pulse.isnumeric():
        pulse = int(pulse)

    o2 = input("Enter Oxygen level in percentages (e.g. 96): ")
    if not (o2.isnumeric()):
        while not (o2.isnumeric()):
            print("The oxygen number should be a positive integer number equal or smaller than 100.")
            o2 = input("Enter Oxygen level in percentages (e.g. 96): ")
    if o2.isnumeric():
        o2 = int(o2)
        while o2 > 100:
            print("The oxygen number should be a positive integer number equal or smaller than 100.")
            o2 = input("Enter Oxygen level in percentages (e.g. 96): ")
            o2 = int(o2)

    blood_p = ""
    while not(blood_p.__contains__("/")):
        blood_p = input("Enter blood pressure (e.g. 120/80): ")

        if blood_p.__contains__("/"):
            numbers = blood_p.split("/")
            first = numbers[0]
            second = numbers[1]

            if first.isnumeric() and second.isnumeric():
                first = int(first)
                second = int(second)
                if first <= second or first < 0 or second < 0:
                    blood_p = ""
                    print("The systolic blood pressure has to be higher than the diastolic blood pressure")
            else:
                blood_p = ""
                print("The blood pressure should be positive numbers")
        else:
            print("The blood pressure should be entered as two positive numbers with a dash '/' between them. e.g. 120/80")

    print()

    heart(pulse)

    oxygen(o2)

    blood_pressure(blood_p)

    print()
