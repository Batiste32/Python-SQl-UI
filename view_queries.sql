CREATE VIEW Games_Platforms_View AS
    SELECT Games.title AS game, GROUP_CONCAT(Platforms.name, ', ') AS platforms FROM Games
        JOIN Games_Platforms ON Games.id = Games_Platforms.game_id
        JOIN Platforms ON Games_Platforms.platform_id = Platforms.id
        GROUP BY Games.id;

CREATE VIEW Games_Genres_View AS
    SELECT Games.title AS game, GROUP_CONCAT(Genres.genre, ', ') AS genres FROM Games
        JOIN Games_Genres ON Games.id = Games_Genres.game_id
        JOIN Genres ON Games_Genres.genre_id = Genres.id
        GROUP BY Games.id;

CREATE VIEW Players_Genres_View AS
    SELECT Players.realname, Players.username, GROUP_CONCAT(DISTINCT Genres.genre) AS genres FROM Players
        JOIN Players_Games ON Players.id = Players_Games.player_id
        JOIN Games ON Players_Games.game_id = Games.id
        JOIN Games_Genres ON Games.id = Games_Genres.game_id
        JOIN Genres ON Games_Genres.genre_id = Genres.id
        GROUP BY Players.id;

CREATE VIEW Games_DLCS_View AS
    SELECT Games.title AS game, DLC.dlc_name, DLC.dlc_date FROM Games
        JOIN DLC ON Games.id = DLC.game_id;
