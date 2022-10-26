from nis import maps
import psycopg2

try:
    # Connect to an existing database
    connection = psycopg2.connect(dbname="c5dv202_vt21_bio17sla",
                                user="c5dv202_vt21_bio17sla",
                                password="gf9uYTcrPusW",
                                host="postgres.cs.umu.se",
                                port="5432")

    # Open a cursor to perform database operations
    cursor = connection.cursor()

    database_info = connection.get_dsn_parameters()

    print("Database info : ", database_info)
except (Exception, psycopg2.DatabaseError) as error:
    print(error)
    
connection.commit()

# IMAGES -------------------------------------------------------------------------

def insert_image(filepath, filename, date_time, latitude, longitude, maps_link):

    if filepath == '':
        filepath = None

    if filename == '':
        filename = None    
    
    if date_time == '':
        date_time = None

    if latitude == '':
        latitude = None

    if longitude == '':
        longitude = None

    if maps_link == '':
        maps_link = None       
    
    try:
        cursor.execute("INSERT INTO images (filepath, filename, date_time, latitude, longitude, maps_link) VALUES(%s, %s, %s, %s, %s, %s)",
        (filepath, filename, date_time, latitude, longitude, maps_link))
    except Exception as err:
        print("Oops! An exception has occured:", err)
        print("Exception TYPE:", type(err))
        
        connection.rollback()
        return str(err)
        
    connection.commit()


# VIDEOS -------------------------------------------------------------------------

def insert_video(filepath, filename, nest_id):

    if filepath == '':
        filepath = None

    if filename == '':
        filename = None  

    if nest_id == '':
        nest_id = None       
    
    try:
        cursor.execute("INSERT INTO videos (filepath, filename, nest_id) VALUES(%s, %s, %s)",
        (filepath, filename, nest_id))
    except Exception as err:
        print("Oops! An exception has occured:", err)
        print("Exception TYPE:", type(err))
        
        connection.rollback()
        return str(err)
        
    connection.commit()


# def select_character(char_name):

#     try:
#         cursor.execute("""SELECT * FROM characters WHERE char_name='%s'""" % (char_name))
#     except Exception as err:
#         print("Oops! An exception has occured:", err)
#         print("Exception TYPE:", type(err))
    
#     selected_character = cursor.fetchone()
#     print(f"selected_characther : {select_character}")
#     connection.commit()

#     return selected_character

# def delete_characters(char_name):

#     try:
#         cursor.execute("""DELETE FROM characters WHERE char_name='%s'""" % (char_name))
#     except Exception as err:
#         print("Oops! An exception has occured:", err)
#         print("Exception TYPE:", type(err))

#         connection.rollback()
#         return

#     connection.commit()

# def update_characters(char_name, username, class_name, strength, intelligence):

#     if char_name == '':
#         char_name = None
    
#     if username == '':
#         username = None

#     if class_name == '':
#         class_name = None

#     try:
#         cursor.execute("UPDATE characters SET username=%s, classname=%s, strength=%s, intelligence=%s WHERE char_name=%s",
#             (username, class_name, strength, intelligence, char_name))

#     except Exception as err:
#         print("Oops! An exception has occured:", err)
#         print("Exception TYPE:", type(err))
        
#         connection.rollback()
#         return str(err)
#     connection.commit()

# def get_characters():
#     try:
#         cursor.execute("SELECT * FROM CHARACTERS")
#     except Exception as err:
#         print("Oops! An exception has occured:", err)
#         print("Exception TYPE:", type(err))
#         connection.rollback()
#         return
#     connection.commit()
#     return cursor.fetchall()

# Execute a command: this creates a new table
# cursor.execute("CREATE TABLE test (id serial PRIMARY KEY, num integer, data varchar);")

# Query the database and obtain data as Python objects
# cur.execute("SELECT * FROM test;")
# cur.fetchone()

# Close communication with the database
# cursor.close()
# connection.close()

