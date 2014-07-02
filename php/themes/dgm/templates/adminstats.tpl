{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<form method="post" action="xadminstats.php{$sid}" name="adminstats">
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3" align="center" colspan="2">{$lang.header_reset_stats}&nbsp;
<font size="3"><a href="adminhelp.php#reset_statistics{$sid}" target="new">[?]</a></font>
</td>
</tr>

<tr>
<td class="panel2" align="left">{$lang.text_reset_user_stats}</td>
<td class="panel2" align="center">
<input type="submit" name="reset_users" value=" {$lang.button_reset} ">
</td>
</tr>

<tr>
<td class="panel2" align="left">{$lang.text_reset_virus_stats}</td>
<td class="panel2" align="center">
<input type="submit" name="reset_viruses" value=" {$lang.button_reset} ">
</td>
</tr>

<tr>
<td class="panel2" align="left">{$lang.text_reset_rule_stats}</td>
<td class="panel2" align="center">
<input type="submit" name="reset_rules" value=" {$lang.button_reset} ">
</td>
</tr>

<tr>
<td class="panel2" align="left">{$lang.text_reset_all_stats}</td>
<td class="panel2" align="center">
<input type="submit" name="reset_all" value=" {$lang.button_reset} ">
</td>
</tr>

</table></div>
</form>

<div align="center">
<a href="admindex.php{$sid}">[ {$lang.link_admin_menu} ]</a>
</div>

{/capture}
{include file="container.tpl"}
