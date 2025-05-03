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

def execute_query(query):
    try:
        with sqlite3.connect("games.db") as conn:
            cursor = conn.cursor()
            cursor.execute(query)

            if query.lower().startswith("select"):
                pass
            else:
                conn.commit()
    except Exception as e:
        raise(e)

def build_table(table_name,field_rows):
    columns_sql = []
    foreign_keys = []

    for row in field_rows:
        name = row['name'].get()
        type_ = row['type'].get()
        pk = row['pk'].get()
        ai = row['ai'].get()
        nn = row['not_null'].get()
        fk = row['fk'].get()

        if not name or not type_:
            continue  # Skip empty or incomplete rows

        col_def = f"{name} {type_}"
        if pk:
            col_def += " PRIMARY KEY"
        if ai:
            col_def += " AUTOINCREMENT"
        if nn:
            col_def += " NOT NULL"
        columns_sql.append(col_def)

        if fk:
            foreign_keys.append(f"FOREIGN KEY ({name}) REFERENCES {fk}(id)")

    full_sql = f"CREATE TABLE {table_name} (\n  " + ",\n  ".join(columns_sql + foreign_keys) + "\n);"
    execute_query(full_sql)