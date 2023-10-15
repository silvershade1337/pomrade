import mysql.connector as mariadb
import os
import json

#------------- importing configs -------//
if 'V_LOCAL' in os.environ:
    with open("lconfig.json","r") as f:
        config = json.load(f)
else:
    with open("lconfig.json","r") as f:
        config = json.load(f)

#------------- DB connections --------//

mdb = mariadb.connect(user = config['mariaDB']['username'], password = config['mariaDB']['pass'], host=config['mariaDB']['host'], port=config['mariaDB']['port'])
mcur = mdb.cursor()
#---- First time database creations -//

mcur.execute("DROP DATABASE phase1")
mcur.execute("CREATE DATABASE phase1")

# mcur.execute("CREATE DATABASE phase1")
mdb.disconnect()
mdb = mariadb.connect(user = config['mariaDB']['username'], password = config['mariaDB']['pass'], host=config['mariaDB']['host'], port=config['mariaDB']['port'], database='phase1')
mcur = mdb.cursor()
mcur.execute("CREATE TABLE user_info (usn VARCHAR(20), sem VARCHAR(5), account_number VARCHAR(15), parent_number VARCHAR(15), name VARCHAR(35), password VARCHAR(35), user_type VARCHAR(10), department VARCHAR(85), mentor VARCHAR(35), can_mentor TINYINT(1), token CHAR(128))")
mcur.execute("CREATE TABLE marks (usn VARCHAR(20), marks MEDIUMTEXT) ")
mcur.execute("CREATE TABLE attendance (usn VARCHAR(20), attendance MEDIUMTEXT) ")
mdb.commit()
