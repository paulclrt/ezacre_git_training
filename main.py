import os

var = os.getenv("var", "")
if var == "":
    print("ERROR: env var 'var' is not defined")
    exit(1)
print(var)
