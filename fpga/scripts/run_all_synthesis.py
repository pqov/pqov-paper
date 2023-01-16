import os
import sys
from glob import glob
import subprocess

assert(len(sys.argv) == 2), """
    usage: python3 scripts/run_all_synthesis.py test_files/
"""

result = [y for x in os.walk(sys.argv[1]) for y in glob(os.path.join(x[0], '*.cfg'))]

for f in sorted(result):
    logfile_path = f.replace("/", "_") + ".txt"
    logfile = open(logfile_path, "w")
    subprocess.call(["python3", "./gen_processor.py", f], stdout=logfile)
    try:
        subprocess.call(["./scripts/run_synthesis"], stdout=logfile)
    except AssertionError as err:
        print("Err", f)
    except:
        print("Err2", f)
    logfile.close()
