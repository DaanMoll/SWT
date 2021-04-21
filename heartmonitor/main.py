# This program simulates the controller of a heart monitoring device.
# It reads the pulse, the oxygen level as well as the blood pressure.
# Its main purpose is to raise alarms if there is something seriously wrong.

import random

def heart(number):
    if (number >= 60 and number <= 100):
        print("Normal heart rate.")
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
    print(numbers)

    first = int(numbers[0])
    second = int(numbers[1])
    
    if first <= second:
        print("WARNING! Highly unusual blood pressure!!! Seek immediate medical attention!")
    elif first < 90 and second < 60:
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
        print("Normal oxygen")
    elif (number < 95 and number >= 85):
        print("WARNING! Oxygen in body NOT ENOUGH!")
    else:
        print("WARNING! Situation is very critical.")


if __name__ == '__main__':
    #pulse = random.randint(30, 150)
    pulse = int(input("Add pulse number (e.g. 70): "))
    #blood_p = str(random.randint(30, 250)) + "/" + str(random.randint(30, 160))
    blood_p = input("Add blood pressure number (e.g. 100/80): ")
    #o2 = random.randint(75, 100)
    o2 = int(input("Add oxygen number (e.g. 96): "))
    if o2 > 100:
        while o2 >100:
            print("The oxygen number cannot be greater than 100.")
            o2 = int(input("Add oxygen number (e.g. 96): "))
    print("Patient's heart rate number is: ", pulse)
    heart(pulse)
    print("Patient's blood pressure is: ", blood_p)
    blood_pressure(blood_p)
    print("Patient's oxygen number is: ", o2)
    oxygen(o2)
