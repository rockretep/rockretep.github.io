---
filename: asymars
title: Asymars
subtitle: AI project and original game based on chess
date: 2018 05 05
tags: [Team, Game, Unity, C#, Scripting, AI]
mainimage: asymars2.png
---

*A full report on this project can be found __[here](/assets/asymars_report.pdf)__*

Loosely based on chess, *Asymars* is a two-player, competitive, zero-sum game played on a asymmetrical board with pieces distributed
asymmetrically. The game pieces are defined by simple properties defining direction of movement, range of movement, direction of attack, attack range,and HP value. Players take turns moving pieces and attacking enemy pieces until all enemy pieces are eliminated.

![](/images/asymars1.png#medium#right)

I designed the game pieces to have simple properties and rules, which allowed for the efficient implementations of artificial intelligence systems. For example, Alpha-Beta pruning is used in combination with the minimax algorithm to simulate and reduce game states which ultimately determine the AI player's choices.



*Asymars* is asymmetrical in that it can be played on many different board shapes and with combinations of player pieces and types, making for unique and complex relationships that nonetheless emerge from simple properties of gameplay. 
![](/images/asymars3.png#left#medium)
![](/images/asymars4.png#right#medium)
To accommodate this dynamic, I designed many different heuristics to determine which were most effective with different board and piece configurations and which benefited from first move advantage.



