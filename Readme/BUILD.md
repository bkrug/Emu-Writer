### External Dependencies

MEMBUF.noheader.obj and ARRAY.noheader.obj - Source code can be found at the repo: https://github.com/bkrug/TI-string-buffer.
These contain routines for allocating and de-allocating space for variable-length objects like strings and arrays.

### Assembling

* Python is required.
* XDT99 is required. (https://endlos99.github.io/xdt99/)
* Run the script "assm.py" and it will assemble the main program and the test programs.
  * Have Python and XDT99 included in your system's Path. The script is setup assuming that you can type "xas99.py" from a command line without specifying a folder.
 
*Finding the path to Python*

In your Python interpreter, type the following commands:

```
import os
import sys
os.path.dirname(sys.executable)
```

*Running Python Scripts from Powershell*

First, add the xas99 folder to your System PATH variables.

Then, associate *.py files with python.
Run the following commands at a shell prompt:

```
assoc .py=PythonScript
ftype PythonScript=C:\bin\python.exe "%1" %*
```

*Running Python Scripts from Linux*

Edit the path
```
kwrite .bashrc
```
add this code
```
if ! [[ "$PATH" =~ "$HOME/Python/xdt99:" ]]; then
    PATH="$HOME/Python/xdt99:$PATH"
fi
```

Make the scripts executable:
```
chmod +x /home/bkrug/Python/xdt99/*.py
```

*Assembly Results*

* Assembled code is placed in two places:
  * "Fiad" folder. You will be able to see each individual program as a file with the TIFILES header. 
  * "EmuWriter.dsk" image in the root folder
* the EMUWRITER program is run as an E/A 5 program
* the unit test programs (which have the suffix RUN.obj) are run as E/A 3 programs.
  * Use the program name "RUNTST".
  * Someday it would be nice to be able to run all unit tests as a single program, but for now you need to run each group of tests individualy.
* You might wonder why the EMUWRITER program is followed by so many other E/A 5 programs like EMUWRITES. This has to do with how the program is stored in RAM after loading it from a disk.
  * EMUWRITER is stored at address >2000 and occupies 6 KB.
  * The other EMUWRITE* programs are intially loaded into VDP RAM. Each of them can be pulled into the 2KB space at address >3800, when there is a need to execute them.
  * This design is meant to reserve the upper 24 KB of the TI-99's expansion RAM for the user's document. The executable code is starting to grow beyond the lower 8 KB of the expansion RAM.