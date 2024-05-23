# Array to Object
A custom variable template for Google Tag Manager that generates an object type variable with an arbitrary key name from the value of an array type JS variable.  

This can be useful for formatting the various data on a page in a website system to make it easier to understand when the data is output as an array rather than an object type.  
It is also possible to map string-type data to object types by splitting the data with delimiters. For example, data concatenated by delimiters and stored in a cookie can be easily decomposed into object types.

## How to use
1. **In "Input type" and "Input variable," specify the variable you wish to convert to an object type.**  
   At this time, when referring to a variable of string type, specify a delimiter character in "Delimiter" to break it up into an array type and refer to it.
2. **Set each key of the object you wish to generate in "Output object".**  
   The value of the set key will be assigned from the beginning of the array referenced in "Input variable".  
   If key is left empty, the array value at the corresponding position in the original data will be omitted from the object.
3. **Finally, "Output type" selects whether the output object should be an array.**  
   If "Object" is selected, "Input variable" is referenced from the first value, and the portion exceeding the number of lines set in "Output object" is ignored.
   If "Array object" is selected, the return value is a variable of array object type. If the array in "Input variable" has more rows than the "Output object", it can be combined as multiple object data.

## Actual output example
### Input variable's value sample
```javascript
['Good looking title', 'Cool writing', 'Column', 'Special news', 'detail', 'Taro']
```
### Output Example
#### Output object: ['page_title', 'page_description', 'content_group', 'page_category', 'page_type', 'author'],  Output type: Object
```javascript
{
 'page_title': 'Good looking title',
 'page_description': 'Cool writing',
 'content_group': 'Column',
 'page_category': 'Special news',
 'page_type': 'detail',
 'author': 'Taro'
}
```

#### Output object: ['', '', 'content_group', 'page_category', 'page_type'],  Output type: Object
```javascript
{
 'content_group': 'Column',
 'page_category': 'Special news',
 'page_type': 'detail'
}
```

## Memo
- If the referenced "Input variable" is not of the intended type, the return value is **false**.
- If the generated "Output object" does not contain any valid rows (non-blank rows), the return value is **false**.
- If the object does not have any valid key values as a result of referencing "Input variable", the return value is **undefined**.

## Editing history
### [2024/05/23 (New)] Ayudante, Inc.
- It was new registration.
