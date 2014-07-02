{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<form method="post" action="xadmindomains.php{$sid}" name="admindomains">

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td align="center" colspan="{$domaincols}">{$lang.header_domains_menu}&nbsp;
<font size="3"><a href="adminhelp.php#domain_administration{$sid}" target="new">[?]</a></font></td>
</tr>

    {if $domains}
    	<tr>
    	{if $super}
    	    <td class="panel2 outy" align="center">{$lang.header_delete}</td>
    	{/if}
    	<td class="panel2 outy" align="center">{$lang.header_domain}</td>
    	</tr>
        {foreach from=$domains item=domain}
            <tr>
            {if $super}
                <td class="inny" align="center">
                {if $domain.name == "@."}
                    {$lang.text_required}
                {else}
                    <input type="checkbox" name="{$domain.name}" value="{$domain.id}">
                {/if}
                </td>
            {/if}
            <td class="inny" align="center">
            <a href="domainsettings.php{$msid}domain={$domain.id}">
            {if $domain.name == "@."}
                {$lang.text_default} (@.)
            {else}
                {$domain.name}
            {/if}
            </a>
            </td>
            </tr>
        {/foreach}
        {if $super && $atleastone}
            <tr>
            <td align="center" colspan="2">
            <input type="submit" name="delete" value=" {$lang.button_delete} ">
            </td>
            </tr>
        {/if}
    {else}
    	{if $super}
    	    <tr><td class="inny" align="center" colspan="2">{$lang.text_no_domains_registered}</td></tr>
    	{else}
    	    <tr><td class="inny" align="center">{$lang.text_no_domains}</td></tr>
    	{/if}
    {/if}

</table></div>

{if $super}
<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td align="center">{$lang.header_add_domain}&nbsp;
<font size="3"><a href="adminhelp.php#add_domain{$sid}" target="new">[?]</a></font></td>
</tr>

<tr>
<td class="inny" align="center">{$lang.text_new_domain_name}:&nbsp;
<input type="text" name="newdomain" size="50" value="@"></td>
</tr>

<tr>
<td  align="center">
<input type="submit" name="adddomain" value=" {$lang.button_add_domain} ">
</td>
</tr>

</table></div>
{/if}


</form>

<div align="center">
<a href="admindex.php{$sid}">{$lang.link_admin_menu}</a>
</div>

{/capture}
{include file="container.tpl"}

