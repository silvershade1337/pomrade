from flask import Flask, request, Response
import mysql.connector as mariadb
import os
import json
from utilities.handlers import RequestHandler

#------------- importing configs -------//
if 'V_LOCAL' in os.environ:
    with open("lconfig.json","r") as f:
        config = json.load(f)
else:
    with open("lconfig.json","r") as f:
        config = json.load(f)

#------------- DB connections --------//

mdbp1 = mariadb.connect(user = config['mariaDB']['username'], password = config['mariaDB']['pass'], host=config['mariaDB']['host'], port=config['mariaDB']['port'], database='phase1')
mcp1 = mdbp1.cursor()

#------- Creating some global vars ---//

mcp1.execute("SELECT token FROM user_info")
tokens = mcp1.fetchall()
dbhand = RequestHandler(mdbp1)

#------------- Flask routes ----------//

app = Flask(__name__)

@app.route('/login',methods = ['POST'])
def login():
    if request.method == 'POST':
        data = request.json
        mcp1.execute(f"SELECT password,token FROM user_info WHERE EXISTS (SELECT username FROM user_info WHERE username = {data['username']})")
        password,token = mcp1.fetchone[0]
        if data['password'] == password:
            return Response({'auth':'success','token':f'{token}'},status=200,mimetype="application/json")
        else:
            return Response({'auth':'failed','token':''},status=403,mimetype="application/json")


@app.route('/api/<method>', methods = ['GET'])
def api(method):
    if request.method== 'GET':
        if method == 'add_task':
            return Response(dbhand.add_task(request),status=200,mimetype="application/json")
        elif method == 'get_tasks':
            return Response(dbhand.get_tasks(request),status=200,mimetype="application/json")
        elif method == 'delete_task':
            return Response(dbhand.delete_task(request),status=200,mimetype="application/json")
        elif method == 'edit_task':
            return Response(dbhand.edit_task(request),status=200,mimetype="application/json")
        elif method == 'get_suggestion':
            return Response(dbhand.get_suggestion(request),status=200, mimetype='application/json')
        elif method == 'user_profile':
            return Response(dbhand.user_profile(request),status=200, mimetype='application/json')
        elif method == 'user_settings':
            return Response(dbhand.user_settings(request),status=200, mimetype='application/json')
        else:
            return Response({"error":"404", "message":"API endpoint not found"}, status=404, mimetype='application/json')
    return 0

if __name__ == '__main__':
    app.run(debug="True")