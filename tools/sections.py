import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
from tkcalendar import DateEntry
from datetime import datetime
import tools.sql_functions as sql
import tools.gui as gui
import sqlite3

def player_section(frame):
    # Input Fields
    tk.Label(frame, text="Username").grid(row=0, column=0)
    tk.Label(frame, text="Real Name").grid(row=1, column=0)
    tk.Label(frame, text="Country").grid(row=2, column=0)
    tk.Label(frame, text="Birthday (YYYY-MM-DD)").grid(row=3, column=0)

    entry_username = tk.Entry(frame)
    entry_realname = tk.Entry(frame)
    entry_country = tk.Entry(frame)
    birthday_date_picker = DateEntry(frame, date_pattern='yyyy-mm-dd')

    entry_username.grid(row=0, column=1)
    entry_realname.grid(row=1, column=1)
    entry_country.grid(row=2, column=1)
    birthday_date_picker.grid(row=3, column=1)

    # Load all games
    game_listbox = tk.Listbox(frame, selectmode="multiple", exportselection=False, width=40, height=10)
    game_listbox.grid(row=4, column=0, columnspan=2, sticky="nsew")
    gui.list_fields("Games","title",game_listbox)

    def add_player_sequence():
        player_id = gui.handler(sql.insert_table,
                            ["Players",
                            ["username", "realname", "country", "birthday"],
                            [entry_username.get(), entry_realname.get(), entry_country.get(), birthday_date_picker.get()]
                            ],
                            messagebox.showinfo, messagebox.showerror)
        game_list = gui.get_id_list(game_listbox)
        id_pairs = [(player_id,game_id) for game_id in game_list]
        sql.insert_in_field("Players_Games",["player_id","game_id"],id_pairs)

    tk.Button(frame, text="Add Player", command=add_player_sequence).grid(row=5, column=0, columnspan=2)

def game_section(frame):
    # Input Fields
    tk.Label(frame, text="Game Title").grid(row=0, column=0)
    tk.Label(frame, text="Style/Genre").grid(row=1, column=0)
    tk.Label(frame, text="Developper").grid(row=2, column=0)
    tk.Label(frame, text="Release Date (YYYY-MM-DD)").grid(row=3, column=0)

    entry_title = tk.Entry(frame)
    entry_style = tk.Entry(frame)
    entry_developper = tk.Entry(frame)
    date_picker = DateEntry(frame, date_pattern='yyyy-mm-dd')

    entry_title.grid(row=0, column=1)
    entry_style.grid(row=1, column=1)
    entry_developper.grid(row=2, column=1)
    date_picker.grid(row=3, column=1)

    # Load all genres
    genres_listbox = tk.Listbox(frame, selectmode="multiple", exportselection=False, width=40, height=10)
    genres_listbox.grid(row=4, column=0, columnspan=2, sticky="nsew")
    gui.list_fields("Genres","genre",genres_listbox)

    # Load all platforms
    platforms_listbox = tk.Listbox(frame, selectmode="multiple", exportselection=False, width=40, height=10)
    platforms_listbox.grid(row=5, column=0, columnspan=2, sticky="nsew")
    gui.list_fields("Platforms","name",platforms_listbox)

    def add_game_sequence():
        game_id = gui.handler(sql.insert_table,
                            ["Games",
                            ["title", "style", "developper", "release_date"],
                            [entry_title.get(), entry_style.get(), entry_developper.get(), date_picker.get()]
                            ],
                            messagebox.showinfo, messagebox.showerror)
        genre_list = gui.get_id_list(genres_listbox)
        id_pairs = [(game_id,genre_id) for genre_id in genre_list]
        sql.insert_in_field("Games_Genres",["game_id","genre_id"],id_pairs)
        platform_list = gui.get_id_list(platforms_listbox)
        id_pairs = [(game_id,platform_id) for platform_id in platform_list]
        sql.insert_in_field("Games_Platforms",["game_id","platform_id"],id_pairs)

    tk.Button(frame, text="Add Game", command=add_game_sequence).grid(row=6, column=0, columnspan=2)

def dlc_section(frame):
    # Input Fields
    tk.Label(frame, text="Game").grid(row=0,column=0)
    gamename_var = tk.StringVar()
    gameid_var = tk.IntVar()
    game_list = sql.get_field_in_table("Games", "title")
    def get_info_from_game():
        gameid_var.set(int(gamename_var.get().split(' ')[0]))
        with sqlite3.connect("games.db") as conn:
            cur = conn.cursor()
            cur.execute("SELECT release_date FROM Games WHERE id = ?", (gameid_var.get(),))
            result = cur.fetchone()
        if result and result[0]:
            date = datetime.strptime(result[0], "%Y-%m-%d").date()
            date_picker.config(mindate=date)
    game_dropdown = ttk.Combobox(frame, textvariable=gamename_var, values=game_list)
    game_dropdown.bind('<<ComboboxSelected>>', lambda event : get_info_from_game())
    game_dropdown.grid(row=0, column=1)
    tk.Label(frame, text="DLC Name").grid(row=1, column=0)
    tk.Label(frame, text="DLC Date (YYYY-MM-DD)").grid(row=2, column=0)
    tk.Label(frame, text="DLC Description").grid(row=3, column=0)

    entry_dlcname = tk.Entry(frame)
    date_picker = DateEntry(frame, date_pattern='yyyy-mm-dd')
    entry_description = tk.Entry(frame)

    entry_dlcname.grid(row=1, column=1)
    date_picker.grid(row=2, column=1)
    entry_description.grid(row=3, column=1)

    tk.Button(frame, text="Add DLC", command=lambda :
              gui.handler(sql.insert_table,
                            ["DLC",
                            ["game_id", "dlc_name", "dlc_date", "dlc_description"],
                            [gameid_var.get(), entry_dlcname.get(), date_picker.get(), entry_description.get()]
                            ],
                            messagebox.showinfo, messagebox.showerror)).grid(row=4, column=0, columnspan=2)