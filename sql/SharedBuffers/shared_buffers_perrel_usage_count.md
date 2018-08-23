## Per relation usage count


**WIP** 

Output example:

```
rel     |    ixcount    |                usagecount
--------+---------------+-------------------------------------------
 <anon> | {5,4,3,2,1,0} | {1942172,677649,34623,26900,28383,13493}
 <anon> | {5,4,3,2,1,0} | {582792,32698,142,1805,35,47}
 <anon> | {5,4,3,2,1,0} | {570278,420384,144,13,2,13}
 <anon> | {5,4}         | {208756,3149}
 <anon> | {5,4}         | {202533,188}
 <anon> | {5,4}         | {178378,210}
 <anon> | {5,4,3,2}     | {122173,57,1,1}
 <anon> | {5,4,3,2,1,0} | {101306,903,55,94,770,370}
 <anon> | {5,4,3,2,1,0} | {73481,50050,20125,27320,69644,173853}
 <anon> | {5,4,1,0}     | {68895,100,1205,73}
 <anon> | {5,4,3,2,1,0} | {68325,13937,5740,12403,13904,710}
 <anon> | {5,4,3,2,1,0} | {68059,257574,262216,182012,250434,90672}
 <anon> | {5,4,2}       | {64468,104,5}
 <anon> | {5,4,3,2,1,0} | {54635,20352,7087,8378,6472,3865}
 <anon> | {5,4}         | {44015,36}
 <anon> | {5,4,3,2,1,0} | {38001,33480,26599,28956,38414,32479}
 <anon> | {5,4,3,2,1,0} | {35606,15624,6187,6120,4021,1624}
 <anon> | {5,4}         | {34958,16}
 <anon> | {5,4,3,2,1,0} | {34834,25884,7545,9632,7462,4202}
 <anon> | {5,4,3,2,1,0} | {34552,180192,223608,121486,89214,87766}
 <anon> | {5,4,3,2,1,0} | {32425,21362,8832,12241,18928,13302}
 <anon> | {5,4}         | {32415,399}
 <anon> | {5,4}         | {32176,2220}
 <anon> | {5,4}         | {30648,32}
```

What this means? 

### The case of very frequent pinned buffers 

```
For sequential scans, a 256KB ring is used. That's small enough to fit in L2
cache, which makes transferring pages from OS cache to shared buffer cache
efficient.  Even less would often be enough, but the ring must be big enough
to accommodate all pages in the scan that are pinned concurrently.  256KB
should also be enough to leave a small cache trail for other backends to
join in a synchronized seq scan.  If a ring buffer is dirtied and its LSN
updated, we would normally have to write and flush WAL before we could
re-use the buffer; in this case we instead discard the buffer from the ring
and (later) choose a replacement using the normal clock-sweep algorithm.
```

This could mean that if we see very frequent pinned buffers, that parallel could
take advantage of the ring buffer management.
