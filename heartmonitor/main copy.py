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
        print("Normal oxygen")
    elif (number < 95 and number >= 85):
        print("WARNING! Oxygen in body NOT ENOUGH!")
    else:
        print("WARNING! Situation is very critical.")


if __name__ == '__main__':
    #pulse = random.randint(30, 150)
    while True:
        try:
            pulse = int(input("Enter heart rate per minute, (e.g. 70): "))
            break
        except ValueError:
            print("Enter an integer please.")

    

    #blood_p = str(random.randint(30, 250)) + "/" + str(random.randint(30, 160))
    blood_p = input("Enter blood pressure (e.g. 120/80): ")
    
    numbers = blood_p.split("/")
    while len(numbers) != 2 and isinstance(numbers[0], int) and isinstance(numbers[1], int):
        blood_p = input("Enter blood pressure (e.g. 120/80): ")
        numbers = blood_p.split("/")

    #o2 = random.randint(75, 100)

    
    while True:
        try:
            o2 = int(input("Enter oxygen level in percentages (e.g. 96): "))
            if o2 > 100:
                while o2 > 100:
                    print("The oxygen number cannot be greater than 100.")
                    o2 = int(input("Add oxygen number (e.g. 96): "))
            break
        except ValueError:
            print("Enter an integer lower or equal to 100 please.")

    

    print()
    print("Patient's heart rate is: ", pulse)
    heart(pulse)

    print()
    print("Patient's blood pressure is: ", blood_p)
    blood_pressure(blood_p)

    print()
    print("Patient's oxygen level is: ", o2)
    oxygen(o2)
