---
filename: oddestsea
title: OddestSea
subtitle: Published, team developed indie game about sailing in a dark, eerie sea
date: 2020-05-01
tags: [Team, Game, Unity, C#, Scripting, Design, AI, Shaders]
confidence: Likely
mainimage: oddestsea2.png
---

*Official website: <https://www.oddestsea.com>*

*OddestSea* is a game about sailing in a dark, eerie sea, evading monsters, and restoring light to the mysterious waters. I worked to develop and publish OddestSea with a small team.

## Contents
1. [Overview](#overview)
2. [Buoyancy Physics](#buoyancy-physics)
3. [Test](#test)

![][os1]

---

## Overview

I've always wanted to make a game about sailing. I started this project in summer of 2018 for my Game Design BS capstone course at Indiana University. With the help of many talented artists and others, it release on Steam and itch.io in March 2020.

This venture into game development has been my most involved yet, and also ridden with mistakes.

I've worked on a variety of tasks in the making of this game:

- Programming
	- Gameplay mechanics
	- AI system and design
	- UI system
	- Physics implementations
- Art
	- Visual effects (in-engine)
	- Shaders (GLSL, Cg, HLSL)
	- Scene lighting
	- 3D modeling, rigging, and animation assistance
- Project Management
	- Repository management
	- Defining technical constraints
	- Project architecture and organization
	- Technical review and assistance for team

## Buoyancy Physics
Simulating buoyancy has a range of routes to take. One method is to simply displace your "buoyant" object by the current height of the water, but this isn't very interesting, or dynamic at all. With OddestSea, I spent a lot of time researching, developing, and experimenting to find a method of simulating buoyancy to be realistic, but also still controllable. Ultimately, the balance between control and realism was the hardest thing to develop.

The basis of most of my work was from the excellent articles by Jacques Kerner: <https://gamasutra.com/view/news/237528>

I modified some systems and wrote my own code, but most of the theory is the same.

### Overview

The basic concept of the buoyancy is as follows: On a simplified *hull mesh*, like the one shown below, apply forces on the triangles of the mesh which are submerged in water.

![Simplified boat hull mesh, verticies=30, triangles=42][hullmesh]

There are many details to do with how the hull mesh is processed, finding submerged triangles, calculating volumes, and applying forces. However, I will attempt to summarize the process. Here is a diagram that shows an overview of the process to apply buoyancy forces on the boat hull:

### Forces
Here I will list the forces, and the parameters available to configure that can adjust the forces.

#### Buoyancy Archimedes' principle
This is the most fundamental force involved with the boat's physics. This force is applied to every submerged triangle; that is this force is applied to the boat  on each triangle's normal vector to the surface $\overrightarrow{n}$.

$$\overrightarrow{F}_{buoyancy} = \rho g V$$

where $\rho$ is the density of the medium (water), $g$ is the 'downwards' force of gravity, and $V$ is the volume of water above the triangle, defined as

$$z  S \overrightarrow{n}$$

where $z$ is the distance from the triangle's center to the water's surface, $S$ is the area of the triangle, and $\overrightarrow{n}$ is the normal of the triangle.

Currently, there is not much here to configure outside of the internal physics calculations; its a fairly self-contained formula. The primary thing that is a variable in this formula is $\rho$, the density of the water. Density being determined by $kg/m^3$. At standard real-world conditions of temperature and pressure, the density of water is approximately $1027$, which is what this parameter is set as in the game.

#### Resistance Coefficient
While the Resistance Coefficient is not a force, it's a important factor in the viscous water resistance force. This coefficient uses an very important quantity from fluid dynamics called Reynolds number, or $Re$, defined as the following:

$$Re = \frac{\big(V  L\big)}{nu}$$

where $V$ is the velocity of the submerged body (in this case the velocity of the boat), $L$ is the length of the submerged body (the length of the boat's submerged volume), and $nu$ is the viscosity of the fluid. Viscosity, defined as $m^2/s$ is currently set to $0.000001$, the average value for real-world water. The liquid viscosity is exposed to the editor and can be configured.

Now for the definition of the Resistance Coefficient:

$$Cf = \frac{0.075}{(\log_{10}{Rn}-2)^2}$$

There are a couple constants here that could be allowed to configure, but they are pretty essential to the definition of the coefficient.

#### Viscous Water Resistance (Frictional drag)
Viscous water resistance is the frictional drag that occurs when a body (the boat) passes through the water, and the body drags the water along with itself.

$$\overrightarrow{F}_{viscous} = Cf\big(0.5  \rho  v^2  S\big)$$

where $\rho$ is the density of the water, $v$ is the speed of the submerged triangle, $S$ is the area of the submerged triangle, and $Cf$ is the resistance coefficient.

Nothing here can directly be configured, other than the liquid viscosity used in the resistance coefficient.

#### Pressure Drag
This is a very important force, primarily affecting turning and drift of the boat in the water. This force is split into two variants, which apply force on a triangle depending on a property $\cos\theta$, the angle between the triangle's normal vector $\overrightarrow{n}$ and its velocity $\overrightarrow{v}$, which is negative if pointing in the opposite direction, and positive if pointing in the same direction.

The definition for the drag that is a 'pressure' (positive $\cos\theta$) is as follows:

$$\overrightarrow{F}_{pressure} = -\Big((C_{pd1} \frac{v}{v_{r}} + C_{pd2} (\frac{v}{v_{r}})^2) S  \cos\theta^{F_{p}}  \overrightarrow{n}\Big)$$

where $F_p$ is the falloff power of the facing dot product (pressure), $C_{pd1}$ and $C_{pd2}$ are linear and quadratic pressure drag coefficients, and $v_{r}$ is a reference speed. The reference speed is to make it easier to tune the drag coefficients. The falloff power is very important. It controls how fast or slow the drag 'falls off' when the triangle's normal transition between parallel (peak drag force) and point velocity (no drag force). All of these are configurable in the editor.

The definition for the drag that is a 'suction' (negative $\cos\theta$) is as follows:

$$\overrightarrow{F}_{suction} = \Big((C_{sd1} \frac{v}{v_{r}} + C_{sd2} (\frac{v}{v_{r}})^2) S  \cos\theta^{F_{s}}  \overrightarrow{n}\Big)$$

where $F_s$ is the falloff power for suction, $C_{sd1}$ and $C_{sd2}$ are linear and quadratic suction drag coefficients, and $v_{r}$ is the same reference speed. Again, all of these are configurable in the editor.

#### Slamming Force
Slamming Force is the response of the water to sudden accelerations or penetrations from the boat's triangles.

$$\overrightarrow{F}_{slamming} = clamp \Big(\frac{\Gamma}{\Gamma_{max}},0,1\Big)^p \cos\theta  \overrightarrow{F}_{stopping}$$

where $\Gamma$ is the acceleration of a triangle, $\Gamma_{max}$ is the maximum acceleration of a triangle, $p$ is the power to ramp up the slamming force, and $\cos\theta$ is the same as seen before in the pressure drag force. Both $p$ and a special ``cheat" parameter called $Slamming Cheat$ used to multiply the slamming force result, are configurable. Additionally, $\overrightarrow{F}_{stopping}$ is defined as:

$$\overrightarrow{F}_{stopping} = m  \overrightarrow{v}  (\frac{2A}{S})$$

where $m$ is the mass of the boat, $v$ is the velocity of the triangle, $A$ is the triangle's area, and $S$ is the total area of the boat.

**WORK IN PROGRESS...**

[os1]: /images/oddestsea1.png "oddestsea1"
	loading="lazy" style="filter:brightness(1.5)" option="small right"

[os2]: /images/oddestsea2.png "oddestsea2"
	loading="lazy" option="small left"

[hullmesh]: /images/hullMesh.png "hullmesh"
	loading="lazy" option="medium center"

