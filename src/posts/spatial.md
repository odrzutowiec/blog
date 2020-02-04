#### Wed Jan 29 19:17:49 CET 2020

I've been thinking a bit more recently about infinite game worlds and roguelike games. I found a very interesting free book http://gameprogrammingpatterns.com/. It has a chapter about spatial partitioning which is exactly what I was interested in. Unfortunately that chapter is very fundamental and does not answer my question. It did give me few ideas though.

My goal would be to have an infinitely big, persistent world. The game would not have to simulate every single agent in the entire world on every game loop tick. That would be silly. It would simulate only the agents within the view of the player. All other agents instead of being simulated separately would be rather kind of reduced to a "heat map of probabilities" in a similar way GTA or SimCity games do with cellular automata layers. But even in that case there would be static objects which don't require processing every tick but do require being remembered separately. For example if I'd kill a deer and then left that area to gather wood for a bonfire, I would expect the deer's corpse to still be there when I return.

I can imagine a simple 1 dimensional array with a list of all objects in the world. Such a list would be really long so I would be able to load only chunks of it at a time. How do I know which chunks to load? I should load only relevant chunks so onces that are near the player or in the player's view.  Well if I care about the chunks of the list of game objects in a spatial sense (only chunks _close to_ the player) than I should assign some spatial information to those chunks (aka index them). All fine so far, lets say our chunks are laid out on a grid of 16x16 "meters" and each chunk can hold any number of objects. Not ideal for very densely populated areas but let's ignore this problem for now and continue.

Knowing chunk's size and x, y coordinates of the chunk I want I can easily calculate the position of that chunk in the file and load it into memory. Great! Eureka! I can go home. But what if usually there will be big number of chunks processed at once? I'd need to do IO file operation for many of the chunks I want to load. Is there any way I could pack and order those chunks in a file to minimize IO operations when reading them? 

From a simple calculation we can guestimate how long an average io operation takes on a HDD. Lets assume a 7200 RPM HDD (120 RPS) with average seek time 8ms. RPM stands for "revolutions per minute" or simply rotations per minute. To read data from a spinning disk HDD has to move the head (the needle) to the right position and then wait up to 1 full rotation. Ignoring time for the cpu overhead we can say that 8ms seek + rotational latency (1s / 120rps = ~8ms) is 16ms for a single read. Simply reading a big file in continuous fashion will generate multiple io operations. Naturally seeking to neighbour tracks will be much faster than changing a cylinder and our guestimate is generally really rough. But for our purposes knowing the order of magnitude should be enough. You can read more here https://en.wikipedia.org/wiki/Hard_disk_drive_performance_characteristics.

I looked into few different ideas on how to index and encode the chunks on wikipidia https://en.wikipedia.org/wiki/Spatial_database#Spatial_index and that game programming book http://gameprogrammingpatterns.com/spatial-partition.html.

https://sites.cs.ucsb.edu/~suri/psdir/ASP.pdf

**Grid**

Grid is the simples option. Divide the world into equal size chunks with X and Y coordinates. Keep each chunk saved as a separate file is enough. Since this project is educational for me and I want to wet my feet in a bit in algorithms and data structures and the techniques similar to those used in the 3D engines I decided I still want to implement something more complex. To make it more challenging I decided I want my game to also support polygons. In case of grid it's quite easy to just cut the polygons at the chunk edges.

**Hilbert curves**

Space filling curves like Hilbert curve are very interest and simple. It would certainly help save the chunks in a file in a more "streamable" fashion since the Hilbert curve makes the file bit stream more chunky and area like instead of having acontinuous horizontal line of the entire world. It would probably decrease amount of io needed to load the right chunks from the memory.

**Quadtrees**

Next are quadtrees. I know quadtrees or more specifically octrees are commonly used in the 3D video game industry. If I'm not mistaken leading occlusion culling software Umbra3D (used by such games as DOOM 2016 or Witcher 3) uses octrees as foundation for their algorithm. My first thought about quadtrees is that they share a lot with the hilbert curve. It seems like a quadtree could be encoded using hilbert curve. While thinking about ways I could encode a quadtree in a file I arrived at Binary Trees. Then I skipped over the binary heaps, binomail heaps and priority queues. Then I found B-Trees (https://queue.acm.org/detail.cfm?id=1814327). For some reason I got inspired to check if MySQL uses B-trees, and it does. Then I saw that MySql uses R-Trees for spatial indexes. Then my head started spinning, I'm in over my head.

**R-trees**

Wikipedia entry on r-trees is promising. They have native support for polygons and were specifically design for large datasets that cannot be kept entirely in memory and have to be paged in and out of ram from disk. seems like r-trees generally have faster lookups and quadtrees are faster to build, interesting trade off. Another interesting fact about r-trees is that they use MBR (minimal bounding rectangles) which means I can have the top level of the tree spanning entire galaxy and immediate next level really small for example 16 square meters. That means no unnecessary subdivisions and index tree branches in a galaxy where only fraction of one percent has been generated.
