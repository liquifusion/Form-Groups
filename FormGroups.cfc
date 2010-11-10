<cfcomponent output="false" mixin="controller">

	<!----------------------------------------------------->
	<!--- Public --->

	<cffunction name="init" hint="Constructor. Initializes plugin and sets global defaults for new helpers.">
		
		<!--- Wheels version number --->
		<cfset this.version = "1.0,1.0.1,1.0.2,1.0.3,1.0.4,1.0.5">
		
		<!--- Settings for default values --->
		<cfset $setDefaultValue(functionName="checkBoxTagGroup", valueField="id", textField="name", labelPlacement="around", prependToLabel="", appendToLabel="", prepend="", append="", errorElement="span")>
		<cfset $setDefaultValue(functionName="radioButtonGroup", valueField="id", textField="name", labelPlacement="around", prependToLabel="", appendToLabel="", prepend="", append="", errorElement="span")>
		<cfset $setDefaultValue(functionName="radioButtonTagGroup", valueField="id", textField="name", labelPlacement="around", prependToLabel="", appendToLabel="", prepend="", append="", errorElement="span")>
		
		<cfreturn this>
	
	</cffunction>
	
	<!----------------------------------------------------->
	
	<cffunction name="checkBoxTagGroup" returntype="string" hint="Returns a group of check boxes based on names and values.">
		<cfargument name="name" type="variablename" required="true" hint="Name to populate in each of the check boxes' tags.">
		<cfargument name="options" required="true" hint="Query, array, or struct containing options that will populate the check boxes.">
		<cfargument name="checked" required="false" default="" hint="Query, array, or list of values that should be checked by default. For queries and arrays, this method will inspect the field specified by the `valueField` argument.">
		<cfargument name="valueField" type="variablename" required="false" default="#get(functionName='checkBoxTagGroup', name='valueField')#" hint="When a query or array is passed for `options`, pass the name of the field containing value. Ignored if `options` is a struct.">
		<cfargument name="textField" type="variablename" required="false" default="#get(functionName='checkBoxTagGroup', name='textField')#" hint="When a query or array is passed for `options`, pass the name of the field containing text that should be displayed as check boxes' labels. Ignored if `options` is a struct.">
		<cfargument name="isFieldset" type="boolean" required="false" default="true" hint="Whether or not to wrap the group in HTML `fieldset` tags.">
		<cfargument name="legend" type="string" required="false" default="" hint="HTML legend to show if `isFieldset` is set to `true`.">
		<cfargument name="fieldsetId" type="string" required="false" default="" hint="id attribute to add to fieldset tag.">
		<cfargument name="fieldsetClass" type="string" required="false" default="" hint="class attribute to add to fieldset tag.">
		<cfargument name="legendId" type="string" required="false" default="" hint="id attribute to add to legend tag.">
		<cfargument name="legendClass" type="string" required="false" default="" hint="class attribute to add to legend tag.">
		<cfargument name="labelPlacement" type="string" required="false" default="#get(functionName='checkBoxTagGroup', name='labelPlacement')#" hint="Label placement. Choices are `before`, `after`, and `around`.">
		<cfargument name="prependToLabel" type="string" required="false" default="#get(functionName='checkBoxTagGroup', name='prependToLabel')#" hint="String to prepend to check boxes' labels.">
		<cfargument name="appendToLabel" type="string" required="false" default="#get(functionName='checkBoxTagGroup', name='appendToLabel')#" hint="String to append to check boxes' labels.">
		<cfargument name="prepend" type="string" required="false" default="#get(functionName='checkBoxTagGroup', name='prepend')#" hint="String to prepend to input field.">
		<cfargument name="append" type="string" required="false" default="#get(functionName='checkBoxTagGroup', name='append')#" hint="String to append to input field.">
		
		<cfset var loc = {}>
		<cfset loc.returnValue = "">
		
		<!--- Convert options to list --->
		<cfset loc.checkedValues = $convertCheckedValuesToList(arguments.checked, arguments.valueField)>
		
		<!--- If we're dealing with a query --->
		<cfif IsQuery(arguments.options)>
			<cfloop query="arguments.options">
				<!--- Whether or not checkbox should be checked --->
				<cfset loc.checked = ListFind(loc.checkedValues, arguments.options[arguments.valueField][arguments.options.CurrentRow]) gt 0>
				<cfset
					loc.returnValue &= checkBoxTag(
						id="#arguments.name#-#arguments.options[arguments.valueField][arguments.options.CurrentRow]#",
						name=arguments.name,
						label=arguments.options[arguments.textField][arguments.options.CurrentRow],
						value=arguments.options[arguments.valueField][arguments.options.CurrentRow],
						checked=loc.checked,
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		<!--- If we're dealing with an array --->
		<cfelseif IsArray(arguments.options)>
			<cfloop array="#arguments.options#" index="loc.option">
				<!--- Whether or not checkbox should be checked --->
				<cfset loc.checked = ListFind(loc.checkedValues, loc.option[arguments.valueField]) gt 0>
				<cfset
					loc.returnValue &= checkBoxTag(
						id="#arguments.name#-#loc.option[arguments.valueField]#",
						name=arguments.name,
						label=loc.option[arguments.textField],
						value=loc.option[arguments.valueField],
						checked=loc.checked,
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		<!--- If we're dealing with a struct --->
		<cfelseif IsStruct(arguments.options)>
			<cfset loc.structKeys = StructKeyList(arguments.options)>
			<cfloop list="#loc.structKeys#" index="loc.key">
				<cfset loc.checked = ListFind(loc.checkedValues, loc.key) gt 0>
				<cfset
					loc.returnValue &= checkBoxTag(
						id="#arguments.name#-#loc.key#",
						name=arguments.name,
						label=arguments.options[loc.key],
						value=loc.key,
						checked=loc.checked,
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		</cfif>
		
		<!--- Fieldset --->
		<cfif arguments.isFieldset>
			<cfset loc.fieldsetArgs = $buildFieldsetArguments(arguments)>
			<cfset loc.fieldsetArgs.stringToWrap = loc.returnValue>
			<cfset loc.returnValue = wrapFieldset(argumentCollection=loc.fieldsetArgs)>
		</cfif>
		
		<cfreturn loc.returnValue>
		
	</cffunction>
	
	<!----------------------------------------------------->
	
	<cffunction name="radioButtonGroup" returntype="string" hint="Returns a group of radio buttons bound to a property in a model object.">
		<cfargument name="objectName" type="variablename" required="true" hint="Name of object to bind the value to.">
		<cfargument name="property" type="variablename" required="true" hint="Name of property within object that the field group is bound to.">
		<cfargument name="options" required="true" hint="Query, array, or struct containing options that populate the radio buttons.">
		<cfargument name="valueField" type="variablename" required="false" default="#get(functionName='radioButtonGroup', name='valueField')#" hint="When a query or array is passed for `options`, pass the name of the field containing value. Ignored if `options` is a struct.">
		<cfargument name="textField" type="variablename" required="false" default="#get(functionName='radioButtonGroup', name='textField')#" hint="When a query or array is passed for `options`, pass the name of the field containing text that should be displayed as radio buttons' labels. Ignored if `options` is a struct.">
		<cfargument name="isFieldset" type="boolean" required="false" default="true" hint="Whether or not to wrap the group in HTML `fieldset` tags.">
		<cfargument name="legend" type="string" required="false" default="" hint="HTML legend to show if `isFieldset` is set to `true`.">
		<cfargument name="fieldsetId" type="string" required="false" default="" hint="id attribute to add to fieldset tag.">
		<cfargument name="fieldsetClass" type="string" required="false" default="" hint="class attribute to add to fieldset tag.">
		<cfargument name="legendId" type="string" required="false" default="" hint="id attribute to add to legend tag.">
		<cfargument name="legendClass" type="string" required="false" default="" hint="class attribute to add to legend tag.">
		<cfargument name="labelPlacement" type="string" required="false" default="#get(functionName='radioButtonGroup', name='labelPlacement')#" hint="Label placement. Choices are `before`, `after`, and `around`.">
		<cfargument name="prependToLabel" type="string" required="false" default="#get(functionName='radioButtonGroup', name='prependToLabel')#" hint="String to prepend to radio buttons' labels.">
		<cfargument name="appendToLabel" type="string" required="false" default="#get(functionName='radioButtonGroup', name='appendToLabel')#" hint="String to append to radio buttons' labels.">
		<cfargument name="prepend" type="string" required="false" default="#get(functionName='radioButtonGroup', name='prepend')#" hint="String to prepend to input field.">
		<cfargument name="append" type="string" required="false" default="#get(functionName='radioButtonGroup', name='append')#" hint="String to append to input field.">
		<cfargument name="errorElement" type="string" required="false" default="#get(functionName='radioButtonGroup', name='errorElement')#" hint="HTML element to use in the event that an error occurred for this field.">
		
		<cfset var loc = {}>
		<cfset loc.returnValue = "">
		
		<!--- If we're dealing with a query --->
		<cfif IsQuery(arguments.options)>
			<cfloop query="arguments.options">
				<cfset
					loc.returnValue &= radioButton(
						objectName=arguments.objectName,
						property=arguments.property,
						tagValue=arguments.options[arguments.valueField][arguments.options.CurrentRow],
						label=arguments.options[arguments.textField][arguments.options.CurrentRow],
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		<!--- If we're dealing with an array --->
		<cfelseif IsArray(arguments.options)>
			<cfloop array="#arguments.options#" index="loc.option">
				<cfset
					loc.returnValue &= radioButton(
						objectName=arguments.objectName,
						property=arguments.property,
						tagValue=loc.option[arguments.valueField],
						label=loc.option[arguments.textField],
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		<!--- If we're dealing with a struct --->
		<cfelseif isStruct(arguments.options)>
			<cfset loc.structKeys = StructKeyList(arguments.options)>
			<cfloop list="#loc.structKeys#" index="loc.key">
				<cfset
					loc.returnValue &= radioButton(
						objectName=arguments.objectName,
						property=arguments.property,
						tagValue=loc.key,
						label=arguments.options[loc.key],
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		</cfif>
		
		<!--- Fieldset --->
		<cfif arguments.isFieldset>
			<cfset loc.fieldsetArgs = $buildFieldsetArguments(arguments)>
			<cfset loc.fieldsetArgs.stringToWrap = loc.returnValue>
			<cfset loc.returnValue = wrapFieldset(argumentCollection=loc.fieldsetArgs)>
		</cfif>
		
		<cfreturn loc.returnValue>
		
	</cffunction>
	
	<!----------------------------------------------------->
	
	<cffunction name="radioButtonTagGroup" returntype="string" hint="Returns a group of radio buttons based on names and values.">
		<cfargument name="name" type="variablename" required="true" hint="Name to populate in each of the radio buttons' tags.">
		<cfargument name="options" required="true" hint="Query, array, or struct containing options that should populate the radio buttons.">
		<cfargument name="selected" type="string" required="false" default="" hint="Value of option that should be selected by default.">
		<cfargument name="valueField" type="variablename" required="false" default="#get(functionName='radioButtonTagGroup', name='valueField')#" hint="When a query or array is passed for `options`, pass the name of the field containing value. Ignored if `options` is a struct.">
		<cfargument name="textField" type="variablename" required="false" default="#get(functionName='radioButtonTagGroup', name='textField')#" hint="When a query or array is passed for `options`, pass the name of the field containing text that should be displayed as radio button label. Ignored if `options` is a struct.">
		<cfargument name="isFieldset" type="boolean" required="false" default="true" hint="Whether or not to wrap the group in HTML `fieldset` tags.">
		<cfargument name="legend" type="string" required="false" default="" hint="HTML legend to show if `isFieldset` is set to true.">
		<cfargument name="fieldsetId" type="string" required="false" default="" hint="id attribute to add to fieldset tag.">
		<cfargument name="fieldsetClass" type="string" required="false" default="" hint="class attribute to add to fieldset tag.">
		<cfargument name="legendId" type="string" required="false" default="" hint="id attribute to add to legend tag.">
		<cfargument name="legendClass" type="string" required="false" default="" hint="class attribute to add to legend tag.">
		<cfargument name="labelPlacement" type="string" required="false" default="#get(functionName='radioButtonTagGroup', name='labelPlacement')#" hint="Label placement. Choices are `before`, `after`, and `around`.">
		<cfargument name="prependToLabel" type="string" required="false" default="#get(functionName='radioButtonTagGroup', name='prependToLabel')#" hint="String to prepend to radio buttons' labels.">
		<cfargument name="appendToLabel" type="string" required="false" default="#get(functionName='radioButtonTagGroup', name='appendToLabel')#" hint="String to append to radio buttons' labels.">
		<cfargument name="prepend" type="string" required="false" default="#get(functionName='radioButtonTagGroup', name='prepend')#" hint="String to prepend to input field.">
		<cfargument name="append" type="string" required="false" default="#get(functionName='radioButtonTagGroup', name='append')#" hint="String to append to input field.">
		
		<cfset var loc = {}>
		<cfset loc.returnValue = "">
		
		<!--- If we're dealing with a query --->
		<cfif IsQuery(arguments.options)>
			<cfloop query="arguments.options">
				<cfset loc.checked = arguments.options[arguments.valueField][arguments.options.CurrentRow] eq arguments.selected>
				<cfset
					loc.returnValue &= radioButtonTag(
						name=arguments.name,
						label=arguments.options[arguments.textField][arguments.options.CurrentRow],
						value=arguments.options[arguments.valueField][arguments.options.CurrentRow],
						checked=loc.checked,
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		<!--- If we're dealing with an array --->
		<cfelseif IsArray(arguments.options)>
			<cfloop array="#arguments.options#" index="loc.option">
				<cfset loc.checked = loc.option[arguments.valueField] eq arguments.selected>
				<cfset
					loc.returnValue &= radioButtonTag(
						name=arguments.name,
						label=loc.option[arguments.textField],
						value=loc.option[arguments.valueField],
						checked = loc.checked,
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		<!--- If we're dealing with a struct --->
		<cfelseif isStruct(arguments.options)>
			<cfset loc.structKeys = StructKeyList(arguments.options)>
			<cfloop list="#loc.structKeys#" index="loc.key">
				<cfset loc.checked = arguments.options[loc.key] eq arguments.selected>
				<cfset
					loc.returnValue &= radioButtonTag(
						name=arguments.name,
						label=arguments.options[loc.key],
						value=loc.key,
						checked = loc.checked,
						labelPlacement=arguments.labelPlacement,
						prependToLabel=arguments.prependToLabel,
						appendToLabel=arguments.appendToLabel,
						prepend=arguments.prepend,
						append=arguments.append
					)
				>
			</cfloop>
		</cfif>
		
		<!--- Fieldset --->
		<cfif arguments.isFieldset>
			<cfset loc.fieldsetArgs = $buildFieldsetArguments(arguments)>
			<cfset loc.fieldsetArgs.stringToWrap = loc.returnValue>
			<cfset loc.returnValue = wrapFieldset(argumentCollection=loc.fieldsetArgs)>
		</cfif>
		
		<cfreturn loc.returnValue>
		
	</cffunction>
	
	<!----------------------------------------------------->
	
	<cffunction name="wrapFieldset" returntype="string" hint="Wraps given string with fieldset and legend tags.">
		<cfargument name="stringToWrap" type="string" required="true" hint="String to wrap.">
		<cfargument name="legend" type="string" required="true" hint="Label to put in between legend tags.">
		<cfargument name="fieldsetId" type="string" required="false" default="" hint="id attribute to add to fieldset tag.">
		<cfargument name="fieldsetClass" type="string" required="false" default="" hint="class attribute to add to fieldset tag.">
		<cfargument name="legendId" type="string" required="false" default="" hint="id attribute to add to legend tag.">
		<cfargument name="legendClass" type="string" required="false" default="" hint="class attribute to add to legend tag.">
		
		<cfset var loc = {}>
		<cfset loc.returnValue = "">
		
		<!--- Fieldset --->
		<cfset loc.returnValue &= "<fieldset">
		<cfif Len(arguments.fieldsetId) gt 0>
			<cfset loc.returnValue &= ' id="#arguments.fieldsetId#"'>
		</cfif>
		<cfif Len(arguments.fieldsetClass) gt 0>
			<cfset loc.returnValue &= ' class="#arguments.fieldsetClass#"'>
		</cfif>
		
		<!--- Legend --->
		<cfset loc.returnValue &= "><legend">
		<cfif Len(arguments.legendId) gt 0>
			<cfset loc.returnValue &= ' id="#arguments.legendId#"'>
		</cfif>
		<cfif Len(arguments.legendClass) gt 0>
			<cfset loc.returnValue &= ' class="#arguments.legendClass#"'>
		</cfif>
		
		<!--- The rest --->
		<cfset loc.returnValue &= ">#arguments.legend#</legend>#arguments.stringToWrap#</fieldset>">
		
		<cfreturn loc.returnValue>
	
	</cffunction>
	
	<!----------------------------------------------------->
	<!--- Private --->
	
	<cffunction name="$buildFieldsetArguments" returntype="struct" hint="Cleans struct for use as `argumentCollection` to `wrapFieldset()`.">
		<cfargument name="argumentsStruct" type="struct" required="true" hint="`arguments` struct from calling method.">
		
		<cfset var loc = {}>
		
		<cfset loc.fieldsetArgs.legend = arguments.argumentsStruct.legend>
		<cfset loc.fieldsetArgs.fieldsetId = arguments.argumentsStruct.fieldsetId>
		<cfset loc.fieldsetArgs.fieldsetClass = arguments.argumentsStruct.fieldsetClass>
		<cfset loc.fieldsetArgs.legendId = arguments.argumentsStruct.legendId>
		<cfset loc.fieldsetArgs.legendClass = arguments.argumentsStruct.legendClass> 
		
		<cfreturn loc.fieldsetArgs>
	
	</cffunction>
	
	<!----------------------------------------------------->
	
	<cffunction name="$convertCheckedValuesToList" returntype="string" hint="Converts list, query, or array of values into a list based on `valueField`.">
		<cfargument name="checked" required="true" hint="List, query, or array of checked values to convert.">
		<cfargument name="valueField" type="variablename" required="true" hint="Name of value field to insert in list.">
		
		<cfset var loc = {}>
		<cfset loc.checkedValues = "">
		
		<!--- List of options --->
		<cfif IsSimpleValue(arguments.checked)>
			<cfset loc.checkedValues = arguments.checked>
		<!--- Query of options --->
		<cfelseif IsQuery(arguments.checked)>
			<cfloop query="arguments.checked">
				<cfset loc.checkedValues = ListAppend(loc.checkedValues, arguments.checked[arguments.valueField][arguments.checked.CurrentRow])>
			</cfloop>
		<!--- Array of options --->
		<cfelseif IsArray(arguments.checked)>
			<cfloop array="#arguments.checked#" index="loc.checked">
				<cfset loc.checkedValues = ListAppend(loc.checkedValues, loc.checked[arguments.valueField])>
			</cfloop>
		</cfif>
		
		<cfreturn loc.checkedValues>
	
	</cffunction>
	
	<!----------------------------------------------------->
	
	<cffunction name="$createLabel" returntype="string" access="public" output="false" hint="Fix for label `for` attribute bug in Wheels 1.0.">
        <cfargument name="objectName" type="any" required="true">
        <cfargument name="property" type="string" required="true">
        <cfargument name="label" type="string" required="true">
        <cfargument name="prependToLabel" type="string" required="true">
        <cfargument name="$appendToFor" type="string" required="false" default="">
        <cfscript>
                var loc = {};
                loc.returnValue = arguments.prependToLabel;
                loc.attributes = {};
                for (loc.key in arguments)
                {
                 if (Left(loc.key, 5) == "label" && Len(loc.key) > 5 && loc.key != "labelPlacement")
                        loc.attributes[Replace(loc.key, "label", "")] = arguments[loc.key];
                }
                if (StructKeyExists(arguments, "id"))
                        loc.attributes.for = arguments.id;
                else
                        loc.attributes.for = $tagId(arguments.objectName, arguments.property);
                if (Len(arguments.$appendToFor))
                        loc.attributes.for = loc.attributes.for & "-" & arguments.$appendToFor;
                loc.returnValue = loc.returnValue & $tag(name="label", attributes=loc.attributes);
                loc.returnValue = loc.returnValue & arguments.label;
                loc.returnValue = loc.returnValue & "</label>";
        </cfscript>
        <cfreturn loc.returnValue>
	</cffunction>

	
	<!----------------------------------------------------->
	
	<cffunction name="$setDefaultValue" hint="Sets a default value for a form helper created in this component.">
		
		<cfset var loc = {}>
		
		<cfloop list="#StructKeyList(arguments)#" index="loc.argument">
			<cfif
				loc.argument is not "functionName"
				and not IsDefined("application.wheels.functions.#arguments.functionName#.#loc.argument#")
			>
				<cfset application.wheels.functions[arguments.functionName][loc.argument] = arguments[loc.argument]>
			</cfif>
		</cfloop>
	
	</cffunction>
	
	<!----------------------------------------------------->

</cfcomponent>