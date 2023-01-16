import os
import sys
from glob import glob
import subprocess

assert(len(sys.argv) == 2), """
    usage: python3 scripts/run_all_simulation.py test_files/
"""

result = [y for x in os.walk(sys.argv[1]) for y in glob(os.path.join(x[0], '*.cfg'))]
log_dir = os.path.join(sys.argv[1], "logs")
isExist = os.path.exists(log_dir)
if not isExist:
    os.makedirs(log_dir)

for f in sorted(result):
    logfile_path = os.path.join(log_dir, f.replace("/", "_")+".log")
    logfile = open(logfile_path, "w")
    subprocess.call(["python3", "./gen_processor.py", f], stdout=logfile)
    try:
        subprocess.call(["./scripts/csh_run_sim"], stdout=logfile)
    except AssertionError as err:
        print("Err", f)
    except:
        print("Err2", f)
    logfile.close()
