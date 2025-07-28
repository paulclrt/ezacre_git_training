import os
import myfile
import monfichier

var = os.getenv("var", "")
if var == "":
    print("ERROR: env var 'var' is not defined")
    exit(1)

monfichier.hello()

print(var)

myfile.pretty()

