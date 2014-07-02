{include file="html_head.tpl"}

{if $message}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
<tr>
<td align="center" class="messagebox">
{$message}
</td>
</tr>
</table>
</div>
{/if}

{form action="xadmindomains.php$sid" name="admindomains"}
  {capture assign=title}{$lang.header_domains_menu}&nbsp;
  <font size="3"><a href="adminhelp.php#domain_administration{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></font>{/capture}
  {include file="settings/_userlist-table.tpl" user=$domains show_delete=$super user_header=$lang.header_domain title=$title}
</form>

{if $super}

{form action="xadmindomains.php$sid" name="admindomains"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_add_domain} <a href="adminhelp.php#add_domain{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
  <li>
    <label for="newdomain_input">{$lang.text_new_domain_name}:</label>
    <input type="text" id="newdomain_input" name="newdomain" size="40" value="@">
  </li>
  <li class="submitrow">
    <input type="submit" name="adddomain" value="{$lang.button_add_domain}">
  </li>
</ol>
</fieldset>
</div>
</form>
{/if}


<div class="styledform">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}