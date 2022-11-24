#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
  then
   echo "Please provide an element as an argument."
   exit
  fi

if [[ $1 =~ ^[0-9]+$ ]]
then
ELEMENT_INFO=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements left join properties using(atomic_number) left join types using(type_id) where atomic_number = $1;")
else
ELEMENT_INFO=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements left join properties using(atomic_number) left join types using(type_id) where name = '$1' or symbol = '$1';")
fi

if [[ -z $ELEMENT_INFO ]]
then
 echo "I could not find that element in the database."
else
  echo "$ELEMENT_INFO" | while read ATOM_NO BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTPOINT BAR BOILPOINT
  do
   echo "The element with atomic number $ATOM_NO is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTPOINT celsius and a boiling point of $BOILPOINT celsius."
  done
fi