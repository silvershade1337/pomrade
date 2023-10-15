from flask import request
import mysql.connector as mariadb
import csv


class RequestHandler():
    def __init__(self, main_connection:mariadb.MySQLConnection):
        self.main_connection = main_connection
        self.main_cursor = main_connection.cursor()
    
    def add_task(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT assigned FROM user_info WHERE username = '{data['mentee']}'""")
        return self.main_cursor.fetchone()

    def get_tasks(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT tasks FROM tasks WHERE username = '{data['username']}'""")
        return self.main_cursor.fetchone()

    def delete_task(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT * FROM marks WHERE username = '{data['username']}'""")
        return self.main_cursor.fetchone()
    
    def edit_task(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT * FROM attendance WHERE username = '{data['username']}'""")
        return self.main_cursor.fetchone()

    def get_suggestion(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT * FROM user_info WHERE username = '{data['username']}'""")
        return self.main_cursor.fetchone()
    
    def user_profile(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT * FROM user_info WHERE username = '{data['username']}'""")
        return self.main_cursor.fetchone()
    
    def user_settings(self,request:request):
        data = request.json
        self.main_cursor.execute(f"""SELECT * FROM user_info WHERE username = '{data['username']}'""")
        return self.main_cursor.fetchone()
