#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT count(winner_goals) FROM games WHERE winner_goals>2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "
SELECT name 
FROM games 
LEFT JOIN teams 
ON games.winner_id = teams.team_id 
WHERE round LIKE 'Final' AND year = 2018;
")"

#
# This was the hard one
#
# Basically i want team names of the winning teams (G1)
# then we will create a duplicate entry of games (G2)
# then grab the team names by assigning it to G1 and G2 using OR
#       Its unclear why OR works but AND does not
# We will link the tables G1 and G2 by game_id so they are consistent
#
# Duplicate the data but display the name of Winner_id (half the table) 
# then Opponent_id (the other half)
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "
SELECT DISTINCT(t.name)
FROM teams t 
LEFT JOIN (games g1 LEFT JOIN games g2 ON g1.game_id=g2.game_id)
ON t.team_id=g1.winner_id OR t.team_id=g2.opponent_id
WHERE g1.year=2014 AND g1.round='Eighth-Final'
ORDER BY t.name;
")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "
SELECT DISTINCT(name) 
FROM games 
LEFT JOIN teams 
ON games.winner_id = teams.team_id;
")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "
SELECT year,name 
FROM games 
LEFT JOIN teams 
ON games.winner_id = teams.team_id 
WHERE round LIKE 'Final' 
ORDER BY year;
")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
