# ByteBound
Introduction to Programming Video Games 2D platform game project

## Project Layout:
** Prototype: subject to change ** 
I Just wanted to add this to give y'all some information on how I laid out what I have.

### Assets:
While in unity this folder is usual the main folder and contains every thing game related. 
I decided to make an asset folder to store all the graphics and audio.
This keeps all the things that add polish to a game in a single folder, and I couldn't come up with a better name.

### Actors:
I call them actors, we can call them whatever, but actors are objects in the game that take actions like the Player and Enemies.
Each actor should have its own scene that it is set up in and then that scene should be instantiated by a parent scene.
This just keep the scene trees of more complex scenes a bit neater.

### Components:
I decided at least for now to try and go with a more Entity - Component relationship.
meaning each entity/actor can be made up of several smaller components. These components should be as generic as possible for greater reuse.

### Scenes:
This should probably be called 'Levels', as the idea is each level we make we can put here currently it is just the TestScene.
The TestScene is currently where the whole game lives currently.


## TODO:
### Features
#### Detection system:
A way for the AI to detect things in the environment such as the player, sounds made from thrown object and the like.

#### Turret that can scan for the player
If we are going with a stealth platformer we need an enemy AI that can scan for the player and determine if the player is visible 

#### Movable Boxes
In general objects that the player can move around to try and block the LOS (line of sight) of the enemy.

### Bugs
#### Tile Collision on Slope
The player when moving up a slope that transitions to a flat tile will become stuck and have to jump to get over it.
This is most likely due to how the collision shape on the tile and can be adjusted in the TileSet (ground).
