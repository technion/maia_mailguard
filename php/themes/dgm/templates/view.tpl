{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/viewmail.css">
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/cache_buttons.css">
{/capture}

{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}
{if ! $error}
<div class="viewmail_container">
<form action="list-cache.php{$msid}cache_type={$cache_type}" name="cache" method="post">
<input type="hidden" name="cache_item[generic][{$id}]" value="{$id}">

<div class="viewmail_table">
{include file="viewmail_menu.tpl" showraw=true}
{include file="display_spam_report.tpl"}
<div class="viewmail_body">
{$message}
</div>
{include file="viewmail_menu.tpl" showraw=true}
</div>
</form>
</div>

{else}

{* Error!  Mail doesn't belong to this user! *}
<div class="viewmail_table">
{$error}
</div>
{/if}
{/capture}
{include file="container.tpl"}
