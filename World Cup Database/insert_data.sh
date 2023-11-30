#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Remove all the data
echo $($PSQL "TRUNCATE game")

#IFS command gets the commas from csv
#
# CSV headers (games.csv)
# year,round,winner,opponent,winner_goals,opponent_goals
#
cat games.csv | while IFS="," read YR RND WIN OPP WINGOAL OPPGOAL
do
  if [[ $WIN != "winner"]]
  then
    #$WIN is winners team name
    # get winner_id
    # this is needed since we dont know the actual value of the teams_id from teams table
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")

    #We might not have the team_id yet
    #Check if team_id exists
    #add team and update WINNER_ID if it doesnt
    #
    #
    #if not found
    if [[ -z $WIN_ID ]]
    then
      #Add Team...
      INSERT_WIN_RESULT = $($PSQL "INSERT INTO teams(name) VALUES('$WIN')'")

      #Confirm back from terminal
      if [[ INSERT_WIN_RESULT == "INSERT 0 1" ]]
       then
        echo Team Added, $WIN

        #Doing this in here because i want to know it was done.
        #dont really have error handling soooooooo this is the attempt
        #lets pretend it never fails, thanks
        #Update that null ID to accurate ID
        WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
      fi
    fi

    #$OPP is OPPONENT team name
    # get opponent_id
    # this is needed since we dont know the actual value of the teams_id from teams table
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    #We might not have the team_id yet
    #Check if team_id exists
    #add team and update WINNER_ID if it doesnt
    #
    #
    #if not found
    if [[ -z $OPP_ID ]]
    then
      #Add Team...
      INSERT_OPP_RESULT = $($PSQL "INSERT INTO teams(name) VALUES('$OPP')'")

      #Confirm back from terminal
      if [[ INSERT_OPP_RESULT == "INSERT 0 1" ]]
       then
        echo Team Added, $OPP

        #Doing this in here because i want to know it was done.
        #dont really have error handling soooooooo this is the attempt
        #lets pretend it never fails, thanks
        #Update that null ID to accurate ID
        OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
      fi
    fi

    #Should have all the data for games DB
    #Insert into games DB
    # YR RND WIN WIN_ID OPP OPP_ID WINGOAL OPPGOAL
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YR, $RND, $WIN_ID, $OPP_ID, $WINGOAL, $OPPGOAL)")
    
    #Dont need this but
    #Prompt out what we added
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo Inserted match info, $YR, $RND, $WIN_ID, $OPP_ID, $WINGOAL, $OPPGOAL
    fi
  fi
done
