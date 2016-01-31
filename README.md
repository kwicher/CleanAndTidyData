### CleanAndTidyData by KBW @2016
####Getting and Cleaning Data Course Project

The script first reads all the necessary files into the data frames. 

Next, the activities in the _train_ and _test_ activities data frames are decoded from numbers to names. These are column-wise merged with the corresponding main data frames and additionally, collumn with _Subject_ and a _source/Src_ (train or test) are added.

After that _train_ and _test_ data frames are merged row-wise.

From this combined dataset, columns containing _mean_ or _std_ in the name, as well as this for _Subject_, _Activity_, and _Src_ are extracted.

This subset of data is grouped by _Subject_ and _Activity_. _Src_ column is droped as is not necessary in this excersize.

Grouped subset is summarized column-wise, to obtain the required final dataset.

This is printed out to the 'output.txt' file.


