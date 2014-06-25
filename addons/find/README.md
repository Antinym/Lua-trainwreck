**Original Author:** Giuliano Riccio  
**Re-Author:** (Kaivalya.Carbuncle)  
**Version:** v 1.20140619   

# Find #

This addon searches items stored on all your characters. To build the initial list, you must login and logout (or input the "find" command) at least once with each of them.  
The list is stored on the machine on which the addon is executed, being updated everytime you look for an item or on logout, so this will not work the best if you use multiple PCs, at least until IPC will let them communicate over LAN or Internet (in development).  
The addon has a deferral time of 20 seconds when it's loaded, you are logging in or zoning to give the game enough time to load all the items.  
If you notice that this time is too short, please create an issue report in the bug tracker.

## Commands ##
### find ###
Forces a list update

```
find
```

#### Search ####
Looks for any item whose name (long or short) contains the specified value on the specified characters.

```
find [:<character1> [:...]] <query> [-e<filename>|--export=<filename>]
```
* **_character1_:** the name of the characters to use for the search. You can use :me for the current character.
* **...:** variable list of character names. If no character is specified all characters will be searched.
* **_query_** the item name you are looking for.
* **-e<filename>** or **--export=<filename>** exports the results to a csv file. The file will be created in the data folder.

##### Examples #####
```
find :all thaumas
```
Search for "thaumas" on all your characters.

```
find thaumas
```
Search for "thaumas" on current character.

```
find :alpha :beta thaumas
```
Search for "thaumas" on "alpha" and "beta" characters.

```
find :omega
```
Show all the items stored on "omega".

### track ###
Displays counts of items or inventory spaces.

```
track [command] <text>
	clear  - removes the current tracker
	hide   - makes the current tracker invisible
	show   - makes the current tracker visisble
	reset  - resets the current tracker to defaults (settings.xml or global defaults)
	new <text>   - replaces existing tracker with what's specified on the commandline
```

#### new ####
Replaces the existing tracker with arguements. Tokens are encased in ${} and bags are sperated by . (one period). 
The tokens can be surrounded by text to be displayed on screen.

```
track ${bag1.bag2.bagX:item}
```

* **_item_** is the item count to display in this token.  $free will display the remain space from the bag list.
	* item must exactly match the short name.
* **_.bag_** is a storage location; inventory, wardrobe, case, sack, satchel, locker, storage, safe.
	* Multiple locations can be combined as shown above.

----

##TODO##
1. fix track clear/reset. not behaving as expected.
2. Extend config and tracking functions to include user specified sets
3. add multiline displaying for trackers
3. add instanced trackers with independent text boxes
4. add IPC tracking functions.
4. show table in center of screen with list of trackers
5. add short character name matching (matches all characters that find pattern and appends to L{}
6. Use IPC to notify the addon about any change to the character's items list to reduce the amount of file rescans.
7. Use IPC to add tracking of other characters(instances) on same PC.
7. *cancelled for now* Use IPC to synchronize the list between PCs in LAN or Internet (requires IPC update).

----

##Changelog##
### v1.20140623 ###
* **change**:  
* **added**: tracking works, sorta.  Freespace tracking works, but item counts needs to be recoded.  
* 
### v1.20140607 ###
* **change**: Fixed find :<all|a>. It uses the full search query now. 
* **added**:
* 
### v1.20140607 ###
* **change**: find <item> will now only search the current character, find :<all|a> will search all characters 
* **added**: track properly filters input strings.
* 
### v1.20140530 ###
* **change**: 
* **added**: Shorthand :me added for current character.  Track is displaying on screen and updating properly.

### v1.20140521 ###
* **change**: 
* **added**: Tracking of hard-coded content works.

### v1.20140328 ###
* **change**: Changed the inventory structure refresh rate using packets.
* **add**: IPC usage to track changes across simultaneously active accounts.

### v1.20140210 ###
* **fix**: Fixed bug that occasionally deleted stored inventory structures.
* **change**: Increased the inventory structure refresh rate using packets.

### v1.20131008 ###
* **add**: Added new case storage support.

### v1.20130610 ###
* **add**: Added slips as searchable storages for the current character.
* **add**: The search results will show the long name if the short one doesn't contain the inputted search terms.

### v1.20130605 ###
* **fix**: Fixed weird results names in search results.

### v1.20130603 ###
* **add**: Added export function.
* **change**: Leave the case of items' names untouched

### v1.20130529 ###
* **fix:** Escaped patterns in search terms.
* **change**: Aligned to Windower's addon development guidelines.

### v1.20130524 ###
* **add:** Added temp items support.

### v1.20130521 ###
* **add:** Added characters filter.

### v1.20130520 ###
* First release.
