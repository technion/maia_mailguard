{include file="html_head.tpl"}
{if $submitted}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
<tr>
<td valign="top" class="messagebox" align="left">
{$lang.text_auto_creation}
{$lang.text_auto_passwords}
<br>
{$lang.text_instructions}
<br>
{$error}
</td>
</tr>
</table>
</div><br>

<div align="center">
<a href="login.php?lang={$display_language}&charset={$html_charset}">[ {$lang.link_login} ]</a>
</div>
{else}
<form method="post" action="internal-init.php">

<div align="center">
<table border="0" cellspacing="2" cellpadding="2">

<tr>
<td class="menuheader" align="center" colspan="2">
{$lang.header_initial_settings}
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_newuser_template_file}:</td>
<td class="menubody" align="left">
<input type="text" name="newuser_template_file" value="{$newuser_template_file}" size="60">
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_reminder_login_url}:</td>
<td class="menubody" align="left">
<input type="text" name="reminder_login_url" value="{$reminder_login_url}" size="60">
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_admin_email}:</td>
<td class="menubody" align="left">
<input type="text" name="admin_email" value="{$admin_email}" size="60">
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_your_email}:</td>
<td class="menubody" align="left">
<input type="text" name="your_email" value="" size="60">
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_trusted_mail_server}:</td>
<td class="menubody" align="left">
<input type="text" name="trusted_server" value="{$trusted_server}" size="60">
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_trusted_mail_server_port}:</td>
<td class="menubody" align="left">
<input type="text" name="trusted_port" value="{$trusted_port}" size="60">
</td>
</tr>

<tr>
<td class="menubody" align="center" colspan="2">
<input type="submit" name="submit" value=" {$lang.button_initialize} "></td>
</tr>

</table>
</div>

</form>

{/if}

{include file="html_foot.tpl"}