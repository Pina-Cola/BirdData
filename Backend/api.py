# file - api.py, api handling requests from the bird bundle database
# authors - Pina Kolling (), Lovisa Nyholm (c19lnm), Hanna Littorin (c19hln), Sofie Liszchka()
# date - 2022-10-28
# version - 1.0

from flask import Flask, request
import psycopg2
import json
from flask_cors import CORS

app = Flask(__name__)
FLASK_APP=app
CORS(app)
# app.config['CORS_HEADERS'] = 'Content-Type'

@app.route("/bundle/<nest>", methods=['GET'])
def bundle(nest):
    # in this function, connect to database
    # get everything that has to do with the nest id.
    # return it in json format.

    # for now just debug that it returns the exact same nest :)))
    return "your nest is " + str(nest)

# start() fetches all the nests and returns them in json format.
@app.route("/api", methods=['GET'])
def start():
    conn = None
    
    try:
        conn = psycopg2.connect("dbname='c5dv202_vt21_bio17sla' user='c5dv202_vt21_bio17sla' host='postgres.cs.umu.se' password='gf9uYTcrPusW'")
        # now that connected to database, define a cursor to be able to execute commands
        cur = conn.cursor()
        print("connected to database")
        # fetch all nests, save to list
        cur.execute("""SELECT nest_id, place,link FROM DW_nests""")
        nests = cur.fetchall()
        
          
        #dictionary.add(nests.pop())
        cur.close()
        
        list = []
        end = len(nests) 
        
        for i in range(0, end):
            row = nests.pop()
            list.append({"id": row[0], "place": row[1],"maps_link": row[2]})
            print(row[0])

        list.reverse()
        # return the list nests in json format
        return {
            'nests': list
        }
    except(Exception, psycopg2.DatabaseError) as error:
        print(error)
        return "error"
    finally:
        if conn != None:
            conn.close()
    
    


if __name__ == '__main__':
    
    app.run()
