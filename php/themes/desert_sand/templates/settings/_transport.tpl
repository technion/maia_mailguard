<div id="transport" class="styledform ui-widget-content">
{form action="xsettings.php$sid" name="transport"}
<input type="hidden" name="domain_id" value="{$domain_id}">
<fieldset>
<legend>{$lang.header_transport}&nbsp;<a href="adminhelp.php#domain_tranport{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if $super}
    <li>
    <label>{$lang.text_routing_domain}</label>
    <input type="text" name="routing_domain" value="{$routing_domain}">
    </li>
{/if}
    <li>
    <label>{$lang.text_transport}</label>
    <input type="text" name="transport" value="{$transport}">
    </li>
    <li class="submitrow">
    <input type="submit" name="set_transport" value="{$lang.button_transport}">
    </li>
</ol>
</fieldset>
</form>
</div>