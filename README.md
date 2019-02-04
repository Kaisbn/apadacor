# Pacadaman

## How to compile
To compile this project, you will need:
- The ADA drivers library: https://github.com/AdaCore/Ada_Drivers_Library
- The GNAT community 2018 tool suite for ARM: https://www.adacore.com/download

Then, you will have to modify and set your PATH and GPR_PROJECT_PATH variables:
```
export PATH=$PATH:/path/to/GNAT/2018-arm-elf/bin
export GPR_PROJECT_PATH=/path/to/Ada_Drivers_Library
```

Using `grpbuild` you can build the project:
```
gprbuild -Pprj.gpr
```
And then flash to the board using `st-flash`:
```
st-flash --reset write main.bin 0x08000000
```


## Rules
- You (the player) always start at the same place (at the left of the map)
- The enemies are generated at the start of the game with a random position
- The enemies move randomly except when the player is within 3 blocks, then they will chase him as long as they see him
- At the beginning, the player moves upwards
- The touch screen is splitted into 4 triangle regions that corresponds to the 4 possible directions
- The player moves automatically in the previous indicated direction as long as he can (when there is no wall in this direction)
- When you indicates a direction going into the wall, this direction is saved until a new one is given and the program tries to use it for each move
- When the player goes out of the map, he reappears at the opposite side
- If the player touches an enemy, he loses the game
- If the player gets all the coins, he wins the game


## How to play

![](https://hackster.imgix.net/uploads/attachments/747706/directions_WGM5QXrN8W.png?auto=compress%2Cformat&w=740&h=555&fit=max)

The touch screen is splitted in 4 regions so you can move the player in each direction.
You are now ready to play to your favorite Pacman Game!
