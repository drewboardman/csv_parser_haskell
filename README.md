csvParser
==========
* A simple csv parser written in haskell

To Do
------
a. Maybe write each row to file as you get it
  - don't hold the whole thing in memory
b. Figure out a way to not need to change the function that Main calls
  - instead maybe give it a cli or something that asks if I want to:
    + generate
    + parse (maybe takes a filepath)
c. Try it on a csv with 10's of millions of rows
