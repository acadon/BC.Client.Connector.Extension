# Table ACA - ACC Function
### Fields
#### ID
ID of the function.

##### Declaration
```Text
ID: Integer
```


#### Description
Short description of the function.

##### Declaration
```Text
Description: Text[100]
```


#### Script
The LUA script.

##### Declaration
```Text
Script: Blob
```


### Methods

#### InsertFunction(Integer, Text[100], Record TempBlob)
This function registered a new function in the **ACC Function** Table.

##### Declaration
```
procedure InsertFunction(Id: integer; Description: Text[100]; Script: Record TempBlob)
```

##### Parameters
| Type	          | Name            | Description                        |
|-----------------|-----------------|------------------------------------|
| Id              | *Id*	        | Id of the function. Should be in the object range of the using extension. |
| Text[100]       | *Description*	| Short description of the function. |
| Record TempBlob | *Script*    	| LUA script as blob.                |

