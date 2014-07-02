{include file="html_head.tpl"}

<div id="messagebox">
{if $message}
<div class="messagebox" align="center">
{$message}
</div>
{/if}
</div>

<p>&nbsp;</p>

<div align="center">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}
