#pip3 install python-docx

import psycopg2
from docx import Document
import re



# connects to database
try:
    conn = psycopg2.connect("dbname='c5dv202_vt21_bio17sla' user='c5dv202_vt21_bio17sla' host='postgres.cs.umu.se' password='gf9uYTcrPusW'")
    print("I am connected to the database")
except:
    print("I am unable to connect to the database")

# now that connected to database, define a cursor to be able to execute commands
cur = conn.cursor()


def add_rapport(nest_ID, description):

    try:
        cur.execute("INSERT INTO fejkrapport_docx (nest_ID, description) VALUES (%s, %s)",(nest_ID, description))
        conn.commit() # <- We MUST commit to reflect the inserted data
    except:
        print("Could not execute command")



text = " "

document = Document("BirdData/Data/Rapporter/Fejkrapport.docx")

for p in document.paragraphs:

    nest_id = " "

    x = re.search("STP 2022/", p.text)
    if  x:
        text = p.text.split('/')
        text = text[1].split(' ')
        nest_id = "STP 2022/" + text[0]

        add_rapport(nest_id, p.text)
