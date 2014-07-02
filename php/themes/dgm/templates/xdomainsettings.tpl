{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<div class="panel1 outy" align="center">
{$message}
</div>

<p>&nbsp;</p>

<div align="center">
<a href="domainsettings.php{$msid}domain={$domain_id}">[{$lang.link_domain_settings}]</a>
</div>

{/capture}
{include file="container.tpl"}
