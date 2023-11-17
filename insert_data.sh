
#!/bin/bash
#declare -p IFS=","

#Script to insert data from courses.csv and students.csv into students database

#PSQL variable to log in and interact with database
#This will allow yus to query the database from the script.
PSQL="psql -X --username=freecodecamp --dbname=students --no-align --tuples-only -c"

cat courses.csv | while IFS="," read MAJOR COURSE
#cat courses.csv | while IFS="," read MAJOR COURSE
do
if [[ $MAJOR != major ]]
then
  #get major_id
  MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")

  #if not found
  # checks if MAJOR_ID is not empty
  if [[ -z $MAJOR_ID ]]
  then
    #insert major
    INSERT_MAJOR_RESULT=$($PSQL "INSERT INTO majors(major) VALUES('$MAJOR')")

    #Output successful add
    if [[ $INSERT_MAJOR_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into majors, $MAJOR
    fi

    #get new major_id
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
  fi
  
  #get course_id
  COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")

  #if not found
  # checks if MAJOR_ID is not empty
  if [[ -z $COURSE_ID ]]
  then
    #insert course
    INSERT_COURSE_RESULT=$($PSQL "INSERT INTO courses(course) VALUES('$COURSES')")

    #Output successful add
    if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into courses, $COURSES
    fi

    #get new course_id
    COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")
  fi
  
  #insert into majors_courses

fi
done
