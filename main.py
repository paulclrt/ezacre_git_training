import os
import myfile
import monfichier

var = os.getenv("var", "")
if var == "":
    print("test123")
    exit(1)

monfichier.hello()

print(var)

myfile.pretty()

print("test")

