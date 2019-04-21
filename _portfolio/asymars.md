---
layout: page
title: Asymars
permalink: /asymars/
subtitle: Experimental AI game
image: "asymars2.png"
---

Loosely based on chess, *Asymars* is a two-player, competitive, zero-sum game played on a asymmetrical board with pieces distributed 
asymmetrically. The game pieces are defined by simple properties defining direction of movement, range of movement, direction of attack, attack range,and HP value. Players take turns moving pieces and attacking enemy pieces until all enemy pieces are eliminated.

I designed the game pieces to have simple properties and rules, which allowed for the efficient implementations of artificial intelligence systems. For example, Alpha-Beta pruning is used in combination with the Minimax algorithm to simulate and reduce game states which ultimately determine the AI player's choices.

*Asymars* is asymmetrical in that it can be played on many different board shapes and with combinations of player pieces and types, making for unique,complex relationships that nonetheless emerge from simple properties of gameplay. To accommodate this dynamic, I designed many different heuristics to determine which were most effective with different board and piece configurations and which benefited from first move advantage.
