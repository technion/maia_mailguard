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

<div align="center">
  {capture assign=title}{$lang.header_domains_menu}&nbsp;
  <font size="3"><a href="adminhelp.php#domain_administration{$sid}" target="new">[?]</a></font>{/capture}
  {include file="settings/_userlist-table.tpl" user=$domains show_delete=$super user_header=$lang.header_domain title=$title}
</div>
</form>

{if $super}
<p>&nbsp;</p>

{form action="xadmindomains.php$sid" name="admindomains"}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menubanner" align="center">{$lang.header_add_domain}&nbsp;
<font size="3"><a href="adminhelp.php#add_domain{$sid}" target="new">[?]</a></font></td>
</tr>

<tr>
<td class="menubody" align="center">{$lang.text_new_domain_name}:&nbsp;
<input type="text" name="newdomain" size="50" value="@"></td>
</tr>

<tr>
<td class="menubody" align="center">
<input type="submit" name="adddomain" value=" {$lang.button_add_domain} ">
</td>
</tr>

</table></div>
</form>
{/if}

<div align="center">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}