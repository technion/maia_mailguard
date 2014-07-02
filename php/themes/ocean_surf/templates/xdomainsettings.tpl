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
<a href="domainsettings.php{$msid}domain={$domain_id}">[{$lang.link_domain_settings}]</a>
</div>

{include file="html_foot.tpl"}
