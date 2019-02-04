#!/usr/bin/env python
import subprocess
import sys


def help():
    help_text = """
        Usage: ./container.py [args]
        Options are:
            -h          For help options
            configure   Will pre configure the project
            start       Will start the project
    """
    print(help_text)


def main(args):
    if "-h" in args:
        help()

    if "configure" in args:
        subprocess.call(["sudo", "chmod", "755", "get-docker.sh"])
        subprocess.call(["sh", "get-docker.sh"])
        subprocess.call(["docker-compose", "build"])

    if "start":
        subprocess.call(["docker-compose", "build"])
        subprocess.call(["docker-compose", "up"])


if __name__ == "__main__":
    main(sys.argv)
