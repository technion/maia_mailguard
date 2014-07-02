{include file="login_head.tpl"}

<table border="0" cellspacing="2" cellpadding="2">
<tr>
<td valign="top" class="messagebox">
{$lang.text_login_failed1} ( {$message} )<br>
<a href="login.php?lang={$display_language}">{$lang.text_login_failed2}</a>
{$lang.text_login_failed3}
</td>
</tr>
</table>
</div><br>

{include file="login_foot.tpl"}
