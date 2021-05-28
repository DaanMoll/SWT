# pip install -U pytest
import pytest
import mock
import main_old


# def test_heart(capfd):
#     main_old.heart(100)
#     out, err = capfd.readouterr()
#     assert out == "Heart rate is normal.\n"
#     main_old.heart(80)
#     out, err = capfd.readouterr()
#     assert out == "Heart rate is normal.\n"
#     main_old.heart(60)
#     out, err = capfd.readouterr()
#     assert out == "Heart rate is normal.\n"


@pytest.hookimpl(hookwrapper=True)

def test_heart(capsys):
    main_old.heart(100)
    assert capsys.readouterr().out == "Heart rate is normal.\n"
    main_old.heart(80)
    assert capsys.readouterr().out == "Heart rate is normal.\n"
    main_old.heart(60)
    assert capsys.readouterr().out == "Heart rate is normal.\n"

    main_old.heart(40)
    assert capsys.readouterr().out == "Heart rate is low, but it can be normal for active individuals.\n"
    main_old.heart(50)
    assert capsys.readouterr().out == "Heart rate is low, but it can be normal for active individuals.\n"
    main_old.heart(59)
    assert capsys.readouterr().out == "Heart rate is low, but it can be normal for active individuals.\n"

    main_old.heart(39)
    assert capsys.readouterr().out == "WARNING! Heart rate is low. Seek medical attention!\n"
    main_old.heart(20)
    assert capsys.readouterr().out == "WARNING! Heart rate is low. Seek medical attention!\n"

    main_old.heart(10)
    assert capsys.readouterr().out == "WARNING!!! The heart rate is extremely low!! The patient might be dying! Seek immediate medical attention!!\n"
    main_old.heart(5)
    assert capsys.readouterr().out == "WARNING!!! The heart rate is extremely low!! The patient might be dying! Seek immediate medical attention!!\n"

    main_old.heart(101)
    assert capsys.readouterr().out == "WARNING! Heart rates have increased. Seek medical attention!\n"
    main_old.heart(110)
    assert capsys.readouterr().out == "WARNING! Heart rates have increased. Seek medical attention!\n"
    main_old.heart(120)
    assert capsys.readouterr().out == "WARNING! Heart rates have increased. Seek medical attention!\n"

    main_old.heart(125)
    assert capsys.readouterr().out == "WARNING! Heart rate is high. Seek medical attention!\n"
    main_old.heart(140)
    assert capsys.readouterr().out == "WARNING! Heart rate is high. Seek medical attention!\n"

    main_old.heart(145)
    assert capsys.readouterr().out == "Warning! The situation is critical!! The heart rate is extremely high! Seek medical attention!\n"


def test_o2(capsys):
    main_old.oxygen(99)
    assert capsys.readouterr().out == "Oxygen level is normal.\n"
    main_old.oxygen(95)
    assert capsys.readouterr().out == "Oxygen level is normal.\n"

    main_old.oxygen(90)
    assert capsys.readouterr().out == "WARNING! Not enough Oxygen in blood!\n"
    main_old.oxygen(85)
    assert capsys.readouterr().out == "WARNING! Not enough Oxygen in blood!\n"

    main_old.oxygen(80)
    assert capsys.readouterr().out == "WARNING! Situation is very critical. Oxygen in body is NOT ENOUGH!!!\n"
    main_old.oxygen(50)
    assert capsys.readouterr().out == "WARNING! Situation is very critical. Oxygen in body is NOT ENOUGH!!!\n"

    main_old.oxygen(10)
    assert capsys.readouterr().out == "WARNING!!! The oxygen level in the body is extremely low!! The patient might be dying! Seek immediate medical attention!!\n"
    main_old.oxygen(5)
    assert capsys.readouterr().out == "WARNING!!! The oxygen level in the body is extremely low!! The patient might be dying! Seek immediate medical attention!!\n"


def test_bp(capsys):
    main_old.blood_pressure("90/35")
    assert capsys.readouterr().out == "WARNING! Low blood pressure! seek medical attention!\n"
    main_old.blood_pressure("70/25")
    assert capsys.readouterr().out == "WARNING! Low blood pressure! seek medical attention!\n"
    main_old.blood_pressure("70/15")
    assert capsys.readouterr().out == "WARNING! Low blood pressure! seek medical attention!\n"

    main_old.blood_pressure("130/85")
    assert capsys.readouterr().out == "WARNING! Prehypertension! Seek medical attention!\n"

    main_old.blood_pressure("140/90")
    assert capsys.readouterr().out == "WARNING! High blood pressure! Seek medical attention!\n"
    main_old.blood_pressure("145/90")
    assert capsys.readouterr().out == "WARNING! High blood pressure! Seek medical attention!\n"
    main_old.blood_pressure("140/95")
    assert capsys.readouterr().out == "WARNING! High blood pressure! Seek medical attention!\n"
    main_old.blood_pressure("145/95")
    assert capsys.readouterr().out == "WARNING! High blood pressure! Seek medical attention!\n"

    main_old.blood_pressure("120/60")
    assert capsys.readouterr().out == "Isolated systolic hypertension! Normal for older people, but further tests should be performed.\n"
    main_old.blood_pressure("120/70")
    assert capsys.readouterr().out == "Isolated systolic hypertension! Normal for older people, but further tests should be performed.\n"
    main_old.blood_pressure("120/90")
    assert capsys.readouterr().out == """Isolated systolic hypertension! Normal for older people, but further tests should be performed.
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""
    main_old.blood_pressure("125/60")
    assert capsys.readouterr().out == """Isolated systolic hypertension! Normal for older people, but further tests should be performed.
WARNING! Wide pulse pressure! Seek medical attention!\n"""
    main_old.blood_pressure("125/70")
    assert capsys.readouterr().out == "Isolated systolic hypertension! Normal for older people, but further tests should be performed.\n"
    main_old.blood_pressure("125/90")
    assert capsys.readouterr().out == """Isolated systolic hypertension! Normal for older people, but further tests should be performed.
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""

    main_old.blood_pressure("100/50")
    assert capsys.readouterr().out == "Isolated diastolic blood pressure! Seek medical attention.\n"

    main_old.blood_pressure("136/95")
    assert capsys.readouterr().out == "Diastolic blood pressure is high, which could be an indicator of heart disease or stroke. Seek medical attention.\n"

    # main_old.blood_pressure("90/60")
    # assert capsys.readouterr().out == "Blood pressure is normal.\n"
    main_old.blood_pressure("115/60")
    assert capsys.readouterr().out == "Blood pressure is normal.\n"
    # main_old.blood_pressure("120/60")
    # assert capsys.readouterr().out == "Blood pressure is normal.\n"
    #--
    # main_old.blood_pressure("90/70")
    # assert capsys.readouterr().out == "Blood pressure is normal.\n"
    main_old.blood_pressure("115/70")
    assert capsys.readouterr().out == "Blood pressure is normal.\n"
    # main_old.blood_pressure("120/70")
    # assert capsys.readouterr().out == "Blood pressure is normal.\n"
    #--
    main_old.blood_pressure("90/80")
    assert capsys.readouterr().out == """Blood pressure is normal.
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""
    main_old.blood_pressure("115/80")
    assert capsys.readouterr().out == """Blood pressure is normal.
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""
    # main_old.blood_pressure("120/80")
    # assert capsys.readouterr().out == "Blood pressure is normal.\n"
    main_old.blood_pressure("120/80")
    assert capsys.readouterr().out == """Isolated systolic hypertension! Normal for older people, but further tests should be performed.
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""

    main_old.blood_pressure("10/8")
    assert capsys.readouterr().out == """WARNING!!! The blood pressure is extremely low!! The patient might be dying! Seek immediate medical attention!!
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""
    main_old.blood_pressure("9/8")
    assert capsys.readouterr().out == """WARNING!!! The blood pressure is extremely low!! The patient might be dying! Seek immediate medical attention!!
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""
    main_old.blood_pressure("12/10")
    assert capsys.readouterr().out == """WARNING!!! The blood pressure is extremely low!! The patient might be dying! Seek immediate medical attention!!
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""
    main_old.blood_pressure("12/8")
    assert capsys.readouterr().out == """WARNING!!! The blood pressure is extremely low!! The patient might be dying! Seek immediate medical attention!!
Low pulse pressure! It can be a sign of a poorly functioning heart! Seek medical attention\n"""

def test_fix(capsys):
    main_old.input = lambda input_val: 'fixed'
    # main_old.input = lambda input_val, input2: 'fixe4d', 'fixed'
    main_old.fix_monitor()
    assert capsys.readouterr().out == "The sensor gives wrong data and seems to be broken.\n\n"
    # with mock.patch.object(__builtins__, 'input', lambda: 'some_input'):
    #     assert main_old.fix_monitor() == 'expected_output'




#-----------

# inputs = (i for i in ["1", "1", "fixed", "724"])
# def mock_inputs(prompt):
#     return next(inputs)


# def test_fix0(capsys):
#         main_old.input = lambda value: next(inputs)
        # hasError = main_old.fix_monitor()
        # assert hasError == 444

# inputs=(i for i in ["1", "fixed"])
def test_fix(capsys):
    # with pytest.raises(StopIteration):
    # with mock.patch('builtins.input', mock_inputs):
    inputs=(i for i in ["fixed"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        main_old.fix_monitor()
        assert capsys.readouterr().out == "The sensor gives wrong data and seems to be broken.\n\n"

def test_fix2(capsys):
    inputs=(i for i in ["ok", "fixed"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        main_old.fix_monitor()
        assert capsys.readouterr().out == """The sensor gives wrong data and seems to be broken.
The sensor gives wrong data and seems to be broken.\n\n"""

def test_fix3(capsys):
    inputs=(i for i in ["ok", "done", "fixed"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        main_old.fix_monitor()
        assert capsys.readouterr().out == """The sensor gives wrong data and seems to be broken.
The sensor gives wrong data and seems to be broken.
The sensor gives wrong data and seems to be broken.\n\n"""


def test_ask_input(capsys):
    inputs=(i for i in ["q"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        hasQuit = not main_old.ask_input()
        assert hasQuit == True

def test_ask_input2(capsys):
    inputs=(i for i in ["quit"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        hasQuit = not main_old.ask_input()
        assert hasQuit == True

def test_ask_input_pulse_sensor_error(capsys):
    inputs=(i for i in ["ninety", "fixed", "90", "98", "120/80"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        main_old.ask_input()
        output = capsys.readouterr().out
        assert True == output.__contains__("The pulse should be a positive integer number equal or smaller than 300.\n")
        assert True == output.__contains__("The sensor gives wrong data and seems to be broken.\n")
    
def test_ask_input_pulse_limit(capsys):
    inputs=(i for i in ["500", "fixed", "90", "98", "120/80"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        main_old.ask_input()
        output = capsys.readouterr().out
        assert True == output.__contains__("The pulse should be a positive integer number equal or smaller than 300.\n")
        assert True == output.__contains__("The sensor gives wrong data and seems to be broken.\n")
    
def test_ask_input_pulse_limit(capsys):
    inputs=(i for i in ["90", "98", "120/80"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        main_old.ask_input()
        output = capsys.readouterr().out
        assert False == output.__contains__("The pulse should be a positive integer number equal or smaller than 300.\n")
        assert False == output.__contains__("The sensor gives wrong data and seems to be broken.\n")
    
    # with mock.patch('builtins.input', lambda input: next(inputs)):
    #     hasQuit = not main_old.ask_input()
    #     # assert True == capsys.readouterr().out.__contains__("The pulse should be a positive integer number equal or smaller than 300.\n")
    #     assert False == hasQuit

def test_ask_input3(capsys):
    inputs=(i for i in ["90", "quit"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        hasQuit = not main_old.ask_input()
        assert hasQuit == True

def test_ask_input_bp_quit(capsys):
    inputs=(i for i in ["90", "98", "quit"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        hasQuit = not main_old.ask_input()
        assert hasQuit == True

def test_ask_input_correct(capsys):
    inputs=(i for i in ["90", "98", "120/80"])
    with mock.patch('builtins.input', lambda input: next(inputs)):
        hasQuit = not main_old.ask_input()
        assert hasQuit == False


# @pytest.mark.parametrize("x,y,z", [(10,5,15),(10,15,25)])
# def test_fixed(capsys, x,y,z): 
#     # assert main_old.add(x, y) == x + y
#     assert x+y == z