#!/usr/bin/python
import os
SOURCE_DIR="/var/www/localhost/htdocs"
print("Updating %s" % (SOURCE_DIR))
os.chdir(SOURCE_DIR)
os.system("git pull")
print("Updating complete!")

