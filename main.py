import sqlite3
import tkinter as tk
from tkinter import messagebox, ttk
import tools.sql_functions as sql
import tools.gui as gui
import tools.sections as sect

selected_item = None
edit_entries = []

# --- GUI Setup ---
root = tk.Tk()
root.title("SQL GUI")

# Table Creation Section
creation_frame = tk.Frame(root, bd=2, relief="solid")
creation_frame.grid(row=0,column=0,sticky="nsew",ipadx=10,ipady=5)
tk.Label(creation_frame, text="Table Name").grid(row=0,column=0)
table_name_entry = tk.Entry(creation_frame)
table_name_entry.grid(row=0,column=1)
table_rows_frame = tk.Frame(creation_frame)
table_rows_frame.grid(row=1,column=0,columnspan=2)
sect.create_table_ui(table_rows_frame,table_name_entry,sql.get_table_list())

# Managing Section
manager_frame = tk.Frame(root, bd=2, relief="solid")
manager_frame.grid(row=0,column=1,sticky="nsew",ipadx=10,ipady=5)
adding_list = ["Game","Player","DLC"]
def switch_section(frame):
    for widget in frame.winfo_children():
        widget.destroy()
    match adding_var.get():
        case "Game":
            sect.game_section(frame)
        case "Player":
            sect.player_section(frame)
        case "DLC":
            sect.dlc_section(frame)
adding_var = tk.StringVar()
adding_dropdown = ttk.Combobox(manager_frame, textvariable=adding_var, values=adding_list)
adding_dropdown.bind('<<ComboboxSelected>>',lambda event : switch_section(adding_frame))
adding_dropdown.grid(row=0,column=0,columnspan=2)
adding_dropdown.set(adding_list[0])

adding_frame = tk.Frame(manager_frame)
adding_frame.grid(row=1,column=0,columnspan=2)
sect.game_section(adding_frame)

viewer_frame = tk.Frame(root, bd=2, relief="solid")
viewer_frame.grid(row=0,column=2,sticky="nsew",ipadx=10,ipady=5)
# Table name entry
tk.Label(viewer_frame, text="Table Name").grid(row=0, column=0)

# Create dropdown
table_list = sql.get_table_list()
table_var = tk.StringVar()
table_dropdown = ttk.Combobox(viewer_frame, textvariable=table_var, values=table_list, state="readonly")
table_dropdown.bind('<<ComboboxSelected>>', lambda event : gui.refresh_table(table_var.get(),table_frame,edit_frame))
table_dropdown.grid(row=0, column=1)
table_dropdown.set(table_list[0])  # Default select first table

tk.Button(viewer_frame, text="Refresh Table",
        command=lambda : gui.refresh_table(table_var.get(),table_frame,edit_frame)
        ).grid(row=1, column=0, columnspan=2) 

# Editable fields for selected row
edit_frame = tk.Frame(viewer_frame)
edit_frame.grid(row=2, column=0, columnspan=2, sticky="ew")

# Table Filter
filter_entry = tk.Entry(viewer_frame)
filter_entry.grid(row=3, column=0)
tk.Button(viewer_frame, text="Filter", command=lambda : gui.apply_filter(table_var.get(),filter_entry.get(), table_frame, edit_frame)).grid(row=5, column=1)

# Table display
table_frame = tk.Frame(viewer_frame)
table_frame.grid(row=4, column=0, columnspan=2, sticky="nsew")

gui.refresh_table(table_var.get(),table_frame,edit_frame)

request_frame = tk.Frame(root, bd=2, relief="solid")
request_frame.grid(row=0,column=3,sticky="nsew",ipadx=10,ipady=5)
# Saved Queries
comments_queries = sql.extract_queries_from_file("queries.sql")
query_descriptions = [desc for desc, _ in comments_queries]
query_dropdown = ttk.Combobox(request_frame, values=query_descriptions)
query_dropdown.grid(row=0,column=0,columnspan=2,sticky="nsew")
query_dropdown.bind("<<ComboboxSelected>>", lambda event : gui.load_query_from_dropdown(query_dropdown,sql_text,comments_queries))
# Label
tk.Label(request_frame, text="Custom SQL Query").grid(row=1, column=0, columnspan=2)

# Query input (multi-line)
sql_text = tk.Text(request_frame, height=5, width=80)
sql_text.grid(row=2, column=0, columnspan=2, padx=10, pady=5)

# Execute button
tk.Button(request_frame, text="Execute Query", command=lambda : gui.execute_custom_query(sql_text,query_result_frame)).grid(row=3, column=0, columnspan=2)

# Frame for query result
query_result_frame = tk.Frame(request_frame)
query_result_frame.grid(row=4, column=0, columnspan=2, sticky="nsew")

root.mainloop()