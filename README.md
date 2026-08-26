# Rust & Rescue

Rust & Rescue is a 2D post-apocalyptic adventure game developed with **Godot** and **GDScript**. Players explore a damaged world, rescue endangered creatures, collect resources, and interact with the environment.

The project combines traditional game development with **Arduino-based hardware integration**, allowing physical pressure-sensor input to trigger actions inside the game.

## Features

- 2D exploration and adventure gameplay
- Player movement and interaction systems
- Creature rescue mechanics
- Collectible items and environmental interactions
- Custom game logic implemented in GDScript
- Physical input integration using Arduino
- Pressure sensor input translated into in-game actions
- Modular scene and gameplay structure using Godot

## Tech Stack

- **Godot Engine**
- **GDScript**
- **Arduino**
- **Pressure Sensors**
- **Git / GitHub**

## Hardware Integration

One of the main technical features of Rust & Rescue is the integration between physical hardware and the game.

An Arduino-connected pressure sensor captures physical input from the player. The sensor data is processed and translated into commands that trigger actions inside the Godot game.

The basic interaction flow is:

    Physical Input
          ↓
    Pressure Sensor
          ↓
       Arduino
          ↓
    Input Processing
          ↓
        Godot
          ↓
     In-Game Action

This allowed the project to experiment with gameplay that extends beyond traditional keyboard and mouse controls.

## Development

The project involved designing and implementing gameplay mechanics, building interactive scenes, integrating hardware input, and debugging communication between the physical device and the game.

Development included:

- Designing game mechanics and player interactions
- Implementing gameplay logic in GDScript
- Building and organizing scenes in Godot
- Connecting Arduino sensor input to game events
- Testing and debugging software/hardware interactions
- Iterating on gameplay based on testing and feedback

## What I Learned

This project gave me hands-on experience with:

- Object-oriented and event-driven game development
- Debugging interactive software
- Hardware/software integration
- Processing external input in a software application
- Designing modular gameplay systems
- Testing and iterating on a complete interactive project
