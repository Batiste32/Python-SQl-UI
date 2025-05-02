import sqlite3

def insert_table(table_name, columns, values, data_file="games.db"):

    conn = sqlite3.connect(data_file)
    cur = conn.cursor()
    try:
        placeholders = ", ".join(["?"] * len(columns))
        col_string = ", ".join(columns)
        command = f"INSERT INTO {table_name} ({col_string}) VALUES ({placeholders})"
        cur.execute(command, values)
        conn.commit()
        message=(True, cur.lastrowid, f"Values inserted successfully in " + table_name)
    except Exception as e:
        message=(False, None, str(e))
    finally:
        conn.close()
    return message
    
def view_table(table_name,data_file="games.db"):

    conn = sqlite3.connect(data_file)
    cur = conn.cursor()
    try:
        cur.execute(f"SELECT * FROM {table_name}")
        rows = cur.fetchall()
        columns = [description[0] for description in cur.description]
        message = (True, None, columns,rows)
    except Exception as e:
        message = (False, None, str(e))
    finally:
        conn.close()
    return(message)
    
def get_table_list(data_file="games.db"):

    conn = sqlite3.connect(data_file)
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';")
    tables = [row[0] for row in cursor.fetchall()]
    return tables

def get_field_in_table(table_name, field, data_file="games.db"):

    conn = sqlite3.connect(data_file)
    cur = conn.cursor()
    cur.execute(f"SELECT id, {field} FROM {table_name} ORDER BY id ASC")
    fields = cur.fetchall()
    return fields

def insert_in_field(table_name, columns, values, data_file="games.db"):

    conn = sqlite3.connect(data_file)
    cur = conn.cursor()
    # Build correct placeholders (?, ?, ?) depending on number of columns
    placeholders = ", ".join(["?"] * len(columns))
    columns_str = ", ".join(columns)
    query = f"INSERT INTO {table_name} ({columns_str}) VALUES ({placeholders})"
    for element in values:
        cur.execute(query, element)
    conn.commit()
    conn.close()

def extract_queries_from_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    queries = []
    current_description = None
    current_query = []

    for line in lines:
        stripped = line.strip()

        if not stripped:
            continue  # Skip empty lines

        if stripped.startswith('--'):
            current_description = stripped[2:].strip()  # remove '--'
        else:
            current_query.append(stripped)
            if ';' in stripped:  # End of SQL statement
                full_query = ' '.join(current_query).split(';')[0]  # clean after semicolon
                queries.append([current_description or "Untitled Query", full_query])
                current_query = []
                current_description = None
    return queries