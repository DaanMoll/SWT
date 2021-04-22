# This program simulates the controller of a heart monitoring device.
# It reads the pulse, the oxygen level as well as the blood pressure.
# Its main purpose is to raise alarms if there is something seriously wrong.

import random

def heart(number):

    # normal heart rate
    if (number >= 60 and number <= 100):
        print("Heart rate is normal.")
    
    # low heart rate
    elif (number >= 40 and number <= 59):
        print("Heart rate is low, but it can be normal for active individuals.")
    
    # low heart rate
    elif (number <= 39):
        print("WARNING! Heart rate is low. Seek medicial attention!")
    
    # increasing heart rate
    elif (number >= 101 and number <= 120):
        print("WARNING! Heart rates have increased. Seek medical attention!")
    
    # heart rate increasing too high
    elif (number > 120 and number <= 140):
        print("WARNING! Heart rate is high. Seek medical attention!")
    
    # critically high
    elif number > 140:
        print("Warning! The situation is critical!! The heart rate is extremely high! Seek medical attention!")

        
def blood_pressure(number):
    numbers = number.split("/")

    first = int(numbers[0])
    second = int(numbers[1])
    
    # low bloodpressure
    if first <= 90 and second <= 60:
        print("WARNING! Low bloodpressure! seek medical attention!")

    # prehypertension between 120/80 and 140/90
    elif first > 120 and first < 140 and second > 80 and second < 90:
        print("WARNING! Prehypertension! Seek medical attention!")
    
    # high blood pressure over 140/90
    elif first >= 140 and second >= 90:
        print("WARNING! High bloodpressure! Seek medical attention!")

    # high first number and normal second number
    elif first >= 140 and second >= 60 and second <= 90 :
        print("Isolated systolic hypertension! Normal for older people, but further tests should be performed.")
    
    # normal first number and high second number
    elif first > 90 and first < 140 and second < 60:
        print("Isolated diastolic blood pressure! Seek medical attention.")
    
    # normal bloodpressure
    elif first >= 90 and first <= 120 and second >= 60 and second <= 80 :
        print("Blood pressure is normal.")
    
    else:
        print("We shouldnt be able to get to here")
    
    # check difference between systolic and diastolic
    if first - second > 60:
        print("WARNING! Wide pulse pressure! Seek medical attention!")
    pass


def oxygen(number):

    # normal oxygen level
    if number >= 95:
        print("Oxygen level is normal.")
    
    # low oxygen level
    elif (number < 95 and number >= 85):
        print("WARNING! Not enough Oxygen in blood!")
    
    # very low oxygen level
    else:
        print("WARNING! Situation is very critical. Oxygen in body is NOT ENOUGH!!!")

def ask_input():
    print()
    print("In order to exit the program type q or quit")
    print()

    stop = ["q", "quit"]
    
    pulse = input("Enter heart rate per minute, (e.g. 70): ")
    if pulse.lower() in stop:
        return False

    if not (pulse.isnumeric()):
        while not(pulse.isnumeric()):
            print("The pulse number should be a positive integer number.")
            pulse = input("Enter heart rate per minute, (e.g. 70): ")
    
    if pulse.isnumeric():
        pulse = int(pulse)

    o2 = ""
    while not(o2.isnumeric()):
        o2 = input("Enter Oxygen level in percentages (e.g. 96): ")
        
        if o2.lower() in stop:
            return False

        if o2.isnumeric():
            o2int = int(o2)
            if o2int > 100:
                o2 = ""
                print("The oxygen number should be a positive integer number equal or smaller than 100.")
        else:
            print("The oxygen number should be a positive integer number equal or smaller than 100.")

    o2 = int(o2)

    blood_p = ""
    while not(blood_p.__contains__("/")):
        blood_p = input("Enter blood pressure (e.g. 120/80): ")

        if blood_p.lower() in stop:
            return False

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
    return True

if __name__ == '__main__':
    print("This program will continously prompt for the values of the individuals heart rate, oxygen level and blood pressure.")
    
    while ask_input():
        pass