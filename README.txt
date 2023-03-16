# AutoLisp_Debugger
This is a template method for printing issues in cad software while using AutoLisp.
If your code is causing your software to crash and you are not able to retrieve the
data from it, then add this file and call the functions to safely provide you with 
the nessassary data needed to debug your code. This file contains three functions
for the user.

(GB:Print-End)

(GB:Print-Start [Print to the screen (boolean)] [Print to the File (boolean)] [Clear previous file's log (boolean)])
By default, a file is created under "C:\Users\User\Appdata\local\Temp" with the name of "AutoLisp-Print.txt" when the "Print to the File" variable is set to true.

(GB:Print [Message (string)] [Value (atom/variant)] [Force show value if nil (Boolean)] [Show the Value's variable type instead of the actual value (Boolean)])
 
Example Code: 
(setq iTest01 123)
(setq lTest02 '("Test01" "Test02" "Test03"))
(setq nTest03 nil)
(setq sTest04 "Testing a string")
 
(GB:Print-Start T nil nil)
(GB:Print "Starting the test")
(GB:Print "Test01" iTest01)
(GB:Print "Test02" lTest02 T)
(GB:Print "Test03-1" nTest03)
(GB:Print "Test03-2" nTest03 T)
(GB:Print "Test04-1" sTest04 nil nil)
(GB:Print "Test04-2" sTest04 nil T)
(GB:Print-End)
 
Example Screen Print:
Starting the test
Test01 : 123
Test02: ("Test01" "Test02" "Test03")
Test03-1
Test03-2 : nil
Test01-1 : "Testing a string"
Test04-2 : STR


Example File Print: 
Note: list variables receive an extra space around them to make them easy to read in the text file. 
Starting the test
Test01 : 123

Test02: ("Test01" "Test02" "Test03")

Test03-1
Test03-2 : nil
Test01-1 : "Testing a string"
Test04-2 : STR
