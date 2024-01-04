---
filename: AI_framework
title: AI Framework for games
subtitle: Small, general-purpose AI framework
date: 2020
tags: [Solo, Tool, C, AI]
confidence: Unlikely
mainimage: bubo.png
---

This project started out by development a simple AI framework for a couple of projects in the Unity Game Engine. I soon realized that I would like to be able to apply my framework in as many contexts (like other game engines) as possible. So I decided to write it in C, which make it much easier to make bindings for, and makes for great practice to improve my C skills.

The main objective is to create a simple library of GOFAI (good old fashioned AI) algorithms. 

I want the framework small, simple, and general-purpose, without any external dependencies.

- Minmax with alpha/beta pruning
- State Machines
	- Basic finite state machines
	- Hierarchical state machines
	- Parameters for state `Enter` and `Exit` procedures
- Behavior trees

**WORK IN PROGRESS...**
