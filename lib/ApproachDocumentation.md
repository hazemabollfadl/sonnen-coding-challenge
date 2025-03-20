Villain Selection Module

Introduction

Dear Engineers at Sonnen,

This repository contains my implementation of the Villain Selection Module, which determines the next target position for the cream pie thrower. The solution processes incoming radar data and applies specified attack strategies to identify the optimal attack position.

Assumptions
	1.	In all attack modes except avoid-crossfire, if Donald Duck is present in an area, he is excluded from the attack, and only the other villains in that area are precisely targeted.
	2.	In avoid-crossfire mode:
	•	Any area containing Donald Duck is ignored.
	•	Among the remaining areas, the one with the highest number of villains is selected.
	3.	The order in which villains are attacked within a selected area is determined by their malice level, with higher malice villains being targeted first.

Note on Assumptions

The above assumptions were derived from analyzing the behavior of case1 and case4 in the test suite:
	•	case1 led to the assumption that when Donald Duck is present, he should be excluded from targeting rather than avoiding the entire area (except for avoid-crossfire mode).
	•	case4 highlighted the need to prioritize attack selection based on the number of villains when applying avoid-crossfire mode.

Implementation Approach
	1.	Parse the input JSON to extract attack modes and radar data.
	2.	Filter out Donald Duck (except in avoid-crossfire, where areas with him are ignored entirely).
	3.	Apply attack modes in sequence, considering:
	•	Distance-based selection (closest-first / furthest-first).
	•	Avoiding crossfire (removing areas with Donald Duck).
	•	Prioritizing specific villains (e.g., Darth Vader).
	•	Sorting villains in the selected area by malice level (descending order).
	4.	Return the final selected position and villains list as a JSON response.
