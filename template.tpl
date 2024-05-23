___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "categories": [
    "UTILITY"
  ],
  "displayName": "Array to Object",
  "description": "Based on a variable of Array type, it creates a variable of Object type with arbitrary properties.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "inputType",
    "displayName": "Input type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "array",
        "displayValue": "Array"
      },
      {
        "value": "string",
        "displayValue": "String"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "inputVariable",
    "displayName": "Input variable",
    "macrosInSelect": true,
    "selectItems": [],
    "simpleValueType": true,
    "subParams": [
      {
        "type": "TEXT",
        "name": "delimiter",
        "displayName": "Delimiter",
        "simpleValueType": true,
        "help": "Enter the delimiter used in the string referenced by \"Input variable\". \"Input variable\" is divided by the delimiter you enter and treated as an array.",
        "valueHint": "e.g. ,",
        "enablingConditions": [
          {
            "paramName": "inputType",
            "paramValue": "string",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "outputObject",
    "displayName": "Output object",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Key",
        "name": "key",
        "type": "TEXT",
        "valueHint": ""
      }
    ],
    "newRowButtonText": "Add key",
    "alwaysInSummary": true,
    "help": "The values are assigned to the set key names in order from the beginning of the \"Input variable\" array, and converted to objects. If there is an empty \"Key\" row, the array values assigned to it will not be included in the Object type."
  },
  {
    "type": "RADIO",
    "name": "outputType",
    "displayName": "Output type",
    "radioItems": [
      {
        "value": "single",
        "displayValue": "Object",
        "help": "Even if the \"Input variable\" array has more rows than the number of rows specified in \"Output object\", the values are allocated from the beginning of the array as \"Key\" values and any excess is ignored."
      },
      {
        "value": "multi",
        "help": "If the \"Input variable\" array has more rows than the number of rows specified in \"Output object\", it is looped through and created as an array object.",
        "displayValue": "Array object"
      }
    ],
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// -------- Setup
//const log = require('logToConsole');
const getType = require('getType');
const Math = require('Math');
const Object = require('Object');

// -------- Error check
if(getType(data.inputVariable) != data.inputType) return false;	// Type mismatch.
if(!data.outputObject) return false;	// Unset.
const isAllNull = (currentValue) => currentValue.key == '';
if(data.outputObject.every(isAllNull)) return false;	// Setup error.

// -------- Var getting
const sourceArray = (data.inputType == 'string') ? data.inputVariable.split(data.delimiter) : data.inputVariable;

// -------- Object mapping
let returnValue = {};
switch(data.outputType){
	case 'multi':
		returnValue = [];	// Array (+object) type.
		sourceArray.forEach(function(element, index){	// Loop for inputArray.
			const oOindex = index % data.outputObject.length;	// for outputObject index.
			const sAindex = Math.floor(index / data.outputObject.length);	// for sourceArray index.
			returnValue[sAindex] = returnValue[sAindex] || {};
			if(data.outputObject[oOindex].key != '') returnValue[sAindex][data.outputObject[oOindex].key] = element;
		});
		if(Object.keys(returnValue[returnValue.length - 1]).length == 0) returnValue.pop();	// If last array is null, it delete.
		if(returnValue.length == 0) returnValue = undefined;	// If "return value" is null, return null.
		break;
	case 'single':
	default:
		returnValue = {};	// Object type.
		data.outputObject.forEach(function(element, index){	// Loop for outputObject.
			if(element.key != '' && sourceArray[index]) returnValue[element.key] = sourceArray[index];
		});
		if(Object.keys(returnValue).length == 0) returnValue = undefined;	// If last array is null, it delete.
		break;
}
return returnValue;


___TESTS___

scenarios:
- name: Base Setting
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'array',
      inputVariable: '',
      outputObject: [{'key': ''}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: outputObject - 未設定
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'array',
      inputVariable: ['abc', 'def', 'ghi', 'jkl'],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: outputObject - 空のみ
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'array',
      inputVariable: ['abc', 'def', 'ghi', 'jkl'],
      outputObject: [{'key': ''}, {'key': ''}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: outputObject - 1つだけ有効 - 1配列
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'array',
      inputVariable: ['abc', 'def', 'ghi', 'jkl'],
      outputObject: [{'key': ''}, {'key': 'test'}, {'key': ''}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: outputObject - 1つだけ有効 - 2配列
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'array',
      inputVariable: ['abc', 'def', 'ghi', 'jkl'],
      outputObject: [{'key': ''}, {'key': 'test'}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: Type missmatch
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'string',
      inputVariable: ['abc', 'def', 'ghi', 'jkl'],
      outputObject: [{'key': ''}, {'key': 'test'}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: Single - 4 vs 3(1)
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'array',
      inputVariable: ['abc', 'def', 'ghi', 'jkl'],
      outputObject: [{'key': ''}, {'key': 'test'}, {'key': ''}],
      outputType: 'single'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: String - delimiter OK
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'string',
      inputVariable: 'https://ayudante.jp/test/isTest/?kore=test',
      delimiter: '/',
      outputObject: [{'key': ''}, {'key': 'test'}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: String - delimiter 合致無し - multi
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'string',
      inputVariable: 'https://ayudante.jp/test/isTest/?kore=test',
      delimiter: ',',
      outputObject: [{'key': ''}, {'key': 'test'}],
      outputType: 'multi'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: String - delimiter 合致無し - single
  code: |-
    const mockData = {
      // Mocked field values
      inputType: 'string',
      inputVariable: 'https://ayudante.jp/test/isTest/?kore=test',
      delimiter: ',',
      outputObject: [{'key': ''}, {'key': 'test'}],
      outputType: 'single'
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);


___NOTES___

Created on 2024/5/23 15:05:52


