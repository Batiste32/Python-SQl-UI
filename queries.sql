-- All info about platforms
SELECT * FROM Platforms;
-- All info about game 1
SELECT * FROM Games WHERE (id=1);
-- All info about games released in 2023
SELECT * FROM Games WHERE (release_date BETWEEN '2023-01-01' AND '2024-01-01');
-- List of platforms for each game
SELECT Games.title, GROUP_CONCAT(Platforms.name, ', ') AS platforms FROM Games
    JOIN Games_Platforms ON Games.id = Games_Platforms.game_id
    JOIN Platforms ON Games_Platforms.platform_id = Platforms.id
    GROUP BY Games.title;
-- All games present on Windows, Linux and Mac
SELECT Games.title FROM Games
    JOIN Games_Platforms ON Games.id = Games_Platforms.game_id
    JOIN Platforms ON Games_Platforms.platform_id = Platforms.id
    WHERE Platforms.name IN ('Windows','Linux','Mac')
    GROUP BY Games.title
    HAVING COUNT(DISTINCT Platforms.name) = 3;
-- Names of players born after 2000
SELECT username, realname FROM Players WHERE (birthday >= '2000-01-01');
-- Names of players older than 25
SELECT username, realname FROM Players WHERE (birthday <= DATE('now', '-25 years'));
-- Games played by each player
SELECT Players.realname, GROUP_CONCAT(Games.title, ', ') AS games FROM Players
    JOIN Players_Games ON Players.id = Players_Games.player_id
    JOIN Games ON Players_Games.game_id = Games.id
    JOIN Games_Platforms ON Games.id = Games_Platforms.game_id
    JOIN Platforms ON Games_Platforms.platform_id = Platforms.id
    WHERE Platforms.name = 'PS'
    GROUP BY Players.realname;
-- Players from the same family
WITH
    Extracted AS
        (SELECT realname, SUBSTR(realname, INSTR(realname, ' ') + 1) AS family_name FROM Players),
    CommonNames AS
        (SELECT family_name
        FROM Extracted
        GROUP BY family_name
        HAVING COUNT(*) > 1)
SELECT realname, family_name
FROM Extracted
WHERE family_name IN (SELECT family_name FROM CommonNames)
ORDER BY family_name;
-- List of every DLC per game
SELECT Games.title, GROUP_CONCAT(DLC.dlc_name || ' : ' || DLC.dlc_date, ' / ') AS DLCs FROM Games
    JOIN DLC ON Games.id = DLC.game_id
    GROUP BY Games.title;
-- Show Games present on both Linux and Windows
SELECT Games.title, GROUP_CONCAT(Platforms.name, ',') FROM Games
    JOIN Games_Platforms ON Games.id = Games_Platforms.game_id
    JOIN Platforms ON Games_Platforms.platform_id = Platforms.id
    WHERE Platforms.name IN ('Linux', 'Windows')
    GROUP BY Games.id
    HAVING COUNT(DISTINCT Games_Platforms.platform_id) = 2;
-- Show Minecraft players
SELECT Players.username FROM Players                        
    JOIN Players_Games ON Players.id = Players_Games.player_id
    JOIN Games ON Players_Games.game_id = Games.id
    WHERE Games.title = 'Minecraft'
-- Sort Games based on release_date decreasing
SELECT title, release_date FROM Games                       
    WHERE release_date >= '2020-01-01'
    ORDER BY release_date DESC
-- Latest DLC for each game
SELECT Games.title, DLC.dlc_name, DLC.dlc_date FROM Games   
    JOIN DLC on Games.id = DLC.game_id
    WHERE DLC.dlc_date = (
        SELECT MAX(DateMax.dlc_date)
        FROM DLC DateMax
        WHERE DateMax.game_id = Games.id
    );
-- Count the games for every platform
SELECT Platforms.name, COUNT(Games.id) FROM Platforms       
    JOIN Games_Platforms ON Platforms.id = Games_Platforms.platform_id
    JOIN Games ON Games_Platforms.game_id = Games.id
    GROUP BY Platforms.name
    ORDER BY COUNT(Games.id) DESC;
-- Pairs of players sharing a game
SELECT P1.realname AS Player1, P2.realname AS Player2, GROUP_CONCAT(G1.title, ', ') AS shared_games 
    FROM Players AS P1 
    JOIN Players_Games AS PG1 ON P1.id = PG1.player_id
    JOIN Games AS G1 ON PG1.game_id = G1.id
    JOIN Players_Games AS PG2 ON PG1.game_id = PG2.game_id AND PG1.player_id != PG2.player_id
    JOIN Players AS P2 ON PG2.player_id = P2.id
    WHERE P1.id < P2.id
    GROUP BY P1.realname, P2.realname;
-- The genres played by each person
SELECT Players.realname, GROUP_CONCAT(DISTINCT Genres.genre) AS genres FROM Players 
    JOIN Players_Games ON Players.id = Players_Games.player_id
    JOIN Games ON Players_Games.game_id = Games.id
    JOIN Games_Genres ON Games.id = Games_Genres.game_id
    JOIN Genres ON Games_Genres.genre_id = Genres.id
    GROUP BY Players.realname;
-- The genre most common and the games having it
SELECT Genres.genre, GROUP_CONCAT(Games.title, ', ') AS games FROM Games 
    JOIN Games_Genres ON Games.id = Games_Genres.game_id
    JOIN Genres ON Games_Genres.genre_id = Genres.id
    WHERE Genres.id = (
        SELECT genre_id FROM Games_Genres
        GROUP BY genre_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
     );
-- Favorite genres and games fitting per player
WITH GenreCounts AS (
    SELECT 
        Players.realname AS realname, 
        Genres.genre AS genre,
        COUNT(Genres.id) AS genre_count, 
        Players.id AS player_id
    FROM Players
        JOIN Players_Games ON Players.id = Players_Games.player_id
        JOIN Games ON Players_Games.game_id = Games.id
        JOIN Games_Genres ON Games.id = Games_Genres.game_id
        JOIN Genres ON Games_Genres.genre_id = Genres.id
    GROUP BY Players.id, Genres.id
),
MaxCounts AS (
    SELECT player_id, MAX(genre_count) AS max_count
    FROM GenreCounts
    GROUP BY player_id
),
MaxGenre AS (
    SELECT gc.*
    FROM GenreCounts gc
    JOIN MaxCounts mc 
      ON gc.player_id = mc.player_id AND gc.genre_count = mc.max_count
)
SELECT 
    MaxGenre.realname,
    MaxGenre.genre AS favorite_genre,
    MaxGenre.genre_count AS genre_count,
    GROUP_CONCAT(DISTINCT Games.title) AS games_in_favorite_genre
FROM MaxGenre
JOIN Players_Games ON Players_Games.player_id = MaxGenre.player_id
JOIN Games ON Players_Games.game_id = Games.id
JOIN Games_Genres ON Games.id = Games_Genres.game_id
JOIN Genres ON Games_Genres.genre_id = Genres.id
WHERE Genres.genre = MaxGenre.genre
GROUP BY MaxGenre.player_id, MaxGenre.genre, MaxGenre.genre_count;