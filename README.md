[![Build status](https://github.com/pharo-ai/edit-distances/workflows/CI/badge.svg)](https://github.com/pharo-ai/edit-distances/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/pharo-ai/edit-distances/badge.svg?branch=master)](https://coveralls.io/github/pharo-ai/edit-distances?branch=master)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)

## Description

Provides methods to determine the distance between two objects, for example, between Strings. Those objects, often represents documents. Normally they are strings but also they can be arrays of numbers that represent a document.

The distance between the two documents is defined as "The minimum number of insertions, deletions, and substitutions required to transform one string into the other". Edit-based distances for which such weights can be defined are usually refered to as generalized distances. These methods are independent of a searching algorithm, i.e. Levenshtein or Hamming edit distances can be applied separately to a searching algorithm.

  - An edit distance does NOT count matches.
  - Some commonly referred "edit distances" compare corresponding elements and require objects of equal length (examples: Euclidean, Manhattan, Hamming,...)
  - To speed up computation, some distances are based in "tokens", and also referred as token-based distances (example: Cosine similarity).

## Table of contents

- [How to install it](#how-to-install-it)
- [How to depend on it](#how-to-depend-on-it)
- [Implemented distances](#implemented-distances)

## How to install it

[//]: # (pi)
```smalltalk
EpMonitor disableDuring: [
	Metacello new
		repository: 'github://pharo-ai/edit-distances/src';
		baseline: 'AIEditDistances';
		load ]
```

## How to depend on it

If you want to add the AIEditDistances to your Metacello Baselines or Configurations, copy and paste the following expression:
```smalltalk
spec
	baseline: 'AIEditDistances' 
	with: [ spec repository: 'github://pharo-ai/edit-distances/src' ]
```

## Implemented distances

These are the currently implemented distance. Note that we are currently working on this project so we will be implementing more distance in the future.

  - Euclidean norm, also known as Euclidean length, L2 norm, L2 distance, l^2 norm
  - Manhattan distance, also known as City Block Distance.
  - Cosine similarity, note this is not the same as TF-IDF.
  - Levenshtein distance
  - Kendall Tau distance
  - Szymkiewicz-Simpson coefficient

All the distances are implemented the strategy design pattern. They have the same API.

They are two ways of calculating the distance.

One is to use the method `distanceTo: aCollection using: aDistance`.

Or to use `aDistance distanceBetween: xCollection and: yCollection`

### Euclidean norm

The Euclidean distance between two points in Euclidean space is the length of a line segment between the two points. It can be calculated from the Cartesian coordinates of the points using the Pythagorean theorem, therefore occasionally being called the Pythagorean distance.

```st
#( 0 3 4 5 ) distanceTo: #( 7 6 3 -1 ) using: AIEuclideanDistance new. "9.746794344808963"
```

```st
euclideanDistance := AIEuclideanDistance new.
euclideanDistance distanceBetween: #( 0 3 4 5 ) and: #( 7 6 3 -1 ). "9.746794344808963"
```

### Manhattan distance

In the Manhattan distance, the Euclidean geometry is replaced by a new metric in which the distance between two points is the sum of the (absolute) differences of their coordinates.

More formally, we can define the Manhattan distance, also known as the L1-distance, between two points in an Euclidean space with fixed Cartesian coordinate system is defined as the sum of the lengths of the projections of the line segment between the points onto the coordinate axes.

```st
#(10 20 10) distanceTo: #(10 20 20) using: AIManhattanDistance new "10".
```

```st
manhattanDistance := AIManhattanDistance new.
manhattanDistance distanceBetween: #( 10 20 10 ) and: #( 10 20 20 ). "10"
```

### Cosine similarity

Cosine similarity is a metric used to determine how similar the documents are irrespective of their size. Mathematically, it measures the cosine of the angle between two vectors projected in a multi-dimensional space.

```st
#(3 45 7 2) distanceTo: #(2 54 13 15) using: AICosineSimilarityDistance new. "0.9722842517123499"
```

```st
cosineDistance := AICosineSimilarityDistance new.
cosineDistance distanceBetween: #(3 45 7 2) and: #(2 54 13 15) "0.9722842517123499"
```

### Levenshtein distance

The Levenshtein distance is a string metric for measuring the difference between two sequences. Informally, the Levenshtein distance between two words is the minimum number of single-character edits (insertions, deletions or substitutions) required to change one word into the other.

```st
'zork' distanceTo: 'fork' using: AILevenshteinDistance new.
```

```st
levenshteinDistance := AILevenshteinDistance new.
levenshteinDistance distanceBetween: 'zork' and: 'fork' "1"
```

### Kendall Tau distance

The Kendall tau rank distance is a metric that counts the number of pairwise disagreements between two ranking lists. The larger the distance, the more dissimilar the two lists are.

Kendall tau distance is also called bubble-sort distance since it is equivalent to the number of swaps that the bubble sort algorithm would take to place one list in the same order as the other list. The Kendall tau distance was created by Maurice Kendall. 

This distance a a little special. The distance itself is the number of discordant pairs that there is between the two ranked lists. But, often the result is normalized. In this implementation we normalize the distance by default. To not normalize the result you must send the message `normalizeResult: false`.

```st
kendallTauDistance := AIKendallTauDistance new.
kendallTauDistance normalizeResult: false.
```

There are two normalizers implemented. If no normalizer is specified, then the default normalized will be used. `AIKendallTauDistance class>>#defaultNormalizer`. Which is the `AIBKendallTauNormalizer`.

- The first normalizer is  `AIBKendallTauNormalizer`. It uses the following formula to normalize the discordant pairs. This is the default normalizer.

$tau_b = (P - Q) / sqrt((P + Q + T) * (P + Q + U))$

Where P is the number of concordant pairs, Q the number of discordant pairs, T the number of ties only in x, and U the number of ties only in y. If a tie occurs for the same pair in both x and y, it is not added to either T or U.

- The second normalizer that we have is the `AICKendallTauNormalizer`. It has the following formula:

$tau_c = 2 (P - Q) / (n**2 * (m - 1) / m)$

Where P is the number of concordant pairs, Q the number of discordant pairs. n is the total number of samples, and m is the number of unique values in either x or y, whichever is smaller.

Example with normalization:

```st
#(1 2 3 4 5) distanceTo: #(3 4 1 2 5) using: AIKendallTauDistance new. "(1/5)"
```

```st
kendallTauDistance := AIKendallTauDistance new.
kendallTauDistance distanceBetween: #( 1 2 3 4 5 ) and: #(3 4 1 2 5 ). "(1/5)"
```

Example using another normalizer:

```st
#(1 2 3 4 5) distanceTo: #(3 4 1 2 5) using: AIKendallTauDistance new. "(1/5)"
```

```st
kendallTauDistance := AIKendallTauDistance new.
kendallTauDistance useNormalizer: AICKendallTauNormalizer.

kendallTauDistance distanceBetween: #( 1 2 3 4 5 ) and: #(3 4 1 2 5 ). "(1/5)"
```

Example without normalization:

```st
#(1 2 3 4 5) distanceTo: #(3 4 1 2 5) using: AIKendallTauDistance new. "(1/5)"
```

```st
kendallTauDistance := AIKendallTauDistance new.
kendallTauDistance normalizeResult: false.

kendallTauDistance distanceBetween: #( 1 2 3 4 5 ) and: #(3 4 1 2 5 ). "4"
```

### Szymkiewicz-Simpson coefficient

Also called overlap coefficient, is a similarity measure that measures the overlap between two finite sets.

```st
#( 1000 2 0.5 3 6 88 99 ) asSet
	distanceTo: #( 1000 0.5 99 ) asSet
	using: AISzymkiewiczSimpsonDistance new. "1.0"
```

```st
overlapCoefficient := AISzymkiewiczSimpsonDistance new.
overlapCoefficient
	distanceBetween: #( 1000 2 0.5 3 6 88 99 ) asSet
	and: #( 1000 0.5 99 ) asSet. "1.0"
```
