import sqlite3
import tkinter as tk
from tkinter import messagebox, ttk
import tools.sql_functions as sql

def handler(function, parameters, success, error):
    """
    Handler function executes a subfunction using the given parameters.
    The subfunction must return a tuple under this format :
        (success_state, return_value, conditional_arg)
        success_state is a boolean  
    and executes success or error function on conditional_arg depending on success_state.
    Finally, it returns the return_value.
    """
    try:
        result = function(*parameters)
        if result[0]:
            success("Success", *result[2:])
        else:
            error("Error", *result[2:])
        return(result[1])
    except Exception as e:
        error("Exception", str(e))

def refresh_table(table_name, table_frame, edit_frame):
    handler(sql.view_table, [table_name],
            lambda *args : display_table_gui(*args, table_frame, edit_frame, table_name),
            messagebox.showerror)
    
def refresh_table_list(dropdown):
    new_table_list = sql.get_table_list()
    dropdown['values'] = new_table_list
    if new_table_list:
        dropdown.set(new_table_list[0])

def on_edit(event):
    global selected_item
    selected = tree.selection()
    if not selected:
        return
    selected_item = selected[0]
    values = tree.item(selected_item, "values")
    for i, entry in enumerate(edit_entries):
        entry.delete(0, tk.END)
        entry.insert(0, values[i])

def display_table_gui(title, cols, rows, table_frame, edit_frame, table_name):
    global tree, current_columns, edit_entries
    current_columns = cols

    for widget in table_frame.winfo_children():
        widget.destroy()

    tree = ttk.Treeview(table_frame, columns=cols, show="headings")
    tree.pack(fill="both", expand=True)

    sort_directions = {col: False for col in cols}  # Track ascending/descending

    # --- Sorting function ---
    def sort_column(col):
        data = [(tree.set(item, col), item) for item in tree.get_children('')]
        reverse = sort_directions[col]

        try:
            data.sort(key=lambda t: float(t[0]), reverse=reverse)
        except ValueError:
            data.sort(key=lambda t: t[0].lower(), reverse=reverse)

        for index, (val, item) in enumerate(data):
            tree.move(item, '', index)

        # Reset all column headers
        for c in cols:
            arrow = ""
            if c == col:
                arrow = " ▲" if not reverse else " ▼"
            tree.heading(c, text=c + arrow, command=lambda _c=c: sort_column(_c))

        # Toggle direction
        sort_directions[col] = not reverse

    for col in cols:
        tree.heading(col, text=col, command=lambda _col=col: sort_column(_col))
        tree.column(col, width=100)

    # Insert data
    for row in rows:
        tree.insert("", "end", values=row)

    tree.bind("<Double-1>", on_edit)

    # Rebuild edit entry fields
    for widget in edit_frame.winfo_children():
        widget.destroy()
    edit_entries = []
    for i in range(len(cols)):
        entry = tk.Entry(edit_frame)
        entry.grid(row=0, column=i, padx=2)
        edit_entries.append(entry)

    tk.Button(edit_frame, text="Apply Edit", command=lambda : apply_edit(table_name, table_frame, edit_frame)).grid(row=1, column=0, columnspan=2)
    tk.Button(edit_frame, text="Delete Row", command=lambda : delete_row(table_name, table_frame, edit_frame)).grid(row=1, column=2, columnspan=2)

def apply_edit(table_name, table_frame, edit_frame):
    if not selected_item:
        return
    new_values = [e.get() for e in edit_entries]
    columns = current_columns
    try:
        set_clause = ", ".join([f"{col}=?" for col in columns[1:]])
        update_query = f"UPDATE {table_name} SET {set_clause} WHERE {columns[0]}=?"
        values = new_values[1:] + [new_values[0]]
        with sqlite3.connect("games.db") as conn:
            conn.execute(update_query, values)
            conn.commit()
        refresh_table(table_name, table_frame, edit_frame)
    except Exception as e:
        messagebox.showerror("Update Error", str(e))

def delete_row(table_name, table_frame, edit_frame):
    global selected_item
    if not selected_item:
        return
    values = tree.item(selected_item, "values")
    id_col = current_columns[0]
    try:
        with sqlite3.connect("games.db") as conn:
            conn.execute(f"DELETE FROM {table_name} WHERE {id_col}=?", (values[0],))
            conn.commit()
        refresh_table(table_name, table_frame, edit_frame)
    except Exception as e:
        messagebox.showerror("Delete Error", str(e))

def apply_filter(table_name, keyword, table_frame, edit_frame):
    success, cols, rows = sql.view_table(table_name)
    if success:
        filtered = [r for r in rows if any(keyword in str(v).lower() for v in r)]
        display_table_gui("Filtered", cols, filtered, table_frame, edit_frame)

def list_fields(table_name, field, listbox):
    for field in sql.get_field_in_table(table_name,field):
        listbox.insert(tk.END, f"{field[0]} - {field[1]}")

def get_id_list(listbox):
    selected_indices = listbox.curselection()
    selected_game_ids = []
    for i in selected_indices:
        game_id = int(listbox.get(i).split(" - ")[0])  # Get id from text
        selected_game_ids.append(game_id)
    return selected_game_ids

def execute_custom_query(root,sql_text,query_result_frame):
    query = sql_text.get("1.0", tk.END).strip()
    if not query:
        messagebox.showerror("Error", "Please enter a SQL query.")
        return

    try:
        with sqlite3.connect("games.db") as conn:
            cursor = conn.cursor()
            cursor.execute(query)

            if query.lower().startswith("select"):
                rows = cursor.fetchall()
                cols = [desc[0] for desc in cursor.description]

                # clear and create Treeview
                for widget in query_result_frame.winfo_children():
                    widget.destroy()
                tree = ttk.Treeview(query_result_frame, columns=cols, show="headings")
                for col in cols:
                    tree.heading(col, text=col)
                    tree.column(col, width=120)
                for row in rows:
                    tree.insert("", "end", values=row)
                tree.pack(fill="both", expand=True)
            else:
                conn.commit()
                messagebox.showinfo("Success", "Query executed successfully.")
                root.event_generate('<<TableCreated>>')
    except Exception as e:
        messagebox.showerror("Query Error", str(e))

def load_query_from_dropdown(dropdown,text,loaded_queries):
    index = dropdown.current()
    if index >= 0:
        text.delete("1.0", tk.END)
        text.insert(tk.END, loaded_queries[index][1])