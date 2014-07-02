<div id="transport" class="styledform ui-widget-content">
{form action="xsettings.php$sid" name="transport"}
<input type="hidden" name="domain_id" value="{$domain_id}">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_transport}&nbsp;
<font size="3"><a href="adminhelp.php#domain_tranport{$sid}" target="new">[?]</a></font></td>
</tr>

{if $super}
<tr>
<td class="menubody" align="left">{$lang.text_routing_domain}</td>
<td class="menubody" align="left">
<input type="text" name="routing_domain" value="{$routing_domain}" size="20">
</td>
</tr>
{/if}

<tr>
<td class="menubody" align="left">{$lang.text_transport}</td>
<td class="menubody" align="left">
<input type="text" name="transport" value="{$transport}" size="20">
</td>
</tr>

<tr>
<td class="menubody" align="center" colspan="2">
<input type="submit" name="set_transport" value="{$lang.button_transport}">
</td>
</tr>
</table>
</form>
</div>