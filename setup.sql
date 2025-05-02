CREATE TABLE Platforms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL
);
INSERT INTO Platforms (name) VALUES 
    ('Windows'), ('Linux'), ('Mac'), 
    ('PS'), ('XBox'), ('Switch'),
    ('Android'), ('iOS');

CREATE TABLE Games (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT UNIQUE NOT NULL,
    style TEXT NOT NULL,
    developper TEXT NOT NULL,
    release_date DATE
);
INSERT INTO Games (title, style, developper, release_date) VALUES 
    ('Odysseus', 'Lovecraftian Visual Novel', 'Me', '2024-11-10'),
    ('Fate s Gambit', 'Medieval Deck Building Roguelite', 'Me', '2023-06-18'),
    ('Overcooked', 'Co-op Cooking Simulation', 'Ghost Town Games', '2016-08-03'),
    ('Worms W.M.D', 'Turn-Based Artillery Strategy', 'Team17', '2016-08-23'),
    ('Baldur s Gate 3', 'Role-Playing Game (RPG)', 'Larian Studios', '2023-08-03'),
    ('Everhood', 'Musical Adventure RPG', 'Chris Nordgren & Jordi Roca', '2021-03-04'),
    ('Minecraft', 'Sandbox Survival', 'Mojang Studios', '2011-11-18'),
    ('Cultist Simulator', 'Narrative Card Game', 'Weather Factory', '2018-05-31'),
    ('Dredge', 'Lovecraftian Fishing RPG', 'Black Salt Games', '2023-03-30'),
    ('Genshin Impact', 'Fantasy Action RPG', 'miHoYo', '2020-09-28'),
    ('Hades', 'Action Roguelike Dungeon Crawler', 'Supergiant Games', '2020-09-17'),
    ('Stardew Valley', 'Farming Life Simulation RPG', 'ConcernedApe', '2016-02-26'),
    ('Hollow Knight', 'Metroidvania Action-Adventure', 'Team Cherry', '2017-02-24'),
    ('Disco Elysium', 'Narrative Role-Playing Game', 'ZA/UM', '2019-10-15'),
    ('Slay the Spire', 'Deck-Building Roguelike', 'MegaCrit', '2019-01-23'),
    ('Celeste', 'Precision Platformer', 'Extremly OK Games', '2018-01-25'),
    ('Outer Wilds', 'Exploration Mystery Adventure', 'Mobius Digital', '2019-05-28'),
    ('Return of the Obra Dinn', 'Mystery Puzzle Investigation', 'Lucas Pope', '2018-10-18'),
    ('Spiritfarer', 'Management Simulation Adventure', 'Thunder Lotus Games', '2020-08-18'),
    ('Papers Please', 'Dystopian Document Thriller', 'Lucas Pope', '2013-08-08');

CREATE TABLE Games_Platforms (
    game_id INTEGER NOT NULL,
    platform_id INTEGER NOT NULL,
    PRIMARY KEY (game_id, platform_id),
    FOREIGN KEY (game_id) REFERENCES Games(id),
    FOREIGN KEY (platform_id) REFERENCES Platforms(id)
);
CREATE INDEX idx_game_platforms_game_id ON Games_Platforms(game_id);
CREATE INDEX idx_game_platforms_platform_id ON Games_Platforms(platform_id);
INSERT INTO Games_Platforms (game_id, platform_id) VALUES
    (1,1),(2,1),                                            -- Odysseus and Fate's gambit
    (3,1),(3,4),(3,5),(3,6),                                -- Overcooked
    (4,1),(4,2),(4,3),(4,4),(4,5),(4,6),                    -- Worms WMD
    (5,1),(5,3),(5,4),(5,5),                                -- Baldur's Gate 3
    (6,1),(6,4),(6,5),(6,6),                                -- Everhood
    (7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8),        -- Minecraft
    (8,1),(8,2),(8,3),(8,7),(8,8),                          -- Cultist Simulator
    (9,1),(9,4),(9,5),(9,6),                                -- Dredge
    (10,1),(10,4),(10,5),(10,7),(10,8),                     -- Genshin Impact
    (11,1),(11,3),(11,4),(11,5),(11,6),(11,8),              -- Hades
    (12,1),(12,2),(12,3),(12,4),(12,5),(12,6),(12,7),(12,8),-- Stardew Valley
    (13,1),(13,2),(13,3),(13,4),(13,5),(13,6),              -- Hollow Knight
    (14,1),(14,3),(14,4),(14,5),(14,6),                     -- Disco Elysium
    (15,1),(15,2),(15,3),(15,4),(15,5),(15,6),(15,7),(15,8),-- Slay The Spire
    (16,1),(16,2),(16,3),(16,4),(16,5),(16,6),              -- Celeste
    (17,1),(17,2),(17,4),(17,5),(17,6),                     -- Outer Wilds  
    (18,1),(18,3),(18,4),(18,5),(18,6),                     -- Return of the Obra Dinn
    (19,1),(19,2),(19,3),(19,4),(19,5),(19,6),              -- Spiritfarer
    (20,1),(20,2),(20,3),(20,7),(20,8);                     -- Papers, Please

CREATE TABLE DLC (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_id INTEGER,
    dlc_name TEXT NOT NULL,
    dlc_date DATE NOT NULL,
    dlc_description TEXT,
    FOREIGN KEY (game_id) REFERENCES Games(id)
);
INSERT INTO DLC (game_id, dlc_name, dlc_date, dlc_description) VALUES
    (3,'The Lost Morsel','2016-09-15','Adds a new jungle world with six levels and a helicopter chef character.'),(3,'Festive Seasoning','2016-12-06','A holiday-themed update featuring festive recipes, snow-covered kitchens, and winter cheer.'),(3,'All You Can Eat','2020-11-12','A remastered collection of all Overcooked content with enhanced visuals and accessibility options.'),
    (4,'All-Stars Pack','2016-08-23','Includes exclusive weapons and outfits inspired by other Team17 games.'),(4,'Liberation Pack','2016-12-07','Adds a new theme, campaign missions, and funky weapons like the balloon and hammerhead.'),(4,'Forts Pack','2017-03-07','Introduces new fort layouts, themed missions, and defensive strategies in fort mode.'),
    (6,'Eternity Edition','2023-12-01','Adds new rhythm-based boss fights and story content expanding the musical journey.'),
    (8,'The Dancer','2018-10-16','Explore the realm of bodily transformation and forbidden performance art in the occult cabaret.'), (8,'The Priest','2019-05-30','Embrace zealotry and guide a cult through divine visions and dangerous faith.'), (8,'The Ghoul','2019-05-30','Scavenge the dead for power, building rituals from decay and bone.'), (8,'The Exile','2020-05-27','A survival-focused story of betrayal, flight, and occult escape across cities.'), (8,'The Lady Afterwards','2021-09-18','A standalone tabletop RPG set in 1920s Alexandria, focusing on archaeology and esoteric ruins.'),
    (9,'The Pale Reach','2023-10-05','A standalone tabletop RPG set in 1920s Alexandria, focusing on archaeology and esoteric ruins.'), (9,'The Iron Rig','2024-08-15','Introduces a new side-story with over 50 new fish, ship upgrades, and a mysterious Dark Liquid threatening the region.'),
    (13,'Godmaster','2018-08-23','Introduces epic boss rushes, new endings, and divine challenges.'), (13,'Lifeblood','2018-04-20','A quality-of-life update with balance tweaks and a secret boss.'),(13,'The Grimm Troupe','2017-10-26','A haunting carnival arrives, bringing powerful charms and fiery allies.'),(13,'Hidden Dreams','2017-08-03','Adds dream bosses, fast travel, and hidden lore in the deepest corners of Hallownest.'),
    (14,'The Final Cut','2021-03-30','Full voice acting, new political quests, and expanded content for the definitive edition.​'),
    (16,'Farewell','2019-01-25','A final, challenging chapter offering emotional closure and advanced mechanics.'),
    (17,'Echoes of the Eye','2021-09-28','A mysterious hidden exhibit reveals a secret civilization and terrifying truths.'),
    (19,'Lily Update','2021-04-20','Introduces Stella’s younger sister and expands the narrative on moving forward.'),(19,'Beverly Update','2021-07-20','Adds a new spirit, new buildings, and quality-of-life improvements.'),(19,'Jackie & Daria Update','2021-12-13','Final content drop with two unique spirits and a hospital-themed island.');

CREATE TABLE Genres (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre TEXT NOT NULL UNIQUE,
    descrip TEXT NOT NULL UNIQUE
);
INSERT INTO Genres (genre, descrip) VALUES 
    ('Action','Focuses on fast-paced gameplay requiring quick reflexes and coordination.'),                 --1
    ('Adventure','Story-driven games with exploration, puzzle-solving, and narrative.'),                    --2
    ('RPG','Role-Playing Games with character progression, quests, and decision-making.'),                  --3
    ('Strategy','Emphasizes planning, tactics, and resource management. Can be turn-based or real-time.'),  --4
    ('Simulation','Mimics real-world activities like flying, farming, or running a business.'),             --5
    ('Survival','Players must manage health, resources, and threats to stay alive.'),                       --6
    ('Horror','Designed to evoke fear and tension, often with limited resources or threats.'),              --7
    ('Puzzle','Gameplay centered around solving logic-based or spatial problems.'),                         --8
    ('Platformer','Involves navigating environments by jumping between platforms.'),                        --9
    ('Shooter','Focuses on ranged combat; includes first-person and third-person perspectives.'),           --10
    ('Fighting','One-on-one combat games, often in an arena with combo systems.'),                          --11
    ('Racing','Compete in vehicle races, emphasizing speed and control.'),                                  --12
    ('MMO','Massively Multiplayer Online games with large-scale player interaction.'),                      --13
    ('Deckbuilding','Games where players build a card deck as a central mechanic.'),                        --14
    ('Metroidvania','2D exploration games with progressive ability-based access to areas.'),                --15
    ('Roguelike','Games with permadeath, procedural generation, and high difficulty.'),                     --16
    ('Narrative','Emphasizes storytelling, branching paths, and dialogue choices.'),                        --17
    ('Sandbox','Open-ended games allowing creativity and freedom without strict objectives.'),              --18
    ('Party','Designed for multiplayer fun, often in short competitive or cooperative rounds.'),            --19
    ('Music/Rhythm','Games based on timed inputs to music or rhythmic patterns.');                          --20

CREATE TABLE Games_Genres (
    game_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (game_id, genre_id),
    FOREIGN KEY (game_id) REFERENCES Games(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);
INSERT INTO Games_Genres (game_id, genre_id) VALUES
    (1,2),(1,3),(1,7),(1,17),
    (2,14),(2,16),(2,17),
    (3,1),(3,5),(3,19),
    (4,4),(4,10),(4,19),
    (5,2),(5,3),(5,17),
    (6,1),(6,3),(6,20),
    (7,2),(7,3),(7,18),
    (8,5),(8,16),(8,17),
    (9,2),(9,3),(9,7),
    (10,1),(10,2),(10,3),
    (11,1),(11,3),(11,17),
    (12,3),(12,5),(12,17),(12,18),
    (13,1),(13,3),(13,15),
    (14,2),(14,3),(14,17),
    (15,4),(15,14),(15,15),
    (16,2),(16,8),(16,9),
    (17,2),(17,8),(17,17),
    (18,2),(18,8),(18,17),
    (19,4),(19,8),(19,18),
    (20,5),(20,17);

CREATE TABLE Players (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    realname TEXT,
    country TEXT,
    birthday DATE
);
INSERT INTO Players (username, realname, country, birthday) VALUES
    ('Batiste32', 'Batiste Augereau', 'FR', '2002-04-02'),
    ('EmpereurLac32', 'Simon Augereau', 'FR', '1972-05-18'),
    ('1207', 'Camille Costenaro', 'FR', '2001-07-12'),
    ('Vince', 'Vincent Ladouceur', 'QC', '1992-05-05'),
    ('PixelFox', 'Lena Gruber', 'DE', '1997-09-23'),
    ('ShadowFang', 'Akira Tanaka', 'JP', '1994-01-14'),
    ('MapleKnight', 'Jean Tremblay', 'CA', '1988-11-02'),
    ('TacoWizard', 'Carlos Ortega', 'MX', '2000-06-19'),
    ('ArcticOwl', 'Erik Johansen', 'NO', '1996-02-28'),
    ('TeaMage', 'Amelia Wright', 'GB', '1999-04-11'),
    ('DesertWolf', 'Layla Al-Farsi', 'SA', '1995-08-07'),
    ('BlueLagoon', 'Noa Levi', 'IL', '2003-10-05'),
    ('FalafelKing', 'Yousef Nasser', 'EG', '1990-12-21'),
    ('SunburnedSloth', 'Mia Rossi', 'IT', '2001-03-16');

CREATE TABLE Players_Games (
    player_id INTEGER NOT NULL,
    game_id INTEGER NOT NULL,
    PRIMARY KEY (player_id, game_id),
    FOREIGN KEY (player_id) REFERENCES Players,
    FOREIGN KEY (game_id) REFERENCES Games
);
INSERT INTO Players_Games (player_id, game_id) VALUES
    (1,1),(1,2),(1,3),(1,4),(1,5),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,17),
    (2,3),(2,5),
    (3,7),(3,10),
    (4,3),(4,4),(4,6),
    (5,4),(5,7),(5,13),(5,18),
    (6,3),(6,9),(6,15),(6,19),
    (7,6),(7,12),(7,16),
    (8,5),(8,8),(8,11),(8,20),(8,17),
    (9,4),(9,10),(9,14),(9,18),(9,19),(9,20),
    (10,3),(10,6),(10,9),(10,15),
    (11,5),(11,8),(11,11),
    (12,7),(12,13),(12,14),(12,16),
    (13,6),(13,9),(13,10),(13,19),(13,20),
    (14,3),(14,5),(14,17),
    (15,4),(15,11),(15,13),(15,18),(15,20);

CREATE TABLE Localisation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country_code TEXT NOT NULL UNIQUE,
    country_name TEXT NOT NULL UNIQUE,
    lang TEXT NOT NULL
);
INSERT INTO Localisation (country_code,country_name,lang) VALUES
    ('FR','France','français'), ('QC','Quebec','français'), ('BE', 'Belgium', 'français'),
    ('CA','Canada','english'), ('UK','United Kingdom','english'), ('US', 'United States', 'english'), ('IN', 'India', 'english'), ('AU', 'Australia', 'english'),
    ('ES', 'Spain', 'español'), ('MX', 'Mexico', 'español'), ('AR', 'Argentina', 'español'),
    ('BR', 'Brazil', 'português'), ('PT', 'Portugal', 'português'),
    ('DE', 'Germany', 'deutsch'), ('CH', 'Switzerland', 'deutsch'),
    ('IT', 'Italy', 'italiano'),
    ('RU', 'Russia', 'русский'),
    ('CN', 'China', '中文'),
    ('JP', 'Japan', '日本語'),
    ('KR', 'South Korea', '한국어');