-- Project: GGDictionary
--
-- Date: September 6, 2012
--
-- Version: 0.1
--
-- File name: GGDictionary.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Update History:
--
-- 0.1 - Initial release
--
-- Comments: 
-- 
--		GGDictionary allows for multiple 'languages' to be included in your Corona SDK powered apps.
--		A language can be created in code or loaded from a file.
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGDictionary = {}
local GGDictionary_mt = { __index = GGDictionary }

local json = require( "json" )

--- Initiates a new GGDictionary object.
-- @return The new object.
function GGDictionary:new()
    
    local newDict = {}
    
    newDict.languages = {}
    
    return setmetatable( newDict, GGDictionary_mt )
    
end

--- Loads a language definition table from disk.
-- @param path The path to the file.
-- @param baseDirectory The base directory for the path. Optional, defaults to system.ResourceDirectory.
-- @return The loaded language.
function GGDictionary:loadLanguage( path, baseDirectory )

	local path = system.pathForFile( path, baseDirectory or system.ResourceDirectory )
	local file = io.open( path, "r" )
	
	if not file then
		return
	end
	local data = json.decode( file:read( "*a" ) )
	io.close( file )
	
	return data
	
end 

-- Adds a language to the dictionary.
-- @param language The language definition table.
-- @return The added language.
function GGDictionary:addLanguage( language )

	if not language then
		return
	end
	
	self.languages[ language.name ] = language
	if not self.currentLanguage then
		self.currentLanguage = language.name
	end
	return self.languages[ language.name ]
	
end

--- Adds a languages from file.
-- @param path The path to the file.
-- @param baseDirectory The base directory for the path. Optional, defaults to system.ResourceDirectory.
function GGDictionary:addLanguagesFromFile( path, baseDirectory )
	
	local path = system.pathForFile( path, baseDirectory or system.ResourceDirectory )
	local file = io.open( path, "r" )
	
	if not file then
		return
	end

	local data = json.decode( file:read( "*a" ) ) or {}
	io.close( file )
	
	for i = 1, #data, 1 do
		self:addLanguageFromFile( data[ i ], baseDirectory )
	end
	
end

--- Adds a language from disk.
-- @param path The path to the file.
-- @param baseDirectory The base directory for the path. Optional, defaults to system.ResourceDirectory.
-- @return The added language.
function GGDictionary:addLanguageFromFile( path, baseDirectory )
	local language = self:loadLanguage( path, baseDirectory )
	return self:addLanguage( language )
end

--- Saves a language definition table to disk.
-- @param path The path for the file.
-- @param language The language to be saved.
-- @param baseDirectory The base directory for the path. Optional, defaults to system.DocumentsDirectory.
-- @return True if successful, false otherwise.
function GGDictionary:saveLanguageToFile( path, language, baseDirectory )

	local path = system.pathForFile( path, baseDirectory or system.DocumentsDirectory )
	local file = io.open( path, "w+" )
	
    if file then
        local data = json.encode( language )
        file:write( data )
        io.close( file )
        return true
    else
        return false
    end
    
end 

-- Adds a language to the dictionary.
-- @param name The name of the string.
-- @param language The name of the language to use. Optional, defaults to .currentLanguage.
-- @return The found string. Nil if none found.
function GGDictionary:getString( name, language )
	
	local language = language or self.currentLanguage

	if language and self.languages[ language ] then
		return self.languages[ language ].strings[ name ]
	end
	
end

--- Destroys this GGDictionary object.
function GGDictionary:destroy()
	for k, v in pairs( self.languages ) do
		self.languages[k] = nil
	end
	self.languages = nil
	self.currentLanguage = nil
end

return GGDictionary
