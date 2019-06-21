# Codeunit ACA - ACC Execute
### Methods

#### Init()
Initialize the **ACA - ACC Execute** codeunit.  
Must be called before using the acadon_client.connector.

##### Declaration
```
procedure Init()
```


#### AddParameter(Text[100], Text)
Add a variable to the LUA function.  
The variable can be use as global variable in the LUA script.

##### Declaration
```
procedure AddParameter(Name: Text[100], Value: Text)
```

##### Parameters
| Type	        | Name      | Description    |
|---------------|-----------|----------------|
| Text          | *Name*	| Variable Name  |
| Boolean       | *Value*	| Variable Value |


#### AddParameter(Text[100], Integer)
Add a variable to the LUA function.  
The variable can be use as global variable in the LUA script.

##### Declaration
```
procedure AddParameter(Name: Text[100], Value: Integer)
```

##### Parameters
| Type	        | Name      | Description    |
|---------------|-----------|----------------|
| Text[100]     | *Name*	| Variable Name  |
| Integer       | *Value*	| Variable Value |


#### AddParameter(Text[100], Decimal)
Add a variable to the LUA function.  
The variable can be use as global variable in the LUA script.

##### Declaration
```
procedure AddParameter(Name: Text[100], Value: Decimal)
```

##### Parameters
| Type	        | Name      | Description    |
|---------------|-----------|----------------|
| Text[100]     | *Name*	| Variable Name  |
| Decimal       | *Value*	| Variable Value |


#### AddParameter(Text[100], Boolean)
Add a variable to the LUA function.  
The variable can be use as global variable in the LUA script.

##### Declaration
```
procedure AddParameter(Name: Text[100], Value: Boolean)
```

##### Parameters
| Type	        | Name      | Description    |
|---------------|-----------|----------------|
| Text[100]     | *Name*	| Variable Name  |
| Boolean       | *Value*	| Variable Value |


#### SetAlternativeDescription(Text)
Can be used to set the description in the loading page during the execution.  
If this function is not used, the Description field of the function is used.  

##### Declaration
```
procedure SetAlternativeDescription(Description: Text)
```

##### Parameters
| Type	        | Name           | Description                 |
|---------------|----------------|-----------------------------|
| Text          | *Description*	 | The alternative description |


#### InvokeFunction(Integer)
Execute the function with the given Id.

##### Declaration
```
procedure InvokeFunction(Id: Integer)
```

##### Parameters
| Type	        | Name      | Description         |
|---------------|-----------|---------------------|
| Integer       | *Id*	    | Id of the function  |


#### GetOutputVariables()
Get all variables set by the LUA script as Json Array.

##### Declaration
```
procedure GetOutputVariables(): JsonArray
```

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| JsonArray     | all variables as JsonArray  |


#### GetTextVariable(Text)
Get the value of the parameter with the given name.

##### Declaration
```
procedure GetTextVariable(Name: Text): Text
```

##### Parameters
| Type	        | Name      | Description          |
|---------------|-----------|----------------------|
| Text          | *Name*	| Name of the variable |

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| Text          | value of the variable       |


#### GetIntegerVariable(Text)
Get the value of the parameter with the given name.

##### Declaration
```
procedure GetIntegerVariable(Name: Text): Integer
```

##### Parameters
| Type	        | Name      | Description          |
|---------------|-----------|----------------------|
| Text          | *Name*	| Name of the variable |

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| Integer       | value of the variable       |


#### GetDecimalVariable(Text)
Get the value of the parameter with the given name.

##### Declaration
```
procedure GetDecimalVariable(Name: Text): Decimal
```

##### Parameters
| Type	        | Name      | Description          |
|---------------|-----------|----------------------|
| Text          | *Name*	| Name of the variable |

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| Decimal       | value of the variable       |


#### GetBooleanVariable(Text)
Get the value of the parameter with the given name.

##### Declaration
```
procedure GetIntegerVariable(Name: Text): Boolean
```

##### Parameters
| Type	        | Name      | Description          |
|---------------|-----------|----------------------|
| Text          | *Name*	| Name of the variable |

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| Boolean       | value of the variable       |


#### FileCount()
Returns the count of returned files.

##### Declaration
```
procedure FileCount(): Integer
```

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| Integer       | count of returned files     |


#### GetFileName(Integer)
Returns the file name of the given index.

##### Declaration
```
procedure GetFileName(Index: Integer): Text
```

##### Parameters
| Type	        | Name      | Description          |
|---------------|-----------|----------------------|
| Integer       | *Index*   | index of the file    |

##### Returns
| Type	        | Description                 |
|---------------|-----------------------------|
| Text          | the file name               |


#### GetFileContent(Integer, var Record TempBlob)
Returns the file content of the given index.

##### Declaration
```
procedure GetFileContent(Index: Integer, var TempBlob: Record TempBlob)
```

##### Parameters
| Type	          | Name       | Description          |
|-----------------|------------|----------------------|
| Integer         | *Index*	   | index of the file    |
| Record TempBlob | *TempBlob* | file content         |


#### GetFileContent(Text, var Record TempBlob)
Returns the file content of the given file name.

##### Declaration
```
procedure GetFileContent(FileName: Text, var TempBlob: Record TempBlob)
```

##### Parameters
| Type	          | Name       | Description          |
|-----------------|------------|----------------------|
| Text            | *FileName* | Name of the file     |
| Record TempBlob | *TempBlob* | file content         |