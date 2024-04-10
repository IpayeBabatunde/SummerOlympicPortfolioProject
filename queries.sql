CREATE TABLE OLYMPICS_HISTORY (
    id INT,
    name VARCHAR(50),
    sex VARCHAR(1),
    height VARCHAR(20),
    weight VARCHAR(20),
    team VARCHAR(50),
    games VARCHAR(50),
    year INT,
    season VARCHAR(50),
    city VARCHAR(70),
    sport VARCHAR(100),
    event VARCHAR(80),
    medal VARCHAR(50)
);

CREATE TABLE OLYMPICS_HISTORY_NOC_REGION (
    noc VARCHAR(50),
    region VARCHAR(50),
    notes VARCHAR(80)
);

SELECT * FROM OLYMPICS_HISTORY;

SELECT * FROM OLYMPICS_HISTORY;
SELECT * FROM OLYMPICS_HISTORY_NOC_REGION;

ALTER TABLE OLYMPICS_HISTORY_NOC_REGION ADD COLUMN note VARCHAR(30);

    SELECT DISTINCT OLYMPICS_HISTORY.games
    FROM OLYMPICS_HISTORY
    WHERE season = 'Summer' ORDER BY games;

-- total Summer games in the olympic
SELECT COUNT(DISTINCT games) as Total_Summer_Games
    FROM OLYMPICS_HISTORY
    WHERE season = 'Summer' ORDER BY games;

SELECT DISTINCT sport, games
    FROM OLYMPICS_HISTORY
    WHERE season = 'Summer'ORDER BY games;

WITH t1 AS (SELECT COUNT(DISTINCT games) FROM OLYMPICS_HISTORY AS total_Summmer_games)
    SELECT COUNT(DISTINCT games) FROM OLYMPICS_HISTORY AS total_summer_games
    WHERE season = 'Summer';

-- Sport Played in each year in the olympics
WITH t2 AS (SELECT DISTINCT OLYMPICS_HISTORY.sport, OLYMPICS_HISTORY.games FROM OLYMPICS_HISTORY
                    WHERE season = 'Summer' ORDER BY games)
            SELECT DISTINCT OLYMPICS_HISTORY.sport, OLYMPICS_HISTORY.games FROM OLYMPICS_HISTORY
            WHERE season = 'Summer' ORDER BY games;

-- WITH t3 AS (SELECT sport, COUNT(games) AS Number_Of_Games FROM OLYMPICS_HISTORY GROUP BY sport)
         --   SELECT * FROM t3;

CREATE TABLE T1 AS (SELECT COUNT(DISTINCT games) AS Total_Summer_Games
                    FROM OLYMPICS_HISTORY
                    WHERE season = 'Summer');

 SELECT * FROM T1;

CREATE TABLE T2 AS (SELECT DISTINCT OLYMPICS_HISTORY.sport, OLYMPICS_HISTORY.games FROM OLYMPICS_HISTORY
                    WHERE season = 'Summer' ORDER BY games);

SELECT * FROM T2;

CREATE TABLE T3 AS (SELECT sport, COUNT(games) AS No_of_Games
                        FROM T2 GROUP BY sport);

SELECT * FROM T3;

DROP TABLE T1;

ALTER TABLE T1 ADD COLUMN Total_No_Games INT;

SELECT * FROM t3 JOIN T1 ON Total_Summer_Games = No_of_Games;

ALTER TABLE T1 DROP COLUMN Total_Summer_Games;

SELECT * FROM t3;

DROP TABLE T1;

SELECT * FROM OLYMPICS_HISTORY
WHERE medal = 'Gold';

SELECT name, COUNT(1) AS Total_Medal
    FROM OLYMPICS_HISTORY
    WHERE medal = 'Gold'
    GROUP BY name
    ORDER BY COUNT(1) DESC;

CREATE TABLE T4 AS (SELECT name, COUNT(1) AS Total_Medal
    FROM OLYMPICS_HISTORY
    WHERE medal = 'Gold'
    GROUP BY name
    ORDER BY COUNT(1) DESC);

-- total medal won by individuals in the olympics

SELECT * FROM T4;

CREATE TABLE T5 AS (SELECT * , RANK() over (ORDER BY Total_Medal DESC) AS Ranking
                    FROM T4);

SELECT * FROM T5;

-- total medal won by individuals in the olympic with DENSE RANK
CREATE TABLE T6 AS (SELECT * , DENSE_RANK() over (ORDER BY Total_Medal DESC) AS Ranking
                    FROM T4);
SELECT * FROM T6;

SELECT * FROM T6 WHERE Ranking <= 5;

-- total gold, silver, bronze medal won by each country

SELECT * FROM OLYMPICS_HISTORY WHERE medal <> 'NA';

-- CREATE TABLE T7 AS (SELECT team, medal, COUNT(1) AS Total_medal
                  --  FROM OLYMPICS_HISTORY
               --     JOIN noc_regionsnew
                 --   WHERE medal <> 'NA' GROUP BY medal, team);

SELECT * FROM T7;

SELECT * FROM OLYMPICS_HISTORY;
SELECT * FROM noc_regionsnew;

DROP TABLE t7;

SELECT * FROM athlete_eventsnew;

-- RECREATE ANOTHER TABLE (T8) IN PLACE OF T7

CREATE TABLE T7 AS (SELECT RN.C2 AS Country, medal, count(1) as total_medals
                        FROM athlete_eventsnew AE
                        JOIN noc_regionsnew RN ON RN.C1 = AE.NOC
                        WHERE Medal <> 'NA'
                        GROUP BY RN.C2, medal
                        ORDER BY RN.C2, Medal);

DROP TABLE T7;
SELECT * FROM T7;

SELECT Country, MAX(CASE WHEN T7.medal = 'Gold' THEN T7.total_medals END) AS Gold,
       MAX(CASE WHEN T7.medal = 'Silver' THEN T7.total_medals END) AS Silver,
       MAX(CASE WHEN T7.medal = 'Bronze' THEN T7.total_medals END ) AS Bronze
        FROM t7
        GROUP BY Country;

-- total Gold, Silver, bronze won by each country in the olympic
SELECT Country, MAX(CASE WHEN T7.medal = 'Gold' THEN T7.total_medals END) AS Gold,
       MAX(CASE WHEN T7.medal = 'Silver' THEN T7.total_medals END) AS Silver,
       MAX(CASE WHEN T7.medal = 'Bronze' THEN T7.total_medals END ) AS Bronze
        FROM t7
        GROUP BY Country
        ORDER BY gold DESC, Silver desc, Bronze DESC;

SELECT athlete_eventsnew.Games FROM athlete_eventsnew;

SELECT * FROM T7;

CREATE TABLE T8 AS (SELECT Games AS Games, RN.C2 AS Country, medal, count(1) as total_medals
                        FROM athlete_eventsnew AE
                        JOIN noc_regionsnew RN ON RN.C1 = AE.NOC
                        WHERE Medal <> 'NA'
                        GROUP BY Games,RN.C2, medal
                        ORDER BY Games,RN.C2, Medal);

SELECT * FROM T8;


SELECT Games, Country, MAX(CASE WHEN medal = 'Gold' THEN total_medals END) AS Gold,
       MAX(CASE WHEN medal = 'Silver' THEN total_medals END) AS Silver,
       MAX(CASE WHEN medal = 'Bronze' THEN total_medals END ) AS Bronze
        FROM t8
        GROUP BY Games, Country
        ORDER BY Games;

SELECT Games, FIRST_VALUE(gold) over (PARTITION BY Games ORDER BY gold) AS gold
FROM t8;


