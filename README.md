GGDictionary
============

Basic Usage
-------------------------

##### Require the code
```lua
local GGDictionary = require( "GGDictionary" )
```

##### Create your dictionary
```lua
local dictionary = GGDictionary:new()
```

##### Create and add a language
```lua
local language = {}
language.name = "english"
language.strings = {}
language.strings[ "greeting" ] = "Hello"

dictionary:addLanguage( language )
```

##### Get a string
```lua
local string = dictionary:getString( "greeting" ) -- With no language passed in will default to .currentLanguage.
```

##### Get a string from a specific language
```lua
local string = dictionary:getString( "greeting", "french" )
```

##### Load a language from file
```lua
dictionary:addLanguageFromFile( "german.language" )
```

##### Change the current language
```lua
dictionary.currentLanguage = "german"
```

##### Destroy the dictionary
```lua
dictionary:destroy()
dictionary = nil
```

Update History
-------------------------

##### 0.1
Initial release