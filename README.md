# Baba Is Solved - CISC 813 Project

PDDL implementation of a constrained version of the game Baba Is You. Futher information on the project can be found [here](https://www.overleaf.com/read/vgsthrnxwsdg).

### PDDL

Each pddl domain is used for a single problem. Currently the only domain available is `domain-final before automation.pddl`. This represents a sample domain file that will be used as a model when creating automation of the PDDL files. `test_problem-final before automation.pddl` is the PDDL problem file counterpart.

#### Still under work

Creating baseline domains and problem files. These will be added once automation of these files is completed.

### Python

The python files are used to automate the creation of the domain and problem files. `main.py` creates the initial predicates relating to the grid of locations.

#### Still under work

Creating files that:
- give the user an ascii grid to create new level setups
- read an ascii grid and convert it into proper objects and their locations
- take a list of objects and locations and convert it into a domain and problem file
