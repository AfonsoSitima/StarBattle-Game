# StarBattle-Game
3º Project now in prolog

## Introduction
The puzzle consists of a board (assumed to be an  N x N  matrix) that initially contains zero or more stars in some positions. This board is divided into regions.

The objective is to place two stars in each row, each column, and each region while ensuring that no two stars are adjacent to each other. That is, once a star is placed, no other star can be positioned immediately above, below, to the left, to the right, or diagonally adjacent.

Whenever it is determined that a star cannot be placed in a given position, a dot should be inserted in that position.

## Objective/Gameplay
The real challenge of this project was the programming language we were required to use—Prolog. At first, it felt a bit unfamiliar, but by the end, everything came together smoothly, and I believe I did a great job. Unlike my previous game projects, where I focused on building the game itself, my goal for this one was to develop a program capable of solving a simple BattleStars board.

To start you call `resolve` giving it the first argument -> a BattleStar Board.

You can find some board example in [Puzzels](StarBattlle-Game/puzzles.pl)



