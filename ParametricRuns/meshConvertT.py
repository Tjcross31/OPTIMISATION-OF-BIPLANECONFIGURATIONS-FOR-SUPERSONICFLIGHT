import os
from threading import Thread
 
 
def f(name):
    if os.path.isdir(name) and name != "blank_foamcase":
        oldDir = os.getcwd()
        os.system('cd ~/OpenFOAM/tjc2017-7/run')
        os.chdir(oldDir)
        os.chdir(name)
        os.system('gmshToFoam busemann.msh')
        os.chdir(oldDir)
 
 
if __name__ == "__main__":
    dirs = os.listdir()
    for name in dirs:
        t = Thread(target=f, args=(name,))
        t.start()