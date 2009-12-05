<cfsetting enablecfoutputonly="true">

<cfoutput>

<cfinclude template="css.cfm">

<h1>Form Groups v0.2</h1>
<p>This plugin provides you with 3 additional form helpers: <tt>checkBoxTagGroup()</tt>, <tt>radioButtonGroup()</tt>, and <tt>radioButtonTagGroup()</tt>. With these new helpers, you can generate groups of check boxes and radio buttons by passing a query, array, or struct as an argument called <tt>options</tt>. This behavior is similar to Wheels <tt><a href="http://cfwheels.org/docs/function/select">select()</a></tt> and <tt><a href="http://cfwheels.org/docs/function/selecttag">selectTag()</a></tt> helpers.</p>

<h2>Optional Fieldset and Legend</h2>
<p>All 3 group helpers have an argument called <tt>isFieldset</tt> that defaults to <tt>true</tt>. When set to <tt>true</tt>, you should provide the matching <tt>legend</tt> argument as well. Then the helpers will wrap your form group with an <abbr title="Hypertext Markup Language">HTML</abbr> <tt>fieldset</tt> and <tt>legend</tt>.</p>
<p>So this example&hellip;</p>
<pre>
##radioButtonGroup(legend="Eye Color", objectName=&quot;customer&quot;, property=&quot;eyeColor&quot;, options=eyeColors, textField="color", valueField="id")##
</pre>
<p>&hellip;would produce markup similar to this:</p>
<pre>
&lt;fieldset&gt;
    &lt;legend&gt;Eye Color&lt;/legend&gt;
    &lt;label for=&quot;customer-eyeColor-1&quot;&gt;Blue &lt;input type=&quot;radio&quot; id=&quot;customer-eyeColor-1&quot; name=&quot;customer[eyeColor]&quot value=&quot;1&quot; /&gt;&lt;/label&gt;
    &lt;label for=&quot;customer-eyeColor-4&quot;&gt;Brown &lt;input type=&quot;radio&quot; id=&quot;customer-eyeColor-4&quot; name=&quot;customer[eyeColor]&quot; value=&quot;4&quot; /&gt;&lt;/label&gt;
    &lt;label for=&quot;customer-eyeColor-3&quot;&gt;Green &lt;input type=&quot;radio&quot; id=&quot;customer-eyeColor-3&quot; name=&quot;customer[eyeColor]&quot; value=&quot;3&quot; /&gt;&lt;/label&gt;
    &lt;label for=&quot;customer-eyeColor-2&quot;&gt;Hazel &lt;input type=&quot;radio&quot; id=&quot;customer-eyeColor-2&quot; name=&quot;customer[eyeColor]&quot; value=&quot;2&quot; /&gt;&lt;/label&gt;
&lt;/fieldset&gt;
</pre>
<p>Like with the Wheels <tt><a href="http://cfwheels.org/docs/function/select">select()</a></tt> form helper, passing <tt>textField</tt> and <tt>valueField</tt> specifies which fields in <tt>options</tt> to use as the display text and radio button value, respectively.</p>
<p>Here is documentation for the <tt>fieldset</tt> and <tt>legend</tt> arguments that are common to all 3 helpers:</p>
<table>
	<thead>
		<tr>
			<th>Argument</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><tt>isFieldset</tt></td>
			<td>boolean</td>
			<td><tt>false</tt></td>
			<td><tt>true</tt></td>
			<td>Whether or not to wrap the group in <abbr title="Hypertext Markup Language">HTML</abbr> <tt>fieldset</tt> tags.</td>
		</tr>
		<tr class="highlight">
			<td><tt>legend</tt></td>
			<td>string</td>
			<td><tt>false</tt></td>
			<td><tt>[empty string]</td>
			<td><abbr title="Hypertext Markup Language">HTML</abbr> legend to show. Recommended if <tt>isFieldset</tt> is set to <tt>true</tt>.</td>
		</tr>
		<tr>
			<td><tt>fieldsetId</tt></td>
			<td>string</td>
			<td><tt>false</tt></td>
			<td><tt>[empty string]</tt></td>
			<td><tt>id</tt> attribute to add to <tt>fieldset</tt> tag.</td>
		</tr>
		<tr class="highlight">
			<td><tt>fieldsetClass</tt></td>
			<td>string</td>
			<td><tt>false</tt></td>
			<td><tt>[empty string]</tt></td>
			<td><tt>class</tt> attribute to add to <tt>fieldset</tt> tag.</td>
		</tr>
		<tr>
			<td><tt>legendId</tt></td>
			<td>string</td>
			<td><tt>false</tt></td>
			<td><tt>[empty string]</tt></td>
			<td><tt>id</tt> attribute to add to <tt>legend</tt> tag.</td>
		</tr>
		<tr class="highlight">
			<td><tt>legendClass</tt></td>
			<td>string</td>
			<td><tt>false</tt></td>
			<td><tt>[empty string]</tt></td>
			<td><tt>class</tt> attribute to add to <tt>legend</tt> tag.</td>
		</tr>
	</tbody>
</table>

<h2>Radio Button Groups</h2>
<p>You can show a group of radio buttons either bound to a model object or as standalone tags with names and values.</p>

<h3>Bind to Objects with <code>radioButtonGroup()</code></h3>
<p>Like other <a href="http://cfwheels.org/docs/chapter/form-helpers-and-showing-errors">form helpers</a> standard to Wheels, radio button groups can be bound directly to a model by using <tt>radioButtonGroup()</tt>. You pass in an <tt>objectName</tt>, <tt>property</tt>, and a query, array, or object for <tt>options</tt>.</p>
<p>Here is another example, this time passing a struct for <tt>options</tt>:</p>
<pre>
&lt;cfset colors = {"1"="Blue", "4"="Brown", "3"="Green", "2"="Hazel"}&gt;
##radioButtonGroup(legend="Eye Color", objectName=&quot;customer&quot;, property=&quot;eyeColor&quot;, options=colors)##
</pre>
<p>Note that you do not need to provide arguments for <tt>textField</tt> and <tt>valueField</tt> when the value of <tt>options</tt> is a struct. The helpers will use the structs keys as values and the associated struct values as display text.</p>

<h3>Just Show the Tags with <code>radioButtonTagGroup()</code></h3>
<p>This is similar to the &quot;Tag&quot; helpers found in Wheels as well. Sometimes you need to show a group of radio buttons that <em>aren't</em> bound to an object. Perhaps you're buidling a search form that doesn't tie to a database table.</p>
<p>With <tt>radioButtonTagGroup()</tt>, you pass in a <tt>name</tt>, <tt>value</tt>, and the value that should be <tt>checked</tt> instead of the model object properties.</p>
<p>Here is an example search form based on <a href="http://www.google.de/">Google Deutschland</a> (if it were implemented with Wheels instead):</p>
<pre>
##textFieldTag(name=&quot;q&quot;, value=params.q)##
##submitTag(name=&quot;btn&quot;, value=&quot;Google-Suche&quot;)##
##submitTag(name=&quot;btn&quot;, value=&quot;Auf gut Gl&amp;####252;ck!&quot;)##
##radioButtonTagGroup(legend=&quot;Suche:&quot;, name=&quot;meta&quot;, options={lr=&quot;Das Web&quot;, lang_de=&quot;Seiten auf Deutsch&quot;, cr=&quot;Seiten aus Deutschland&quot;}, checked=&quot;lr&quot;, fieldsetClass=&quot;search-options&quot;, labelPlacement=&quot;after&quot;)##
</pre>
<p>That example would produce <abbr title="Hypertext Markup Language">HTML</abbr> markup similar to this:</p>
<pre>
&lt;input type=&quot;text&quot; name=&quot;q&quot; value=&quot;&quot; /&gt;
&lt;input type=&quot;submit&quot; name=&quot;btn&quot; value=&quot;Google-Suche&quot; /&gt;
&lt;input type=&quot;submit&quot; name=&quot;btn&quot; value=&quot;Auf gut Gl&amp;##252;ck!&quot; /&gt;
&lt;fieldset class=&quot;search-options&quot;&gt;
    &lt;legend&gt;Suche:&lt;/legend&gt;
    &lt;input id=&quot;meta-lr&quot; type=&quot;radio&quot; name=&quot;meta&quot; value=&quot;lr&quot; checked=&quot;checked&quot; /&gt;&lt;label for=&quot;meta-lr&quot;&gt;Das Web&lt;/label&gt;
    &lt;input id=&quot;meta-lang_de&quot; type=&quot;radio&quot; name=&quot;meta&quot; value=&quot;lang_de&quot; /&gt;&lt;label for=&quot;meta-lang_de&quot;&gt;Seiten auf Deutsch&lt;/label&gt;
    &lt;input id=&quot;meta-cr&quot; type=&quot;radio&quot; name=&quot;meta&quot; value=&quot;cr&quot; /&gt;&lt;label for=&quot;meta-cr&quot;&gt;Seiten aus Deutschland&lt;/label&gt;
&lt;/fieldset&gt;
</pre>
<p>Notice that the <tt>checked</tt> argument in the example above causes the <tt>lr</tt> value to be checked by default.</p>

<h2>Check Box Groups</h2>
<p>Because groups of check boxes allow you to select multiple values, this would map to a many-to-many relationship in your model (or you would store the list of IDs in a column in your database table). The nature of a many-to-many relationship dictates that there really is no model to bind the check box group to directly. Accordingly, there is only a &quot;Tag&quot; style helper for check box groups.</p>

<h3>Show the Tags with <code>checkBoxTagGroup()</code></h3>
<p>The <tt>checkBoxTagGroup()</tt> helper is similar to <tt>radioButtonTagGroup()</tt>, except the <tt>checked</tt> argument accepts a list, query, or array of values that should be checked by default.</p>
<p>Here is an example of a form for editing a developer's preferred <abbr title="ColdFusion Markup Language">CFML</abbr> engines.</p>
<pre>
&lt;--- In the controller ---&gt;
&lt;cfset allCfmlEngines = model(&quot;cfmlEngine&quot;).findAll(order=&quot;engine&quot;)&gt;
&lt;cfset developer = model(&quot;developer&quot;).findByKey(params.key)&gt;
&lt;--- For this example, developer is tied to cfmlEngine through a join table called preferredCfmlEngines and an association of hasMany(name=&quot;preferredCfmlEngines&quot; shortcut=&quot;cfmlEngines&quot;) ---&gt;
&lt;cfset preferredCfmlEngines = developer.cfmlEngines()&gt;

&lt;--- In the view ---&gt;
##checkBoxTagGroup(legend=&quot;Preferred CFML Engine&quot;, name=&quot;cfmlEngines&quot;, options=allCfmlEngines, checked=preferredCfmlEngines, textField=&quot;engine&quot;, valueField=&quot;id&quot;)##
</pre>
<p>If the database returned that the developer's preferred engines were Railo and OpenBD, here is what the produced markup would look similar to:</p>
<pre>
&lt;fieldset&gt;
    &lt;legend&gt;Preferred CFML Engines&lt;/legend&gt;
    &lt;label for=&quot;cfmlEngine-1&quot;&gt;ColdFusion&lt;input type=&quot;checkbox&quot; id=&quot;cfmlEngine-1&quot; name=&quot;cfmlEngine&quot; value=&quot;1&quot; /&gt;&lt;/label&gt;
    &lt;label for=&quot;cfmlEngine-2&quot;&gt;OpenBD&lt;input type=&quot;checkbox&quot; id=&quot;cfmlEngine-2&quot; name=&quot;cfmlEngine&quot; value=&quot;2&quot; checked=&quot;checked&quot; /&gt;&lt;/label&gt;
    &lt;label for=&quot;cfmlEngine-3&quot;&gt;Railo&lt;input type=&quot;checkbox&quot; id=&quot;cfmlEngine-3&quot; name=&quot;cfmlEngine&quot; value=&quot;3&quot; checked=&quot;checked&quot; /&gt;&lt;/label&gt;
&lt;/fieldset&gt;
</pre>

<h2>Setting Global Defaults</h2>
<p>These 3 group helpers are similar to standard Wheels form helpers in that you can also set <a href="http://cfwheels.org/docs/chapter/configuration-and-defaults">global defaults</a> for the behavior of the radio buttons and check boxes.</p>
<p>For example, if we wanted to make all labels appear after their respective check boxes and radio buttons, we would set the following global defaults in <kbd>config/settings.cfm</kbd>:</p>
<pre>
##cfset set(functionName=&quot;checkBoxTagGroup&quot;, labelPlacement=&quot;after&quot;)&gt;
##cfset set(functionName=&quot;radioButtonGroup&quot;, labelPlacement=&quot;after&quot;)&gt;
##cfset set(functionName=&quot;radioButtonTagGroup&quot;, labelPlacement=&quot;after&quot;)&gt;
</pre>
<p>If we wanted to always have them default to not having a <tt>fieldset</tt> wrapper, we could add to the configurations like so:</p>
<pre>
##cfset set(functionName=&quot;checkBoxTagGroup&quot;, <ins>isFieldset=false</ins>, labelPlacement=&quot;after&quot;)&gt;
##cfset set(functionName=&quot;radioButtonGroup&quot;, <ins>isFieldset=false</ins>, labelPlacement=&quot;after&quot;)&gt;
##cfset set(functionName=&quot;radioButtonTagGroup&quot;, <ins>isFieldset=false</ins>, labelPlacement=&quot;after&quot;)&gt;
</pre>

<h3>List of Global Defaults</h3>
<p>Global defaults can be set for the following form group arguments. Again, they are similar to their counterparts in the standard Wheels form helpers.</p>
<ul>
	<li><tt>valueField</tt></li>
	<li><tt>textField</tt></li>
	<li><tt>labelPlacement</tt></li>
	<li><tt>prependToLabel</tt></li>
	<li><tt>appendToLabel</tt></li>
	<li><tt>prepend</tt></li>
	<li><tt>append</tt></li>
</ul>

<h2>Credits</h2>
<p>This plugin was created by <a href="http://www.clearcrystalmedia.com/pm/">Chris Peters</a>.</p>

</cfoutput>

<cfsetting enablecfoutputonly="false">